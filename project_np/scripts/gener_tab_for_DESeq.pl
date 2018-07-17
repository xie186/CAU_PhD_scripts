#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
sub usage{
    my $die =<<DIE;
perl $0 <tis1,tis2><control, treat>
DIE
}
my ($res, $sam) = @ARGV;

my @res = split(/,/, $res);
my @sam = split(/,/, $sam);
my %rec_exp;
for(my $i =0; $i < @res; ++$i){
    open RES, $res[$i] or die "$!";
    while(my $line = <RES>){
        next if $line =~ /miR_ID/;
        my ($miR_id, $score, $chr, $strand, $hair, $exp) = split(/\t/, $line);
        $rec_exp{$miR_id} -> {$sam[$i]} = $exp;
    }
    close RES;
}

$sam=~s/,/\t/g;
print "gene_id\t$sam\n";
foreach my $miR_id(keys %rec_exp){
    my @exp;
    for(my $i =0; $i < @sam; ++$i){
        $rec_exp{$miR_id} -> {$sam[$i]} = 1 if !exists $rec_exp{$miR_id} -> {$sam[$i]};
        push @exp, $rec_exp{$miR_id} -> {$sam[$i]}; 
    }
    my $exp = join("\t", @exp);
    print "$miR_id\t$exp\n";
}
