#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($sect_res) = @ARGV;
open SECT,$sect_res or die "$!";
my %hash_stat;
my %dmr_num;
while(<SECT>){
    chomp;
    my ($chr,$stt,$end,$context,$ele_chr,$ele_stt,$ele_end) = split;
#    my $mid = $end - 2000;
    for(my $i = $ele_stt;$i <= $ele_end; ++$i){
        next if $i < $stt;
        next if $i > $end;
        my $pos = int (($i - $stt)/100) - 20;
        next if $pos == 20;
        $hash_stat{"$context"} -> {$pos} ++;
    }
    $dmr_num{"$chr\t$stt\t$end"} ++;
}

my $dmr_num = keys %dmr_num;
   $dmr_num = $dmr_num/2;
foreach my $context(keys %hash_stat){
    foreach my $pos(sort {$a <=> $b} keys %{$hash_stat{"$context"}}){
        my $dens = $hash_stat{"$context"}->{$pos} / ($dmr_num * 100);
        print "$context\t$pos\t$dens\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <TFBS intersect results>
DIE
}
