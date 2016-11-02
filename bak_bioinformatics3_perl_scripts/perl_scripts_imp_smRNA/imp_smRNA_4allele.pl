#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==6;
my ($bm_b,$bm_m,$mb_b,$mb_m,$imp,$out) = @ARGV;

open BMB,$bm_b or die "$!";
my %hash;
while(<BMB>){
    chomp;
    my ($chr,$stt,$end,$id) = split;
    ${$hash{"$chr\t$stt\t$end"}}[0] = $id;
}
close BMB;

open BMM,$bm_m or die "$!";
while(<BMM>){
    chomp;
    my ($chr,$stt,$end,$id) = split;
    ${$hash{"$chr\t$stt\t$end"}}[1] = $id;
}
close BMM;

open MBB,$mb_b or die "$!";
while(<MBB>){
    chomp;
    my ($chr,$stt,$end,$id) = split;
    ${$hash{"$chr\t$stt\t$end"}}[2] = $id;
}
close MBB;
open MBM,$mb_m or die "$!";
while(<MBM>){
    chomp;
    my ($chr,$stt,$end,$id) = split;
    ${$hash{"$chr\t$stt\t$end"}}[3] = $id;
}
close MBM;
open IMP,$imp or die "$!";
my %hash_imp;
while(<IMP>){
    chomp;
    my ($chr,$stt,$end) = split;
    $hash_imp{"$chr\t$stt\t$end"} ++;
}
close IMP;
open OUT,"+>$out" or die "$!";
foreach(keys %hash){
    my ($chr,$stt,$end) = split;
    next if ((!defined ${$hash{$_}}[0] && !defined ${$hash{$_}}[1]) || (defined ${$hash{$_}}[0] && defined ${$hash{$_}}[1] && ${$hash{$_}}[0] eq ${$hash{$_}}[1]));
    next if ((!defined ${$hash{$_}}[2] && !defined ${$hash{$_}}[3]) || (defined ${$hash{$_}}[2] && defined ${$hash{$_}}[3] && ${$hash{$_}}[2] eq ${$hash{$_}}[3]));
    my $flag=0;
    foreach my $imp_pos(keys %hash_imp){
        my ($tem_chr,$tem_stt,$tem_end)  = split(/\t/,$imp_pos);
        $flag++ if ($chr eq $tem_chr && $stt >= $tem_stt && $end <=$tem_end);
    }
    next if $flag < 1;
    my $smRNA_len = 0;
    my @read_nu;
    
    for(my $i = 0;$i <= 3;++ $i){
        if(!defined ${$hash{$_}}[$i]){
             $read_nu[$i] = 0;
        }else{
            ($smRNA_len,$read_nu[$i]) = (split(/_/,${$hash{$_}}[$i]))[1,2];
        }
    }
    my $read_nu_join = join("\t",@read_nu);
    print OUT "$_\t$smRNA_len\t$read_nu_join\n";
}
close OUT;
sub usage{
    my $die=<<DIE;
    perl *.pl <bm_b> <bm_m> <mb_b> <mb_m> <imp_smRNA_cluster> <OUT>
DIE
}
