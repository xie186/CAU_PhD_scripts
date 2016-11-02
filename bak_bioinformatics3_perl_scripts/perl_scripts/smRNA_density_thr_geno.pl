#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($geno_len,$smRNA,$len_cut,$out)=@ARGV;
open SM,$smRNA or die "$!";
my %hash_forw;
my %hash_rev;
while(<SM>){
    chomp;
    my ($len,$copy,$strand,$chr,$pos)=(split)[1,2,3,4,5];
    next if $len_cut!=$len;
    if($strand==0){
        $hash_forw{"$chr\t$pos"}+=$copy;
        print "$copy\n";
    }else{
        $pos=$pos+$len-1;
        $hash_rev{"$chr\t$pos"}+=$copy;
    }
}

open GENO,$geno_len or die "$!";
my %hash1;
while(<GENO>){
    chomp;
    my ($chr,$len)=split(/\s+/);
    $hash1{$chr}=$len;
}

open OUT,"+>$out" or die "$!";
foreach(keys %hash1){
    my $num=int $hash1{$_}/50000;
    for(my $i=0;$i<=$num;++$i){
        my ($rna_nu_forw,$rna_nu_rev)=(0,0);
        for(my $j=$i*50000;$j<=$i*50000+50000;++$j){
           if(exists $hash_forw{"$_\t$j"}){
               print "$hash_forw{\"$_\t$j\"}\n";
               $rna_nu_forw+=$hash_forw{"$_\t$j"};
           }
           if(exists $hash_rev{"$_\t$j"}){
               $rna_nu_rev+=$hash_rev{"$_\t$j"};
           }
        }
    my $win_stt=$i*50000;
    print OUT "$_\t$win_stt\t$rna_nu_forw\t$rna_nu_rev\n";
    }   
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Geno length> <smRNA table> <length cutoff> <OUT>
    <windows>  <Forward number> <Reverse number>
DIE
}
