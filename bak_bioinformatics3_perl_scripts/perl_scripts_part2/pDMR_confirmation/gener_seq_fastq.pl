#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($read_id, $out) = @ARGV;
`dos2unix *`;
my @file = <*seq>; 

my %hash_id;
open OUT,"+>$out" or die "$!";
foreach my $file(@file){
    print "$file\n";
    next if $file !~ /$read_id-+\d+/;
    my ($tem_id) = $file =~ /($read_id-+\d+)/;
    next if exists $hash_id{"$tem_id"};
    open FILE,$file or die "$!";
    my @seq = <FILE>;
    chomp @seq;
    my $seq = join("",@seq);
       $seq = uc $seq;
    print OUT ">$tem_id\n$seq\n";
    $hash_id{"$tem_id"} ++;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <read id [1]> <out>
DIE
}
