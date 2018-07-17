#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($te) = @ARGV;
open TE,$te or die "$!";
<TE>;
while(<TE>){
    chomp;
    my ($chr,$strand,$stt,$end,$type1,$type2) = split;
    my $TE_name = $chr;
    ($chr) = $chr =~ /AT(\d+)TE/;
    $chr ="chr".$chr;
    $strand =~s/false/-/;
    $strand =~s/true/+/;
    #chr1    TAIR10  gene    3631    5899    .       +       .       ID=AT1G01010;Note=protein_coding_gen
    #chr1    TAIR10  mRNA    3631    5899    .       +       .       ID=AT1G01010.1;Parent=AT1G01010;Name=AT1G01010.1;Index=1
    #
    #chr1    TAIR10  exon    3631    3913    .       +       .       Parent=AT1G01010.1
    print "$chr\tTAIR10\tgene\t$stt\t$end\t.\t$strand\t.\tID=$TE_name;Note=Transposable_element;Name=$TE_name\n";
    print "$chr\tTAIR10\tmRNA\t$stt\t$end\t.\t$strand\t.\tID=$TE_name.1;Note=$TE_name;Name=$TE_name.1:Index=1\n";
    print "$chr\tTAIR10\texon\t$stt\t$end\t.\t$strand\t.\tParent=$TE_name.1\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <TE> 
DIE
}
