#!/usr/bin/perl -w
use strict;
my ($gepos,$tissue1,$tissue2,$out)=@ARGV;
die usage() unless @ARGV==4;

open POS,$gepos or die "$!";
my %hash;my ($rpkm_t1,$rpkm_t2)=(0,0);my @p_value;my @p_adjust;
while(<POS>){
    chomp;
    my ($gene)=(split)[-2];
    @{$hash{$gene}}=(0,0);
}

open T1,$tissue1 or die "$!"; 
while(<T1>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    ${$hash{$gene}}[0]=$rpkm;
    $rpkm_t1+=$rpkm;
}

open T2,$tissue2 or die "$!";
while(<T2>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    ${$hash{$gene}}[1]=$rpkm;
    $rpkm_t2+=$rpkm;
}

foreach(sort (keys %hash)){
    if (${$hash{$_}}[0]==0 && ${$hash{$_}}[1]==0){
        delete $hash{$_};
        next;
    }
    my ($fisher1,$fisher2,$fisher3,$fisher4)=(${$hash{$_}}[0],$rpkm_t1-${$hash{$_}}[0],${$hash{$_}}[1],$rpkm_t2-${$hash{$_}}[1]);
    my ($p_value)=&fisher($fisher1,$fisher2,$fisher3,$fisher4);
    ${$hash{$_}}[2]=$p_value;
    push (@p_value,$p_value);
}

my $p_adjust=join(',',@p_value);
open OUT,"+>DEG_padj_$tissue1.$tissue2.R" or die "$!";
print OUT "p_value<-c($p_adjust)\np.adjust(p_value,method=\"fdr\",length(p_value))";close OUT;
my @report=`R --vanilla --slave <DEG_padj_$tissue1.$tissue2.R`;
foreach(@report){
    my @aa=split(/\s+/,$_);
    foreach(@aa){
        next if (!$_ ||$_=~/\[\d+\]/);
        push(@p_adjust,$_);
    }
}
close OUT;

my $i=0;
my $nu1=(keys %hash);
my $nu2=(@p_adjust);
my $nu3=@p_value;
print "Wrong:Number of p_value is not equal\t$nu1\t$nu2\t$nu3!!\n" if (keys %hash)!=@p_adjust;
open OUT,"+>$out" or die "$!";
foreach(sort (keys %hash)){
    my $output=join("\t",@{$hash{$_}});
    print OUT "$_\t$output\t$p_adjust[$i]\n";
    ++$i;
}

sub fisher{
    my ($fisher1,$fisher2,$fisher3,$fisher4)=@_;
    open OUT,"+>DEG_$tissue1.$tissue2.R" or die "$!";
    print OUT "rpkm<-c($fisher1*100,$fisher2*100,$fisher3*100,$fisher4*100)\ndim(rpkm)=c(2,2)\nfisher.test(rpkm)\$p";
    close OUT;
    my $report=`R --vanilla --slave <DEG_$tissue1.$tissue2.R`;
    my $p_value=$report;
#    my ($p_value)=$report=~/p-value\s+[=<>]\s+(.*)\nalternative/;
    close OUT;
    return $p_value;
}

sub usage{
    my $die=<<DIE;

    perl  *.pl <Geneposition> <Tissue1 RPKM> <Tissue2 RPKM> <OUT>
    
DIE
}
