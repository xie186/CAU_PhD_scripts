#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($cego_file) = @ARGV;

open CEGO,$cego_file or die "$!";
my @block = <CEGO>;
my $block = join("",@block);
   $block =~ s/###\n//;
   @block = split(/###\n/,$block);

foreach(@block){
    my @pair = split(/\n/,$_);
    my ($region_chr1,$region_chr2) = (0,0);
    my @gene_pair;
    my @region1; my @region2;
#    shift @pair;
    foreach my $pair(@pair){
        next if $pair =~ /^#/;
#       a11821_1        1||113005||115818||Sb01g000270||1||CDS||86674923||10||91.1      113005  115818  b11266_1        1||300437138||300443202||GRMZM2G377487||-1||CDS||81823960||9866||91.1        300443202       300437138       1.000000e-250   450     http://genomevolution.org/CoGe/GEvo.pl?fid1=86674923;fid2=81823960;dsgid1=11821;dsgid2=11266 
       my ($chr_id1,$gene_coor1,$stt1,$end1,$chr_id2,$gene_coor2,$stt2,$end2) = split(/\t/,$pair);
#       print "$chr_id1,$gene_coor1,$stt1,$end1,$chr_id2,$gene_coor2,$stt2,$end2\n";
#       print "$pair\n";
       my ($chr1,$gene_id1,$strand1) = $gene_coor1 =~/(\d+)\|\|\d+\|\|\d+\|\|(.*)\|\|(.*)\|\|CDS\|\|/;
       my ($chr2,$gene_id2,$strand2) = $gene_coor2 =~/(\d+)\|\|\d+\|\|\d+\|\|(.*)\|\|(.*)\|\|CDS\|\|/;
       ($region_chr1,$region_chr2) = ($chr1,$chr2);
#       print "xxx$chr1\t$stt1\t$end1\t$gene_id1\t$strand1\t$chr2\t$stt2\t$end2\t$gene_id2\t$strand2\n";
       push @gene_pair, "$chr1\t$stt1\t$end1\t$gene_id1\t$strand1\t$chr2\t$stt2\t$end2\t$gene_id2\t$strand2";
       push @region1 , ($stt1,$end1);
       push @region2 , ($stt2,$end2);
    }
    my ($region_stt1,$region_end1) = (sort{$a<=>$b} @region1)[0,-1];
    my ($region_stt2,$region_end2) = (sort{$a<=>$b} @region2)[0,-1];
    print "###sorghum\_$region_chr1\_$region_stt1\_$region_end1	maize\_$region_chr2\_$region_stt2\_$region_end2\n";
    foreach my $gene_pos(@gene_pair){
        print "$gene_pos\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <syntenic results> 
DIE
}

