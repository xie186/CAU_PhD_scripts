#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;

my ($hapmap,$peak_snp,$out) = @ARGV;
open PEAK,$peak_snp or die "$!";
my %peak_snp;
while(<PEAK>){
    chomp;
    my ($chr,$pos,$maf,$p_log) = split; 
    $chr =~s/chr//g;
    $peak_snp{"$chr\t$pos"} = $p_log;
}
close PEAK;

my ($max_keys) = sort {$peak_snp{$b}<=>$peak_snp{$a}} keys %peak_snp;
#my ($max_values) = sort {$peak_snp{$b}<=>$peak_snp{$a}} values %peak_snp;
print "$max_keys\t$peak_snp{$max_keys}\n";

open OUT,"+>$out" or die "$!";
open HAP,"sort -k4,4n $hapmap|" or die "$!";
my %hapmap;
while(<HAP>){
    chomp;
    my ($rs,$geno,$chr,$pos) = split;
    $chr =~ s/chr//g;
    $hapmap{"$chr\t$pos"} = $_;
}

open PEAK,$peak_snp or die "$!";
while(<PEAK>){
    chomp;
    my ($chr,$pos,$maf,$p_log) = split;
    $chr =~s/chr//g;
    my ($r2) = &r2($hapmap{$max_keys}, $hapmap{"$chr\t$pos"});
    print OUT "$_\t$r2\n";
}
close PEAK;

sub r2{
    my ($geno1,$geno2)  = @_;
    chomp $geno1;
    chomp $geno2;
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
#    print "$a1,$a2,$b1,$b2,$alle_freq1_high,$alle_freq1_low, xx$alle_freq2_high,$alle_freq2_low\n";
#    print "$alle_freq1_high\t$alle_freq2_high\n"; 
    my $hap_freq_hh = $hap_freq{"$alle_freq1_high\t$alle_freq2_high"} / $sum;
    my $alle_freq1_h = $alle_freq1{$alle_freq1_high} / $sum;
    my $alle_freq1_l = $alle_freq1{$alle_freq1_low} / $sum;
    my $alle_freq2_h = $alle_freq2{$alle_freq2_high} / $sum;
    my $alle_freq2_l = $alle_freq2{$alle_freq2_low} / $sum;
#    print "($hap_freq_hh - $alle_freq1_h * $alle_freq2_h )**2 / ($alle_freq1_h*$alle_freq1_l*$alle_freq2_h*$alle_freq2_l)\n";
    my $r2 = ($hap_freq_hh - $alle_freq1_h * $alle_freq2_h )**2 / ($alle_freq1_h*$alle_freq1_l*$alle_freq2_h*$alle_freq2_l);
    return $r2;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <hapmap> <GWAS log(p) > <out r2 to the top SNPs>
DIE
}
