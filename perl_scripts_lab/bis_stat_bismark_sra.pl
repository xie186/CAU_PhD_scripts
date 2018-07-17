#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 1;
my ($file) = @ARGV;

open FILE, $file or die "$!";
my $header = <FILE>;
chomp $header;
my @header=split(/\t/, $header);

print "#Accession\tDate\tAlias\tTotal_reads\tMapEff\tCpG\tCHG\tCHH\n";
while(<FILE>){
    next if /^#/;
    #Accession      Date    SeqType Backgroud       Genotype        Tissue  Alias   SampleType      Multiplexing    Dir
    my %tem_infor = &extract_infor($_);
    my ($acc, $date, $sample_name, $dir) = ($tem_infor{"#Accession"}, $tem_infor{"Date"}, $tem_infor{"Alias"}, $tem_infor{"Dir"});
    my $report  = "$sample_name\_R1.fq.trimmed.paired1_bismark_bt2_PE_report.txt";
    open REP, $report or die "$report: $!";
    my @report =  <REP>;
    my $rep = join("", @report);
    my ($tot_reads) = $rep =~ /Sequence pairs analysed in total:\s+(\d+)/;
    my ($map_eff) = $rep =~ /Mapping efficiency:\s+(.*)%/;
    my ($lev_cpg) = $rep =~ /C methylated in CpG context:\s+(.*)%\n/;
    my ($lev_chg) = $rep =~ /C methylated in CHG context:\s+(.*)%/;
    my ($lev_chh) = $rep =~ /C methylated in CHH context:\s+(.*)%/;
    close REP;
    print "$acc\t$date\t$sample_name\t$tot_reads\t$map_eff\t$lev_cpg\t$lev_chg\t$lev_chh\n";
}
close FILE;

sub extract_infor{
    my ($line) = @_;
    my @line = split(/\t/, $line);
    my %tem_hash;
    for(my $i=0; $i < @line; ++$i){
        $line[$i] =~ s/\s+/-/g;
        $line[$i] =~ s/-$//g;
        $tem_hash{$header[$i]} = $line[$i];
    }
    return %tem_hash;
}


sub usage{
my $die =<<DIE;
perl *.pl <File List>  
DIE
}

