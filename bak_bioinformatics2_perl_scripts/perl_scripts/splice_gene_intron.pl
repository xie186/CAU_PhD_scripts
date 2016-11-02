#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==5;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=splice","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr";
my ($intron,$gene_pos,$tab,$intron_in_gene,$intron_out_gene,)=@ARGV;
open INTRON,$intron or die "";
my %hash;
while(<INTRON>){
    chomp;
    my ($chr,$stt,$end)=split;
    $hash{"$chr\t$stt\t$end"}=$_;
}
open POS,$gene_pos or die "$!";
open OUT,"+>$intron_in_gene" or die "$!";
my %hash_ex;
while(<POS>){
    chomp;
    next if (/UNKNOW/ || /^mito/ || /^chlo/);
    my ($chr,$stt,$end,$gene,$strand)=split;
    $chr="chr".$chr;
    my $tem=$dbh->prepare(qq(select * from $tab where chrom='$chr' and pos1>=$stt and pos2<=$end));
       $tem->execute();
    my ($chr1,$stt1,$end1); 
       $tem->bind_columns(\$chr1,\$stt1,\$end1);
    while($tem->fetch()){
        print OUT "$chr1\t$stt1\t$end1\t$gene\t$strand\n";
        $hash_ex{"$chr1\t$stt1\t$end1"}++;
    }
}
close OUT;
open OUT,"+>$intron_out_gene" or die "$!";
foreach(keys %hash){
    print OUT "$_\n" if !exists $hash_ex{$_};
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Intron > <gene position> <mySQL table [SD_intron][EN_intron]> <Intron in gene> <Intron out of gene>
DIE
}

