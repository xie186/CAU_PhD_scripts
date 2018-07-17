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
       if($pos % 3 == 0 && $rec_struc_seq[$i] ne "-"){
            $index++;
            if($index == $stt){
                $tem_stt = $pos;
                if($j == 0){
                    if($i != 0){
                        my $tem_end = $pos - 3;
                        if($tem_end != 0){ 
                            push @data_block, "gap0_pos1 = 1-$tem_end\\3;";
                            push @data_block, "gap0_pos2 = 2-$tem_end\\3;";
                            push @data_block, "gap0_pos3 = 3-$tem_end\\3;";
                        }
                    }
                }
            }
            if($index == $end){
                $tem_end = $pos;                
                if($j == @pdb -1){
                    my $len = @rec_struc_seq;
                    if($i < $len -1){
                        my $fir = $i - 2;
                        my $sec = $i - 1;
                        push @data_block, "gapend_pos1 = $fir-$len\\3;";
                        push @data_block, "gapend_pos2 = $sec-$len\\3;";
                        push @data_block, "gapend_pos3 = $i-$len\\3;";
                    }
                }
            }
       }
   }
   my $fir = $tem_stt - 2;
   my $sec = $tem_stt - 1;
   push @data_block, "$struc\_pos1 = $fir-$tem_end\\3;";
   push @data_block, "$struc\_pos2 = $sec-$tem_end\\3;";
   push @data_block, "$struc\_pos3 = $tem_stt-$tem_end\\3;";
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
