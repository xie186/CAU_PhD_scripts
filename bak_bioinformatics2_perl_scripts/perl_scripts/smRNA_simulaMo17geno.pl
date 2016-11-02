#!/usr/bin/perl -w
use strict;
my $die=<<DIE;
perl *.pl <SNP><GENO>< OUT simulate_genome>.
DIE
die "\n$die\n" unless @ARGV==3;
open SNP,$ARGV[0] or die;

my %snp;
while(<SNP>){
    chomp $_;
    my ($chr,$pos,$baseB,$baseMo)=(split(/\s+/,$_))[0,1,3,4];
#    print "$chr,$pos,$baseB,$baseMo\n";
    @{$snp{"$chr\t$pos"}}=($baseB,$baseMo);
}

open GENO,$ARGV[1] or die;
my @geno=<GENO>;
my $seq=join('',@geno);
   $seq=~s/>//;
   @geno=split(/>/,$seq);
   $seq=1;
my $nu=@geno;
my %hash;
for(my $i=1;$i<=$nu;++$i){
    my $tem=shift @geno;
    my ($chr,@seq)=split(/\n/,$tem);
    chomp @seq;
    $tem=join('',@seq);
    $hash{$chr}=$tem;
}

print "go go go!";
open OUT,"+>$ARGV[2]" or die;
foreach(sort keys %hash){
    my $seq=$hash{$_};
    print "$seq\n";
    my $mo17="";
    for(my $i=1;$i<=length $seq;++$i){
        my $base=substr($seq,$i-1,1);
        if(exists $snp{"$_\t$i"}){
            print "$base\t@{$snp{\"$_\t$i\"}}\n";
            $mo17.=${$snp{"$_\t$i"}}[-1];
        }else{
            $mo17.="$base";
        }
    }
    print OUT ">$_\n$mo17\n";
}
close OUT;
