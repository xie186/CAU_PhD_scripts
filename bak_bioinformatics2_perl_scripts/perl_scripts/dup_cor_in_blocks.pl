#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($rpkm)=@ARGV;
open RPKM,$rpkm or die "$!";
my %hash;
while(<RPKM>){
    chomp;
    my ($id_blocks,$id_ge1,$gene1,$rpkm1,$gene2,$rpkm2)=split;
    @{$hash{$id_blocks}}=($rpkm1,$rpkm2);
}

foreach(keys %hash){
    my @rpkm1;
    my @rpkm2;
    for(my $i=0;$i<@{$hash{$_}};++$i){
        push @rpkm1,${$hash{$_}}[0];
        push @rpkm2,${$hash{$_}}[1];
    }
    my $rpkm1=join(",",@rpkm1);
    my $rpkm2=join(",",@rpkm2);

    my ($cor,$p_value)=&correlation($rpkm1,$rpkm2);
    print "$cor\t$p_value\n"; 
}

sub correlation{
    my ($rpkm1,$rpkm2)=@_;
    open R,"+>dup_cor_test.R";
    print R "rpkm1<-c\($rpkm1\)\nrpkm2<-c\($rpkm2\)\ncor.test(rpkm1,rpkm2,method='spearman')";
    my $report=`R --vanilla --slave <dup_cor_test.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    
    return ($correla,$p_value);
}

sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM of duplicated gene>
DIE
}
