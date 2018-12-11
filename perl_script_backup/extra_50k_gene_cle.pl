#!/usr/bin/perl -w

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
my $gepo;       #take the information of gene position
my $im;         #take the information of the NOnr 
my %hash;       #define the existence of 
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

        my $range_st=$start1-50000;
        my $range_ed=$end1+50000;
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
        print "Gene_nu\t$hash_count{$_}\t$_\t$hash{$_}\n";
    }else{
        print "Gene_nu\t0\t$_\n";
        next;
    }
}
