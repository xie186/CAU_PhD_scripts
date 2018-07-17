#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($phy, $cut, $out) = @ARGV;
sub usage{
    my $die =<<DIE;
perl *.pl <phy> <cut> <OUT> 
DIE
}
my %rec_phy;
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
    }
}
close PHY;

my %rec_trim;
for(my $i = 0; $i < $len;  ++$i){
    $rec_phy{$i} = 0 if !exists $rec_phy{$i};
    #print "$gap_perc\n";
    if($rec_phy{$i}/$num > $cut){
        $rec_trim{$i} ++;
    }
}

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
    print OUT "$id $seq_after_trim\n";
}
close PHY;
close OUT;

my @data_block;
for(my $i = 1; $i < $len_after_trim; $i += 3){
    my $end = $i +2;
    my $sec = $i + 1;
    push @data_block, "Gene$i\_pos1 = $i   - $end\\3;";
    push @data_block, "Gene$i\_pos2 = $sec - $end\\3;";
    push @data_block, "Gene$i\_pos3 = $end - $end\\3;";
}
my $data_block = join("\n", @data_block);
print <<CFG;
## ALIGNMENT FILE ##
alignment = OneKP_pnas_84spec_plusEnsembl_plusAt_cds_trim.phy;

## BRANCHLENGTHS: linked | unlinked ##
branchlengths = linked;

## MODELS OF EVOLUTION for PartitionFinder: all | raxml | mrbayes | beast | <list> ##
##              for PartitionFinderProtein: all_protein | <list> ##
models = all;

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
