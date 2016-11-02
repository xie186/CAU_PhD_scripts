#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($dap10, $dap12, $tab) = @ARGV;

open DAP,$dap10 or die "$!";
my %hash_dap10;
while(<DAP>){
    chomp;
    my ($chr,$pos) = split;
    $hash_dap10{"$chr\t$pos"} ++;
}
close DAP;

open DAP,$dap12 or die "$!";
my %hash_dap12;
while(<DAP>){
    chomp;
    my ($chr,$pos) = split;
    $hash_dap12{"$chr\t$pos"} ++;
}
close DAP;

open TAB,$tab or die "$!";
my %imp_tab_dap;
my %imp_tab;
while(<TAB>){
    chomp;
    my ($chr,$pos,$gene,$dap) = (split)[0,1,2,-1];
    push @{$imp_tab_dap{"$gene\t$dap"}},  $_;
    $imp_tab{$gene} ++;
}

foreach (keys %imp_tab){
    if (exists $imp_tab_dap{"$_\t10DAP"} && exists $imp_tab_dap{"$_\t12DAP"}){
        print "$_\tY\tY\tNA\n";
    }elsif(exists $imp_tab_dap{"$_\t10DAP"} || !exists $imp_tab_dap{"$_\t12DAP"}){ 
        my ($analyzable) = (0);
        foreach my $lines(@{$imp_tab_dap{"$_\t10DAP"}}){
            my ($chr,$pos) = split(/\t/,$lines);
            if(exists $hash_dap12{"$chr\t$pos"}){
                ++$analyzable;
            }
        }
        if($analyzable >0){
            ($analyzable) = ("Y");
        }else{
            ($analyzable) = ("N");
        }
        print "$_\tY\tN\t$analyzable\n";
    }elsif(!exists $imp_tab_dap{"$_\t10DAP"} || exists $imp_tab_dap{"$_\t12DAP"}){
        my ($analyzable) = (0);
        foreach my $lines(@{$imp_tab_dap{"$_\t12DAP"}}){
            my ($chr,$pos) = split(/\t/,$lines);
            if(exists $hash_dap10{"$chr\t$pos"}){
                ++$analyzable;
            }
        }
        if($analyzable >0){
            ($analyzable) = ("Y");
        }else{
            ($analyzable) = ("N");
        }
        print "$_\tN\tY\t$analyzable\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <10 DAP> <12 DAP> <tab>
DIE
}
