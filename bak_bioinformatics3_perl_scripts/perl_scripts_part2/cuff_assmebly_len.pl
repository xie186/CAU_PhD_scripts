#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($cuff_gtf) = @ARGV;
open GTF,$cuff_gtf or die "$!";
my %trans_len;
my %trans_fpkm;
while(<GTF>){
    chomp;
    #chr0    Cufflinks       transcript      1192    1406    1000    .       .      gene_id "CUFF.1"; transcript_id "CUFF.1.1";  FPKM "23.6365972609"; 
    my ($chr,$tool,$type,$stt,$end,$dot1,$strand,$dot2) = split;
    next if $type ne "exon";
    my ($gene_id,$trans_id,$fpkm) = $_ =~ /gene_id "(.*)"; transcript_id "(.*)"; exon_number "\d+"; FPKM "(.*)"; frac/;
#    print "$gene_id,$trans_id,$fpkm\n";
    next if $trans_id !~ /CUFF/;
    $trans_len{$trans_id} += $end-$stt+1;
    $trans_fpkm{$trans_id} = $fpkm;
}

foreach(keys %trans_len){
    print "$_\t$trans_len{$_}\t$trans_fpkm{$_}\n"
}
sub usage{
    my $die =<<DIE;
   perl *.pl <cuff gtf> 
DIE
}

