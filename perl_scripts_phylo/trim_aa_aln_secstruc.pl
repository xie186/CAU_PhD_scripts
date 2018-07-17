#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($phy, $cut, $id_secstruc, $pdb_info, $out) = @ARGV;
sub usage{
    my $die =<<DIE;
perl *.pl <phy> <cut> <id with struc> <struc info> <OUT> 
DIE
}

my %rec_phy;
my %rec_stable;   ### record PYR postion and no trim
open PHY, $phy or die "$!";
my $header = <PHY>;
chomp $header;
my ($num, $len) = split(/\s+/, $header);
while(<PHY>){
    chomp;
    my ($id, $seq) = split(/\s+/, $_);
    my @seq = split(//, $seq);
    for(my $i = 0; $i < @seq; ++$i){
        $rec_phy{$i} ++ if $seq[$i] eq "-";
        if($id eq $id_secstruc){
            $rec_stable{$i} ++ if $seq[$i] ne "-";
        }
    }
}
close PHY;

my %rec_trim;
for(my $i = 0; $i < $len;  ++$i){
    $rec_phy{$i} = 0 if !exists $rec_phy{$i};
    #print "$gap_perc\n";
    if($rec_phy{$i}/$num > $cut){
        $rec_trim{$i} ++ if !exists $rec_stable{$i};
    }
}

# record target gene seqeunces 
my $rec_struc_seq = "NA";

open OUT, "+>$out" or die "$!";
my $num_trim = keys %rec_trim;
my $len_after_trim = $len - $num_trim;
open PHY, $phy or die "$!";
$header = <PHY>;
print OUT "$num $len_after_trim\n";
while(<PHY>){
    chomp;
    my ($id, $seq) = split(/\s+/, $_);
    my @seq_after_trim;
    my @seq = split(//, $seq);
    for(my $i = 0; $i < @seq; ++$i){
        push @seq_after_trim, $seq[$i] if !exists $rec_trim{$i};
    }
    my $seq_after_trim = join("", @seq_after_trim);
    # record target gene seqeunces
    $rec_struc_seq = $seq_after_trim if $id eq $id_secstruc;
    print OUT "$id $seq_after_trim\n";
}
close PHY;
close OUT;

my @data_block;
my @rec_struc_seq = split(//, $rec_struc_seq);
open PDB, $pdb_info or die "$!";
my @pdb = <PDB>;

for(my $j = 0; $j < @pdb; ++ $j){
   my ($struc, $stt, $end)  = split(/\s+/, $pdb[$j]);
   my $index = 0;
   my ($tem_stt, $tem_end) = (0, 0);
   for(my $i = 0; $i < @rec_struc_seq; ++$i){
       my $pos = $i + 1;
       if($rec_struc_seq[$i] ne "-"){
            ## record non gap position
            $index++;
            if($index == $stt){
                $tem_stt = $pos;
 
                # thre first struct
                if($j == 0){
                    if($i != 0){
                        my $tem_end = $pos - 1; 
                        push @data_block, "gap0_pos = 1-$tem_end;";
                    }
                }
            }
            if($index == $end){
                $tem_end = $pos;   
                #the last struct             
                if($j == @pdb -1){
                    my $len = @rec_struc_seq;
                    if($i < $len -1){
                        push @data_block, "gapend_pos = $i-$len;";
                    }
                }
            }
       }
   }
   push @data_block, "$struc\_pos = $tem_stt-$tem_end;";
}

my $data_block = join("\n", @data_block);
print <<CFG;
## ALIGNMENT FILE ##
alignment = $out;

## BRANCHLENGTHS: linked | unlinked ##
branchlengths = linked;

## MODELS OF EVOLUTION for PartitionFinder: all | raxml | mrbayes | beast | <list> ##
##              for PartitionFinderProtein: all_protein | <list> ##
models = GTR+I+G;

# MODEL SELECCTION: AIC | AICc | BIC #
model_selection = BIC;

## DATA BLOCKS: see manual for how to define ##
[data_blocks]
$data_block
## SCHEMES, search: all | greedy | rcluster | hcluster | user ##
[schemes]
search = greedy;

#user schemes go here if search=user. See manual for how to define.#
CFG
