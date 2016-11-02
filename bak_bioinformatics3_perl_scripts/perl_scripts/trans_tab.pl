#!/usr/bin/perl -w
use strict;
my ($tab)=@ARGV;
open XX,$tab or die "$!";
my %hash_type;
my %hash_ele;
my %hash;
while(<XX>){
    chomp;
    my($ele,$type,$nu)=split;
    $hash_type{$type}+=$nu;
    $hash_ele{$ele}++;
    $hash{"$ele\t$type"}=$nu;
}
my %hash_type1;
foreach my $type(sort keys %hash_type){
    
    foreach my $ele (sort keys %hash_ele){
        my $nu=0;
        if(exists $hash{"$ele\t$type"}){
            $nu=$hash{"$ele\t$type"};
            $nu=$hash{"$ele\t$type"}/$hash_type{$type};
        }
        push(@{$hash_type1{$type}},$nu);
    }
}
print "\t";
foreach(sort keys %hash_ele){
    print "$_\t";
}
print "\n";
foreach(sort keys %hash_type1){
    
    my $print=join("\t",@{$hash_type1{$_}});
    print "$_\t$print\n";
}
