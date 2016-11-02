#!/usr/bin/perl -w
use strict;

my ($cpg_ot,$chg_ot,$chh_ot,$chh_ob,$geno)=@ARGV;

open SEQ,$geno or die "$!";
<SEQ>;
my $seq = <SEQ>;

open CGOT,$cpg_ot or die "$!";
my %hash_cpg;
while(<CGOT>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if ($depth<3 || $lev < 80);
    &cpg_ot($stt);
    &cpg_ob($stt);
}

open CHGOT,$chg_ot or die "$!";
my %hash_chg;
while(<CHGOT>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if ($depth<3 || $lev < 80);
    &chg_ot($stt);
    &chg_ob($stt);
}

my $statis=0;
foreach(keys %hash_cpg){
    my $tem_seq = substr($seq,$_-3,6); 
    next if (${$hash_cpg{$_}}[0] ==0 || ${$hash_cpg{$_}}[1] ==0);
    my $flag=0;
    for(my $i=$_-32;$i<$_;++$i){
        ++$flag if (exists $hash_cpg{$i} && ${$hash_cpg{$i}}[0]==1);
        ++$flag if (exists $hash_chg{$i} && ${$hash_chg{$i}}[0]==1);
    }
    for(my $i=$_+1;$i<$_+32;++$i){
        ++$flag if (exists $hash_cpg{$i} && ${$hash_cpg{$i}}[1] == 1);
        ++$flag if (exists $hash_chg{$i} && ${$hash_chg{$i}}[1] == 1);
    }
    ++$statis if $flag == 0;
}

foreach(keys %hash_chg){
    my $tem_seq = substr($seq,$_-2,4);
    next if (${$hash_chg{$_}}[0] ==0 || ${$hash_chg{$_}}[1] ==0);
    my $flag=0;
    for(my $i=$_-32;$i<$_;++$i){
        ++$flag if (exists $hash_cpg{$i} && ${$hash_cpg{$i}}[0] == 1);
        ++$flag if (exists $hash_chg{$i} && ${$hash_chg{$i}}[0] == 1);
    }
    for(my $i=$_+1;$i<$_+32;++$i){
        ++$flag if (exists $hash_cpg{$i} && ${$hash_cpg{$i}}[1] == 1);
        ++$flag if (exists $hash_chg{$i} && ${$hash_chg{$i}}[1] == 1);
    }
    ++$statis if $flag == 0;
}

my $total= (keys %hash_chg)+(keys %hash_chg);
my $perc = $statis/ $total;
print "$perc\n";

sub cpg_ot{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-1,4);
    print "Wrong!!!\n" if $tem_seq !~ /CG[ATGC][ATGC]/;
    my $flag=0;
    if($tem_seq =~ /CG[ATGC][GA]/){
        ${$hash_cpg{$pos}}[0] = 1;
    }else{
        ${$hash_cpg{$pos}}[0] = 0;
    }
}

sub cpg_ob{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-3,4);
    print "Wrong!!!" if $tem_seq !~ /[ATGC][ATGC]CG/;
    my $flag=0;
    if($tem_seq =~ /[CT][ATGC]CG/){
        ${$hash_cpg{$pos}}[1] = 1;
    }else{
        ${$hash_cpg{$pos}}[1] = 0;
    }
}
sub chg_ot{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-1,4);
    print "Wrong!!!" if $tem_seq !~ /C[ATC]G[ATGC]/;
    my $flag=0;
    if($tem_seq =~ /C[ATC]G[GA]/){
        ${$hash_chg{$pos}}[0] = 1;
    }else{
        ${$hash_chg{$pos}}[0] = 0;
    }
}

sub chg_ob{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-2,4);
    print "Wrong!!!" if $tem_seq !~ /[ATGC]C[ATC]G/;
    my $flag=0;
    if($tem_seq =~ /[CT]C[ATC]G/){
        ${$hash_chg{$pos}}[1] = 1;
    }else{
        ${$hash_chg{$pos}}[1] = 0;
    }
}
