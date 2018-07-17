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

open OUT,"+>$out" or die "$!";
open CAND, $dmr or die "$!";
while(<CAND>){
    chomp;
    my ($chrom,$stt,$end) = split;
    my ($tot_num , $aver_dmc_diff, $eadge_left, $eadge_right)=&get($chrom,$stt,$end);
    if($tot_num >=10 && ($aver_dmc_diff > 2 || $aver_dmc_diff < 1/2)){
        print OUT "$chrom\t$eadge_left\t$eadge_right\t$tot_num\t$aver_dmc_diff\n";
    }
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my %rec_DMC;
    my ($sum_lev1, $sum_lev2) = (0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $meth_alle1{"$chrom\t$i"} && exists $meth_alle2{"$chrom\t$i"}){
            my ($dep1, $lev1) = @{$meth_alle1{"$chrom\t$i"}};
            my ($dep2, $lev2) = @{$meth_alle2{"$chrom\t$i"}};
            $sum_lev1 += $lev1;
            $sum_lev2 += $lev2;
            if($lev1/($lev2 + 0.00001) > 2 || $lev2/($lev1 + 0.00001) > 2){
                $rec_DMC{$i} ++; # record DMCs
            }
        }
    }
    my $tot_num = keys %rec_DMC;
    my $aver_dmc_diff = $sum_lev1/($sum_lev2 + 0.00001); 
    my ($eadge_left, $eadge_right) = (sort {$a<=>$b} keys %rec_DMC)[0, -1];
    return ($tot_num , $aver_dmc_diff, $eadge_left, $eadge_right);
}

sub cal_CT{
    my ($depth,$lev) = @_;
    my ($c_nu,$t_nu) = (int($depth*$lev/100+0.5) , $depth - (int($depth*$lev/100+0.5)));
#    print "$depth,$lev \t $c_nu, $t_nu \n";
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <DMR candidate> <allele1 OT> <OB> <allele2 OT> <OB> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> <DMC number> <average diff> 

DIE
}
