#!/usr/bin/perl -w
use strict;
use Statistics::R;
die usage() unless @ARGV == 7;

my $bin = 100;
my $R = Statistics::R ->new();
my ($hapmap, $peak_snp, $plink_ld, $win ,$inbred_num, $r2_cut , $out) = @ARGV;
sub usage{
    my $die =<<DIE;
    perl *.pl <hapmap> <peak snp> <plink_ld> <win size> <inbred line nu> <r2 cut> <OUT>
DIE
}

open LD,$plink_ld or die "$!";
my %ld_r2;
while(<LD>){
    chomp;
    next if /CHR/;
    chomp;
    my ($chr1,$pos1,$index1,$chr2,$pos2,$index2,$r_sq) = split;
    next if $pos1 == $pos2;
    $ld_r2{"$index1\t$index2"} = $r_sq;
}

open PEAK,$peak_snp or die "$!";
my %tem_pos;
while(<PEAK>){
    chomp;
#    my ($chr,$pos,$maf,$p_log) = split;
    my ($chr,$pos) = split;
    for(my $i = $pos - $win; $i <= $pos + $win; ++$i){
        $chr ="chr".$chr if $chr !~ /chr/;
        next if $pos == $i;
        $tem_pos{"$chr\t$i"} ++;
    }
}
close PEAK;

my $date = `date`;
print "$date: reading hapmap\n";
open HAP,$hapmap or die "$!";
my %hash_hap;
while(<HAP>){
    chomp;
    my ($rs,$alle,$chr,$pos,$strand) = split;
    $chr ="chr".$chr if $chr !~ /chr/;
#    print "$rs,$alle,$chr,$pos,$strand\n";
    if(exists $tem_pos{"$chr\t$pos"}){
        $hash_hap{"$chr\t$pos"} = $_ ;
    }
}

$date = `date`;
print "$date: calculating ld decay\n";
open OUT,"+>$out" or die "$!";
`mkdir ./chr_bin/` if !-e "./chr_bin/";
open PEAK,$peak_snp or die "$!";
my %hash_peak_ld;
while(<PEAK>){
    chomp;
    $date = `date`;
    print "$date: calculating ld decay\t$_\n";
    my ($chr,$pos) = split;
    $chr ="chr".$chr if $chr !~ /chr/;
    my $snp_nu = 0;

    my @tem_hapmap;    
    for(my $i = $pos - $win; $i <= $pos + $win; ++$i){
        if(exists $hash_hap{"$chr\t$i"}){
            push @tem_hapmap, $hash_hap{"$chr\t$i"}; 
            ++ $snp_nu;
        }
    }
    my $keys = join("\t",@tem_hapmap);
    if(exists $hash_peak_ld{$keys}){
        print OUT "$chr\t$pos\t$hash_peak_ld{$keys}\n";    
        next;
    }
    if($snp_nu <= 30){
        print OUT "$chr\t$pos\tNA\t$snp_nu\tNA\n";
        next;
    }
        open TEM,"+>./chr_bin/$chr\_$pos.res" or die "$!";
        my %tem_bin_r2;
        for(my $i = 0; $i < $snp_nu ; ++ $i){
            my $geno1 = $tem_hapmap[$i];
#            print "$chr\t$pos\txx$i\n";
            my ($rs1, $alle1, $chr1, $pos1, $strand1) = split(/\t/, $geno1);
            for(my $j = $i + 1 ; $j < $snp_nu ; ++$j){
                my $geno2 = $tem_hapmap[$j];
                my ($rs2, $alle2, $chr2, $pos2, $strand2) = split(/\t/, $geno2);
                my ($r2) = $ld_r2{"$rs1\t$rs2"};
                my $win_nu = int (($pos2-$pos1+1)/$bin) + 1;
                $tem_bin_r2{$win_nu}[0] ++;
                $tem_bin_r2{$win_nu}[1] += $r2;           
            }
        }
    
        foreach(sort{$a<=>$b}keys %tem_bin_r2){
            my $pos = $_ * $bin - $bin/2;                 # $_  bin bumber 
            my $aver_ld = $tem_bin_r2{$_}[1] / $tem_bin_r2{$_}[0];
            print TEM "$chr\t-\t-\t$pos\t$aver_ld\n";
        }

    my $cmd = <<EOF;
ld<-read.table("./chr_bin/$chr\_$pos.res")
n = $inbred_num
ld.decay<-nls(V5 ~ ((10+C*V4)/((2+C*V4)*(11+C*V4)))*(1+((3+C*V4)*(12+12*C*V4+(C*V4)^2))/($inbred_num*(2+C*V4)*(11+C*V4))), data = ld , start = list(C = 0.1),control=nls.control(maxiter=100),trace=TRUE)
coeffient <- coef(ld.decay)
r2_cut <- c("$r2_cut")
if(r2_cut == "half"){
    r2_cut <- max(ld[,5])/2
}else if(r2_cut == "0.1"){
    r2_cut <- as.numeric(r2_cut)
}else{
    print ("r2_cut was wrong!!!")
    q("yes")
}

f <- function(x)((10+coeffient*x)/((2+coeffient*x)*(11+coeffient*x)))*(1+((3+coeffient*x)*(12+12*coeffient*x+(coeffient*x)^2))/(628*(2+coeffient*x)*(11+coeffient*x))) - r2_cut
dis_ld_decay <- uniroot(f, interval = c(0,200000))\$root
EOF
    my $run = $R ->run($cmd);
    my $ld_decay = $R -> get("dis_ld_decay");
    my $coeffient = $R -> get("coeffient");
    print OUT "$chr\t$pos\t$coeffient\t$snp_nu\t$ld_decay\n";
    $hash_peak_ld{$keys} = "$coeffient\t$snp_nu\t$ld_decay";
}

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

