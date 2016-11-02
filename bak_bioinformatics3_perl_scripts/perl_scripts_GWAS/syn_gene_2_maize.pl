#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($os_loc,$cand,$syn) = @ARGV;

open OS,$os_loc or die "$!";
my %hash;
while(<OS>){
    chomp;
    my ($os,$loc) = split(/\s+/,$_);
    ($loc) = split(/;/,$loc);
    $loc =~ s/\.\d//;
    $hash{$os} = $loc;
}

open SYN,$syn or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($zm,$loc) = split;
    $hash_syn{$loc} = $zm;
}

open CAND,$cand or die "$!";
my @cand = <CAND>;
my $tem_cand = join('',@cand);
   @cand = split(/###/,$tem_cand);
foreach(@cand){
    my ($pheno,@cand_ge) = split(/\n/,$_);
    foreach my $tem_line(@cand_ge){
        chomp;
        my ($chr,$pos,$gene_name) = split(/\t/,$tem_line);
        my @gene_name = split(/;/,$gene_name);
        foreach my $tem_name(@gene_name){
            if(exists $hash{$tem_name}){
                my $loc = $hash{$tem_name};
                if(exists $hash_syn{$loc}){
                    print "$pheno\t$tem_name\t$hash_syn{$loc}\n";
                }
            }
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <rice japan 2 rice msu> <rice candidate genes> <rice2maize syntenic genes> 
DIE
}
