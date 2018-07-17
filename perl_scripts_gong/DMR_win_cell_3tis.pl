#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 10;
my ($geno_len,$windows,$step,$alle1_ot,$alle1_ob,$alle2_ot,$alle2_ob, $alle3_ot,$alle3_ob, $out)=@ARGV;

open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    next if $chr !~ /\d/;
    $hash{$chr}=$len;
}

my %meth_alle1;
foreach my $bed ($alle1_ot,$alle1_ob){
    open ALLE1,"zcat $bed|" or die "$!";
    while(<ALLE1>){
        chomp;
        my ($chr,$pos1,$pos2,$depth,$lev)=split;
        next if ($depth < 4 || $depth > 100);
        @{$meth_alle1{"$chr\t$pos1"}}=($depth,$lev);
    }
    close ALLE1;
}

my %meth_alle2;
foreach my $bed($alle2_ot,$alle2_ob){
    open ALLE2,"zcat $bed|" or die "$!";
    while(<ALLE2>){
        chomp;
        my ($chr,$pos1,$pos2,$depth,$lev)=split;
        next if ($depth < 4 || $depth > 100);
        @{$meth_alle2{"$chr\t$pos1"}}=($depth,$lev);
    }
    close ALLE2;
}

my %meth_alle3;
foreach my $bed($alle3_ot,$alle3_ob){
    open ALLE3,"zcat $bed|" or die "$!";
    while(<ALLE3>){
        chomp;
        my ($chr,$pos1,$pos2,$depth,$lev)=split;
        next if ($depth < 4 || $depth > 100);
        @{$meth_alle3{"$chr\t$pos1"}}=($depth,$lev);
    }
    close ALLE3;
}

open OUT,"+>$out" or die "$!";
foreach my $chrom(sort keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1,($i-1)*$step+$windows);
        my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,  $c_cover_alle2,$c_nu_alle2,$t_nu_alle2,  $c_cover_alle3,$c_nu_alle3,$t_nu_alle3)=&get($chrom,$stt,$end);
        next if ($c_cover_alle1 < 4 || $c_cover_alle2 < 4 || $c_cover_alle3 < 4);
        print OUT "$chrom\t$stt\t$end\t$c_cover_alle1\t$c_nu_alle1\t$t_nu_alle1\t$c_cover_alle2\t$c_nu_alle2\t$t_nu_alle2\t$c_cover_alle3\t$c_nu_alle3\t$t_nu_alle3\n";
    }
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2, $c_cover_alle3,$c_nu_alle3,$t_nu_alle3)=(0,0,0, 0,0,0, 0,0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $meth_alle1{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle1{"$chrom\t$i"}});
            $c_nu_alle1 += $c_nu;
            $t_nu_alle1 += $t_nu;
            ++ $c_cover_alle1;
        }
        if(exists $meth_alle2{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle2{"$chrom\t$i"}});
            $c_nu_alle2 += $c_nu;
            $t_nu_alle2 += $t_nu;
            ++ $c_cover_alle2;
        }
	if(exists $meth_alle3{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle3{"$chrom\t$i"}});
            $c_nu_alle3 += $c_nu;
            $t_nu_alle3 += $t_nu;
            ++ $c_cover_alle3;
        }
    }
    return ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1, $c_cover_alle2,$c_nu_alle2,$t_nu_alle2, $c_cover_alle3,$c_nu_alle3,$t_nu_alle3);
}

sub cal_CT{
    my ($depth,$lev) = @_;
    my ($c_nu,$t_nu) = (int($depth*$lev/100+0.5) , $depth - (int($depth*$lev/100+0.5)));
#    print "$depth,$lev \t $c_nu, $t_nu \n";
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <Windows size> <Step size> <allele1 OT> <OB> <allele2 OT> <OB> <allele3 OT> <OB> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> {allele1 <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>} {allele2 <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>}

DIE
}
