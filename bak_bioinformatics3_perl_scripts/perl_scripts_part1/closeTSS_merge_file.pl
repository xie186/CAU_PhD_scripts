#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($dmr, $ana, $context) = @ARGV;

my @dmr = split(/,/, $dmr);
my @context = split(/,/, $context);
my @ana = split(/,/, $ana);

my %ana_region;
for(my $i = 0 ;$i < @dmr; ++$i){
    open ANA,$ana[$i] or die "$!";
    while(<ANA>){
        chomp;
        my ($chr,$stt,$end) = split;
        push @{$ana_region{$context[$i]}},"$chr\t$stt\t$end"; 
    }
    close ANA;
}

for(my $i = 0 ;$i < @dmr; ++$i){
    open DMR,$dmr[$i] or die "$!";
    while(<DMR>){
        chomp;
        my $num = @{$ana_region{$context[$i]}};
        my $rand = int( rand($num));
        my $rand_reg = ${$ana_region{$context[$i]}}[$rand];
        print "$rand_reg\tRandom\n";
        print "$_\t$context[$i]\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DMR [dmr1,dmr2]> <ana [ana1,ana2]> <context [context1,context2]> 
DIE
}
