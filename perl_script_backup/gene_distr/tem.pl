#!/usr/bin/perl 
use strict;
die "perl *.pl <All_im><Endo_annotation><468+10>" unless @ARGV==3;
open ALL,$ARGV[0] or die;
my %hash;
while(<ALL>){
    chomp;
    my @aa=split;
    if($aa[0]=~/Zm[MP]NC/ || $aa[0]=~/^IES/ || $aa[0]=~/^[MP]TU/){
        next;
    }else{
        if($aa[-1] eq 'mat'){
            next;
        }else{
            $hash{$aa[0]}=$_;
        }
    }
}
close ALL;
my @aa=keys %hash;
my $nu=@aa;
print "$nu\n";

my $report;
open ENDO,$ARGV[1] or die;
while(<ENDO>){
    chomp;
    if(exists $hash{$_}){
        delete $hash{$_};
        $report++;
    }
}
close ENDO;
print "Endosperm PEG: $report\n";

$report=0;
open ANNO,$ARGV[2] or die;
while(<ANNO>){
    chomp;
    if(exists $hash{$_}){
        delete $hash{$_};
        $report++;
    }
}
print "468+10 annotation PEG: $report\n";

foreach(keys %hash){
    print "$_\n";
}
