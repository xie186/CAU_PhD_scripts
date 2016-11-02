#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($syn_gene,$zm_imp,$rice_imp) = @ARGV;
open RICE,$rice_imp or die "$!";
my %imp_rice;
while(<RICE>){
    chomp;
    $_ =~ s/\.\d+//g;
    if(/||/){
        my ($gene1,$gene2) = (split(/\s+/,$_))[0,-1];
        $imp_rice{$gene1} ++;
        $imp_rice{$gene2} ++;
    }else{
        $imp_rice{$_} ++;
    }
}

open ZM,$zm_imp or die "$!";
my %imp_zm;
while(<ZM>){
    chomp;
    $imp_zm{$_} ++;
}

open SYN,$syn_gene or die "$!";
while(<SYN>){
    chomp;
    my ($ge_zm,$ge_rice) = split;
    if( exists $imp_rice{$ge_rice} && exists $imp_zm{$ge_zm}){
        print "$_\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <Syn gene > <zm imprinted genes> <rice imprited genes> 
DIE
}
