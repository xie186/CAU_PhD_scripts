#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==8;
my ($tis,$cpg_ot,$cpg_ob,$chg_ot,$chg_ob,$chh_ot,$chh_ob,$out)=@ARGV;

open OUT,"+>$out" or die "$!";
my (@hash_cpg,@hash_chg,@hash_chh,@hash_all);
foreach($cpg_ot,$cpg_ob){
    open BED,$_ or die "$!";
    while(my $line=<BED>){
        chomp $line;
        my ($chr,$stt,$end,$depth,$lev)=split(/\t/,$line);
	next if ($chr =~ /chr11/ || $chr =~ /chr0/ || $chr =~ /chr10/);
        $hash_cpg[0] += $depth;
        $hash_cpg[1] += $depth*$lev/100;
        $hash_all[0] += $depth;
        $hash_all[1] += $depth*$lev/100;
    }
    close BED;
}

foreach($chg_ot,$chg_ob){
    open BED,$_ or die "$!";
    while(my $line=<BED>){
        chomp $line;
        my ($chr,$stt,$end,$depth,$lev)=split(/\t/,$line);
 	next if ($chr =~ /chr11/ || $chr =~ /chr0/ || $chr =~ /chr10/);
        $hash_chg[0] += $depth;
        $hash_chg[1] += $depth*$lev/100;
        $hash_all[0] += $depth;
        $hash_all[1] += $depth*$lev/100;
    }
    close BED;
}

foreach($chh_ot,$chh_ob){
    open BED,$_ or die "$!";
    while(my $line=<BED>){
        chomp $line;
        my ($chr,$stt,$end,$depth,$lev)=split(/\t/,$line);
	next if ($chr =~ /chr11/ || $chr =~ /chr0/ || $chr =~ /chr10/);
        $hash_chh[0] += $depth;
        $hash_chh[1] += $depth*$lev/100;
        $hash_all[0] += $depth;
        $hash_all[1] += $depth*$lev/100;
    }
    close BED;
}

my $meth_cpg = $hash_cpg[1] / $hash_cpg[0];
my $meth_chg = $hash_chg[1] / $hash_chg[0];
my $meth_chh = $hash_chh[1] / $hash_chh[0];
my $meth_all = $hash_all[1] / $hash_all[0];
print OUT "$tis\t$meth_all\t$meth_cpg\t$meth_chg\t$meth_chh\n";
sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <CpG_OT> <CpG_OB> <CHG_OB> <CHG_OT> <CHH_OB> <CHH_OT> <OUT>
DIE
}


