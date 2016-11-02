#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;
my ($dmr,$alle1_ot,$alle1_ob,$alle2_ot,$alle2_ob,$out)=@ARGV;

my %meth_alle1;
foreach my $bed ($alle1_ot,$alle1_ob){
    open ALLE1,"zcat $bed|" or die "$!";
    while(<ALLE1>){
        chomp;
        my ($chr,$pos1,$pos2,$depth,$lev)=split;
        next if $depth<3;
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
        next if $depth<3;
        @{$meth_alle2{"$chr\t$pos1"}}=($depth,$lev);
    }
    close ALLE2;
}

open DMR,$dmr or die "$!";
open OUT,"+>$out" or die "$!";
while(<DMR>){
    chomp;
    my ($chr,$stt,$end) = split;
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2)=&get($chr,$stt,$end);
    my ($lev1,$lev2) = ( $c_nu_alle1 / ($c_nu_alle1 + $t_nu_alle1) , $c_nu_alle2 / ($c_nu_alle2 + $t_nu_alle2));
#    print OUT "$_\t$lev1\t$lev2\n";
    print OUT "$_\t$c_cover_alle1\t$c_cover_alle2\t$lev1\t$lev2\n";
}
close OUT;

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2)=(0,0,0,0,0,0);
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
    }
    return ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2);
}

sub cal_CT{
    my ($depth,$lev) = @_;
    my ($c_nu,$t_nu) = (int($depth*$lev/100+0.5) , $depth - (int($depth*$lev/100+0.5)));
#    print "$depth,$lev \t $c_nu, $t_nu \n";
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <DMR> <allele1 OT> <OB> <allele2 OT> <OB> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> <Level1> <Level2> 

DIE
}
