#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($var, $label) = @ARGV;

my @var = split(/,/, $var);
my @label = split(/,/, $label);
my %hash_geno;
for(my $i = 0; $i < @var; ++$i){
    open FILE, $var[$i] or die "$!";
    while(my $line = <FILE>){
        next if $line =~ /#CHR/;
        chomp $line;
        my ($chr, $pos, $id, $ref, $alt, $qual, $filter, $T1_geno, $T1_tot_depth, $T1_dep_ref, $T1_dep_alt, $T2_geno, $T2_tot_depth, $T2_dep_ref, $T2_dep_alt) = split(/\t/, $line);
        $hash_geno{"$chr\t$pos"} -> {"ref"} = 0;
        if($T1_geno eq $ref){
            $hash_geno{"$chr\t$pos"} -> {$label[0]} = 0;
        }else{
            $hash_geno{"$chr\t$pos"} -> {$label[0]} = 1;
        }
        if($T2_geno eq $ref){
            $hash_geno{"$chr\t$pos"} -> {$label[$i+1]} = 0;
        }else{
            $hash_geno{"$chr\t$pos"} -> {$label[$i+1]} = 1;
        }
    }
    close FILE;
}

$label =~ s/,/\t/g;
print "id\tref\t$label\n";
foreach(keys %hash_geno){
    my @val = ($hash_geno{$_} -> {"ref"}, $hash_geno{$_} -> {$label[0]});
    for(my $i =1; $i < @label; ++$i){
        $hash_geno{$_} -> {$label[$i]} = $hash_geno{$_} -> {$label[0]} if !exists $hash_geno{$_} -> {$label[$i]};
        push @val, $hash_geno{$_} -> {$label[$i]};
    }
    my $val = join("\t", @val);
    $_ =~ s/\t/_/;
    print "$_\t$val\n";
    
}

sub usage{
    my $die =<<DIE;
    perl *.pl <var files> <labels> 
DIE
}
