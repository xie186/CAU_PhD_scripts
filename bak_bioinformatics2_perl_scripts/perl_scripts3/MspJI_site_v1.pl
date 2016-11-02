#!/usr/bin/perl -w
use strict;

my ($cpg_ot,$chg_ot,$chh_ot,$chh_ob,$geno)=@ARGV;
open CGOT,$cpg_ot or die "$!";
my %hash_cpg;
while(<CGOT>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth<3;
    $hash_cpg{"$stt"}=$lev if $lev>=80;
}

open CHGOT,$chg_ot or die "$!";
my %hash_chg;
while(<CHGOT>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth<3;
    $hash_chg{"$stt"}=$lev if $lev>=80;
}

open CHHOT,$chh_ot or die "$!";
my %hash_chh;
while(<CHHOT>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth<3;
    $hash_chh{"$stt"}=$lev if $lev>=80;
}

open CHHOB,$chh_ob or die "$!";
while(<CHHOB>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth<3;
    $hash_chh{"$stt"}=$lev if $lev>=80;
}

open SEQ,$geno or die "$!";
<SEQ>;
my $seq = <SEQ>;

my $statis=0;
foreach(keys %hash_cpg){
    my $tem_seq = substr($seq,$_-3,6);
    print "Wrong!!!" if $tem_seq !~ /[ATGC][ATGC]CG[ATGC][ATGC]/;
    my $flag=0;
    if($tem_seq =~ /[CT][ATGC]CG[ATGC][GA]/){
#        for(my $i=$_-32;$i < $_+32;++$i){
#            ++$flag if (exists $hash_cpg{$i}  || exists $hash_chg{$i} || exists $hash_chh{$i});
#            ++$flag if (exists $hash_cpg{$i}  || exists $hash_chg{$i});
#        }
#        ++$statis if $flag == 1;
         ++$statis;
    }
}

foreach(keys %hash_chg){
    my $tem_seq = substr($seq,$_-2,4);
    print "Wrong!!!" if $tem_seq !~ /[ATGC]C[ATC]G[ATGC]/;
    my $flag=0;
    if($tem_seq =~ /[CT]C[ATC]G[GA]/){
#        for(my $i=$_-32;$i<$_+32;++$i){
        #    ++$flag if (exists $hash_cpg{$i}  || exists $hash_chg{$i} || exists $hash_chh{$i});
#            ++$flag if (exists $hash_cpg{$i}  || exists $hash_chg{$i});
#        }
#        ++$statis if $flag == 1;
         ++$statis;
    }
}

my $total= (keys %hash_chg)+(keys %hash_chg);
my $perc = $statis/ $total;
print "$perc\n";
