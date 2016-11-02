#!/usr/bin/perl -w
use strict;

my ($cpg_ot,$chg_ot,$chh_ot,$chh_ob,$geno)=@ARGV;

open SEQ,$geno or die "$!";
<SEQ>;
my $seq = <SEQ>;

my %hash_cut;
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

open CHHOT,$chh_ot or die "$!";
my %hash_chh;
while(<CHHOT>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if ($depth<3 || $lev < 80);
#    $hash_chh{"$stt"}=$lev if $lev>=80;
    &chh_ot($stt);
}

open CHHOB,$chh_ob or die "$!";
while(<CHHOB>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if ($depth<3 && $lev < 80) ;
#    $hash_chh{"$stt"}=$lev if $lev>=80;
    &chh_ob($stt);
}

my @cut_pos=sort{$a<=>$b}(keys %hash_cut);
my $id=1;
for(my $i=0;$i<@cut_pos;++$i){
    my $len=$cut_pos[$i+1]-$cut_pos[$i];
    print "$id\t$cut_pos[$i+1]\t$cut_pos[$i]\t$len\n";
    ++$id;
}

sub cpg_ot{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-1,4);
    print "Wrong!!!\n" if $tem_seq !~ /CG[ATGC][ATGC]/;
    #print "$tem_seq\n";
    my $flag=0;
    if($tem_seq =~ /CG[ATGC][GA]/){
        $hash_cut{$pos+16}++;
    }
}

sub cpg_ob{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-3,4);
    print "Wrong!!!" if $tem_seq !~ /[ATGC][ATGC]CG/;
#    print "$tem_seq\n";
    my $flag=0;
    if($tem_seq =~ /[CT][ATGC]CG/){
        $hash_cut{$pos-15}++;
    }
}
sub chg_ot{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-1,4);
    print "Wrong!!!" if $tem_seq !~ /C[ATC]G[ATGC]/;
#    print "$tem_seq\n";
    my $flag=0;
    if($tem_seq =~ /C[ATC]G[GA]/){
        $hash_cut{$pos+16}++;
    }
}

sub chg_ob{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-2,4);
    print "Wrong!!!" if $tem_seq !~ /[ATGC]C[ATC]G/;
    my $flag=0;
    if($tem_seq =~ /[CT]C[ATC]G/){
        $hash_cut{$pos-14} ++ ;
    }
}
sub chh_ot{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-1,4);
    print "Wrong!!!" if $tem_seq !~ /C[ATC][ATC][ATGC]/;
#    print "$tem_seq\n";
    my $flag=0;
    if($tem_seq =~ /C[ATC][ATC][GA]/){
        $hash_cut{$pos+16}++;
    }
}
sub chh_ob{
    my ($pos)=@_;
    my $tem_seq = substr($seq,$pos-4,4);
    print "Wrong!!!" if $tem_seq !~ /[ATGC][TAG][TAG]G/;
#    print "$tem_seq\n";
    my $flag=0;
    if($tem_seq =~ /[CT][TAG][TAG]G/){
        $hash_cut{$pos-16}++;
    }
}
