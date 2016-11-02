#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my $REGION = "region";  
my $PEAK = "peak";           ### calculate the max peak value
my $PEAK_HAP = "peak_hap";   ### record the hapmap of the max peak snp
my $HAP_SNP = "hap";         ### hapmap of the region
my ($hapmap,$group,$win) = @ARGV;
open GROUP,$group or die "$!";
my ($pheno,$r2_cut) = $group =~ /GAPIT.(.*).photype.peak_group.(.*).res/;
my @group = <GROUP>;
my $tem_group = join('',@group);
   @group = split(/###/,$tem_group);
shift @group;
my %group_region;
foreach(@group){
    my ($group_head,@peak_snp) = split(/\n/);
    if(/_ungroup_/){
        for(my $i = 0;$i<= $#peak_snp;++$i){
            my ($chr,$pos) = $peak_snp[$i] =~ /(chr\d+)\_(\d+)/;
            my ($stt,$end) = ($pos - $win/2,$pos + $win/2);
            $group_region{"ungrp\_$i"} ->{$REGION} = "$chr\t$stt\t$end";
            $group_region{"ungrp\_$i"} ->{$PEAK} = "$chr\t$pos";
        }
    }else{
        my ($grp_id,$chr,$stt,$end) = split(/\t/,$group_head);
           ($stt,$end) = ($stt - $win/2, $end + $win/2);
        $group_region{$grp_id} -> {$REGION} = "$chr\t$stt\t$end";
        my ($max_pos) = &max_peak(@peak_snp);
        $group_region{$grp_id} -> {$PEAK} = "$chr\t$max_pos";
    }
}

#open XX, "+>test.DTS.hapmap";
open HAP,$hapmap or die "$!";
while(<HAP>){
     chomp;
     &judge_snp($_);
}

foreach(keys %group_region){
    open OUT,"|sort -k1,1 -k2,2n > LD_grp.$pheno.$r2_cut.$_.r2" or die "$!";
    my ($chr1,$pos1) = split(/\t/,$group_region{$_} -> {$PEAK});
    foreach my $hap_snp(@{$group_region{$_}->{$HAP_SNP}}){
        my $tem_r2 = &r2($group_region{$_} -> {$PEAK_HAP} , $hap_snp);
        my ($rs2,$alle2,$chr2,$pos2) = split(/\t/,$hap_snp);
        print OUT "$chr1\t$pos1\t$chr2\t$pos2\t$tem_r2\n";
    }
}

sub r2{            ### calculate r2
    my ($geno1,$geno2)  = @_;
    my ($rs1,$alle1,$chr1,$pos1,$strand1,$assembly1,$center1,$protLSID1,$assayLSID1,$panel1,$QCcode1,@geno1) = split(/\t/,$geno1);
    my ($rs2,$alle2,$chr2,$pos2,$strand2,$assembly2,$center2,$protLSID2,$assayLSID2,$panel2,$QCcode2,@geno2) = split(/\t/,$geno2);
    my %hap_freq;
    my ($a1,$a2) = $alle1 =~ /(\w+)\/(\w+)/;
    my ($b1,$b2) = $alle2 =~ /(\w+)\/(\w+)/;
       $hap_freq{"$a1"."$a1\t$b1"."$b1"} =0;
       $hap_freq{"$a1"."$a1\t$b2"."$b2"} =0;
       $hap_freq{"$a2"."$a2\t$b1"."$b1"} =0;
       $hap_freq{"$a2"."$a2\t$b2"."$b2"} =0;
    my %alle_freq1;
    my %alle_freq2;
    my $sum = 0;
    for(my $i = 0;$i<=$#geno1;++$i){
        next if ($geno1[$i] =~ /N/ || $geno2[$i] =~ /N/);
        $alle_freq1{$geno1[$i]} ++;
        $alle_freq2{$geno2[$i]} ++;
        $hap_freq{"$geno1[$i]\t$geno2[$i]"} ++;
        ++ $sum;
    }
    my ($alle_freq1_high,$alle_freq1_low) = sort {$alle_freq1{$b}<=>$alle_freq1{$a}} keys %alle_freq1;
    my ($alle_freq2_high,$alle_freq2_low) = sort {$alle_freq2{$b}<=>$alle_freq2{$a}} keys %alle_freq2;
    my $hap_freq_hh = $hap_freq{"$alle_freq1_high\t$alle_freq2_high"} / $sum;
    my $alle_freq1_h = $alle_freq1{$alle_freq1_high} / $sum;
    my $alle_freq1_l = $alle_freq1{$alle_freq1_low} / $sum;
    my $alle_freq2_h = $alle_freq2{$alle_freq2_high} / $sum;
    my $alle_freq2_l = $alle_freq2{$alle_freq2_low} / $sum;
    my $r2 = ($hap_freq_hh - $alle_freq1_h * $alle_freq2_h )**2 / ($alle_freq1_h*$alle_freq1_l*$alle_freq2_h*$alle_freq2_l);
    return $r2;
}

sub judge_snp{   # get  the hapmap in the peak regions
    my ($hap_line) = @_;
    my ($rs,$allel,$chr,$pos) = split(/\t/,$hap_line);
    foreach(keys %group_region){
        my ($tem_chr,$stt,$end) = split(/\t/,$group_region{$_}->{$REGION});
        my ($peak_chr,$tem_pos) = split(/\t/,$group_region{$_}->{$PEAK});
        if($tem_chr eq $chr && $pos >= $stt && $pos <= $end){
#            print XX "$_\t$hap_line\n";
            push @{$group_region{$_}->{$HAP_SNP}} , $hap_line;
            $group_region{$_}->{$PEAK_HAP} = $hap_line if ($tem_pos == $pos);  ## get peak snp 
        }
    }
}

sub max_peak{     ### get max snp 
    my @peak_snp = @_;
    my ($pos,$p_log) = (0,0);
    foreach(@peak_snp){
        my ($snp_id,$tem_plog) = split(/\t/,$_);
        if($tem_plog > $p_log){
            $p_log = $tem_plog;
            my ($tem_chr,$tem_pos) = $snp_id =~ /(chr\d+)\_(\d+)/;
            $pos = $tem_pos;
        }
    }
    return $pos;
}

sub usage{
    my $die =<<DIE;
    perl *.pl  <hapmap> <peak SNPs> <window size> 
DIE
}
