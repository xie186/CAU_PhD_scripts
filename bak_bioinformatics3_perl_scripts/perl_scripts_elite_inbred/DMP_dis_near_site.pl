#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($dms,$out1,$out2) = @ARGV;
open DMS,"$dms" or die "$!";
my %hash_dms;
my @hash_nondms;
my $dmp_num;
while(<DMS>){
    chomp;
    #    chr5    48837119        48837119        52      6       0       15      0.896551724137931       0       0.896551724137931      3.73133516975168e-11             3.416953e-08
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval) = split;
    if($qval < 0.01){
        push @{$hash_dms{$chr}}, $stt;
        $dmp_num ++;
    }else{
        push @hash_nondms, "$chr\t$stt";
    }
}

my $dmp_nonnum = $#hash_nondms;
my %hash_nondms;
for(my $i = 0; $i < $dmp_num; ++$i){
    my $rand = int (rand($dmp_nonnum));
    my ($chr,$stt) = split(/\t/,$hash_nondms[$rand]);
    push @{$hash_nondms{$chr}}, $stt;
}

open OUT1, "+>$out1" or die "$!";
open OUT2, "+>$out2" or die "$!"; 
foreach my $chr(keys %hash_dms){

    my @site_dms = sort {$a<=>$b} @{$hash_dms{$chr}};
    for(my $i = 0;$i < $#site_dms - 1; ++$i){
        my $dis = $site_dms[$i + 1] - $site_dms[$i];
        print OUT1 "$chr\t$dis\n";
    }
    
    my @site_nondms = sort {$a<=>$b} @{$hash_nondms{$chr}};
    for(my $i = 0;$i < $#site_nondms - 1; ++$i){
        my $dis = $site_nondms[$i + 1] - $site_nondms[$i];
        print OUT2 "$chr\t$dis\n";
    }
}


sub usage{
    my $die = <<DIE;
    perl *.pl <qvalue results> <OUT dis DMS>  <OUT nonDMS[random]>
DIE
}
