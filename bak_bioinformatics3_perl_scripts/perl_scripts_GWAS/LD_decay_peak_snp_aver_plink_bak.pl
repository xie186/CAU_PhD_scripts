#!/usr/bin/perl -w
use strict;
use Statistics::R;
die usage() unless @ARGV == 6;

my $bin = 100;
my $R = Statistics::R ->new();
my ($plink_ld, $peak_snp, $win ,$inbred_num, $r2_cut , $out) = @ARGV;
sub usage{
    my $die =<<DIE;
    perl *.pl <plink_ld> <peak snp> <win size> <inbred line nu> <r2 cut> <OUT>
DIE
}
 
my $date = `date`;
print "$date: reading hapmap\n";
open LD,$plink_ld or die "$!";
my %ld_r2;
while(<LD>){
    chomp;
    next if /CHR/;
    chomp;
    my ($chr1,$pos1,$index1,$chr2,$pos2,$index2,$r_sq) = split;
    next if $pos1 == $pos2;
    my $win_nu = int (abs($pos2-$pos1+1)/$bin) + 1;
    my $rela_pos = $win_nu * $bin - $bin/2; 
    @{$ld_r2{$index1} -> {$rela_pos}}[0] ++;
    @{$ld_r2{$index1} -> {$rela_pos}}[1] += $r_sq;
}

$date = `date`;
open OUT,"+>$out" or die "$!";
`mkdir ./chr_bin/` if !-e "./chr_bin/";
open PEAK,$peak_snp or die "$!";
while(<PEAK>){
    chomp;
    my ($chr,$pos) = split;
    $chr ="chr".$chr if $chr !~ /chr/;
        if(!exists $ld_r2{"$chr\_$pos"}){
            print "$chr\t$pos\t-\t-\tNA\n"; 
            next;
        }else{
            open TEM,"+>./chr_bin/$chr\_$pos.res" or die "$!";
            foreach my $rela_pos(keys %{$ld_r2{"$chr\_$pos"}}){
                my $aver_ld = @{$ld_r2{"$chr\_$pos"}->{$rela_pos}}[1] /  @{$ld_r2{"$chr\_$pos"}->{$rela_pos}}[0];
                print TEM "$chr\t-\t-\t$rela_pos\t$aver_ld\n";
            }
        }
        close TEM;

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
    print OUT "$chr\t$pos\t$coeffient\t-\t$ld_decay\n";
}

