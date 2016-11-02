#!/usr/bin/perl -w
use strict;
use Statistics::R;
die usage() unless @ARGV == 4;
my ($win_bin,$chr,$n,$r2_cut) = @ARGV;

my $R = Statistics::R ->new();
open BIN,$win_bin or die "$!";
my %hash_bin;
while(<BIN>){
    chomp;
#    2       0       1000000 50      0.286505087593383
    my ($chr,$stt,$end,$bin,$r2) = split;
    my @aa = split;
    my $tem_nu = @aa;
    next if ($tem_nu != 5 || $bin < 0);
    my $mid = ($stt+$end)/2;
    push @{$hash_bin{$mid}}, $_;
}

`mkdir ./chr_bin/` if !-e "./chr_bin/";
foreach my $chr_bin(sort{$a<=>$b}keys %hash_bin){
    open TEM,"+>./chr_bin/$chr\_$chr_bin.res";
    my $nu = @{$hash_bin{$chr_bin}};
#    print "$nu\n";
#    next if $nu <= 9000;
    foreach my $line(@{$hash_bin{$chr_bin}}){
        print TEM "$line\n";
    }
    my $cmd = <<EOF;
ld<-read.table("./chr_bin/$chr\_$chr_bin.res")
n = $n
ld.decay<-nls(V5 ~ ((10+C*V4)/((2+C*V4)*(11+C*V4)))*(1+((3+C*V4)*(12+12*C*V4+(C*V4)^2))/($n*(2+C*V4)*(11+C*V4))), data = ld , start = list(C = 0.1),control=nls.control(maxiter=100),trace=TRUE)
coeffient <- coef(ld.decay)

f <- function(x)((10+coeffient*x)/((2+coeffient*x)*(11+coeffient*x)))*(1+((3+coeffient*x)*(12+12*coeffient*x+(coeffient*x)^2))/(628*(2+coeffient*x)*(11+coeffient*x))) - $r2_cut
dis_ld_decay <- uniroot(f, interval = c(0,200000000))\$root
EOF
    my $run = $R ->run($cmd);
    
    my $ld_decay = $R -> get("dis_ld_decay");
    my $coeffient = $R -> get("coeffient");
#    my ($ld_decay) = &ld_decay($coeffient);
    print "$chr\t$chr_bin\t$coeffient\t$ld_decay\n";
}

sub ld_decay{
    my ($coef) = @_;
    my $flag = 0;
    for(my $i = 1;$i<=2000000;++$i){
        my $pre = ((10+$coef*$i)/((2+$coef*$i)*(11+$coef*$i)))*(1+((3+$coef*$i)*(12+12*$coef*$i+($coef*$i)^2))/($n*(2+$coef*$i)*(11+$coef*$i)));
        my $nu_aft = $i+1;
        my $aft = ((10+$coef*$nu_aft)/((2+$coef*$nu_aft)*(11+$coef*$nu_aft)))*(1+((3+$coef*$nu_aft)*(12+12*$coef*$nu_aft+($coef*$nu_aft)^2))/($n*(2+$coef*$nu_aft)*(11+$coef*$nu_aft)));
        if($pre >= 0.1 && $aft<=0.1){
            $flag = $i;
            last;
        }
    }
    if($flag > 0){
        return $flag;
    }else{
        return 2000000;
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <win_bin> <chrom> <inbred nu> <r2 cutoff>
DIE
}
