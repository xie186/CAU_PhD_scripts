#!/usr/bin/perl -w
#program use for transcripts' name with |--NA--

use strict;
die "Usage:perl *.pl <NOnr><GENEPOS>" unless @ARGV==2;

open NONR,$ARGV[0] or die;
open GEPO,$ARGV[1] or die;
my $find;
my @name_NOnr;

while(<NONR>){
    if ($find=index($_,'>IES',0)>-1){
    push(@name_NOnr,$_);
#    print @name_NOnr;
    }else{
        next;
    }
}
my $gepo;
my $im;
my %hash;
my %hash_count; #calculate the number of genes in -50k_+50k
while($gepo=<GEPO>){
    chomp $gepo;
#    print $gepo;
    my ($name_chr,$start,$end)=(split(/\s+/,$gepo))[0,1,2];
#    print "$name_chr\t$end\n";    
    foreach $im(@name_NOnr){
        chomp $im;
#        print $im;
        my ($im_trans,$start1,$end1)=(split(/_/,$im))[1,2,3];
#         print "$end1\n";
        my $end3=(split(/\|-/,$end1))[0];
#        print "$im_trans\t$start\t$end3\n";
#        my $end2=join('',@array);
        my $range_st=$start1-50000;
        my $range_ed=$end3+50000;
#        my %hash;
        my ($name_chr1)=(split(/r/,$im_trans))[1];
#        print "$name_chr1\n";
        if($name_chr1 ne $name_chr){
            next;
        }elsif ($start>$range_st && $end<$range_ed){
            if (exists ($hash{$im})){
                $hash{$im}="$hash{$im}\t$gepo";
                $hash_count{$im}++;
            }else{                       
                $hash{$im}="$gepo";
                $hash_count{$im}++;
            }
            last;
        }else{
            next;
        }
    }
}

foreach (@name_NOnr){
    chomp $_;
    if(exists ($hash{$_})){
        print "Count$hash_count{$_}\t$_\t$hash{$_}\n";
    }else{
        print "Count0\t$_\n";
        next;
    }
}
