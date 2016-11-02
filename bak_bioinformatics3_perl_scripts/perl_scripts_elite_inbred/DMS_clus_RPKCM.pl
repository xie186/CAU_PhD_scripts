#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($meth_infor, $rpkcm) = @ARGV;

open RPKCM,$rpkcm or die "$!";
#gene_id smRNA_seq_8112 smRNA_seq_5003 smRNA_seq_478
my $smRNA_head = <RPKCM>;
my %rpkcm_val;
$smRNA_head=~s/gene_id\t//;
while(<RPKCM>){
    chomp;
    my ($gene_id, @value) = split;
    my ($chr,$stt,$end) = split(/_/,$gene_id);
    $rpkcm_val{"$chr\t$stt\t$end"} = join("\t", @value);
}
close RPKCM;

open METH,$meth_infor or die "$!";
my $head = <METH>;
chomp $head;
print "$head\t$smRNA_head";
while(<METH>){
    chomp;
    my ($chr,$stt,$end,@meth_lev) = split;
    print "$_\t$rpkcm_val{\"$chr\t$stt\t$end\"}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <meth_infor> <rpkcm> 
DIE
}
