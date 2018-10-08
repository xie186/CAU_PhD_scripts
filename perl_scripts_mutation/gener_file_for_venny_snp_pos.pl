#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($var, $label) = @ARGV;

my @var = split(/,/, $var);
my @label = split(/,/, $label);
my %hash_geno;
my %hash_rec;
for(my $i = 0; $i < @var; ++$i){
    open FILE, $var[$i] or die "$!";
    while(my $line = <FILE>){
        next if $line =~ /#CHR/;
        chomp $line;
        my ($chr, $pos, $id, $ref, $alt, $qual, $filter, $T1_geno, $T1_tot_depth, $T1_dep_ref, $T1_dep_alt, $T2_geno, $T2_tot_depth, $T2_dep_ref, $T2_dep_alt) = split(/\t/, $line);
        ${$hash_geno{"$chr\t$pos"}}[$i] = "0";
        $hash_rec{"$chr\t$pos"} -> {$label[$i]} = "0";
    }
    close FILE;
}

$label =~ s/,/\t/g;
print "id\t$label\n";
foreach(keys %hash_geno){
        for(my $i = 0; $i < @var; ++$i){
            ${$hash_geno{$_}}[$i] = "1" if !exists $hash_rec{$_} -> {$label[$i]};
        }
    my $val = join("\t", @{$hash_geno{$_}});
    $_ =~ s/\t/_/;
    print "$_\t$val\n";
    
}

sub usage{
    my $die =<<DIE;
    perl *.pl <var files> <labels> 
DIE
}
