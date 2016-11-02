#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==4;
my ($chip,$his_mod,$ge_pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$chip","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$ge_pos or die;
while(my $line=<POS>){
    chomp $line;
    my ($chr,$stt,$end)=(split(/\t/,$line))[0,1,2];
    $chr="chr".$chr;
    my ($chip_reads,$count)=(0,0);
        my $row=$dbh->prepare(qq(select * from $his_mod where chrom="$chr" and pos>=$stt and pos<=$end));
           $row->execute();
        my ($chrom,$pos,$depth)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos,\$depth);
        while($row->fetch()){
           $chip_reads+=$depth;
#           $count++;
        }
    my $average_chip_dens=$chip_reads/($end-$stt+1);
    print OUT "$line\t$average_chip_dens\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <[chip_seq]> <[h3k27_shoot][h3k36_shoot][h3k4_shoot][h3k9_shoot]> <Gene position sepa by CpG o/e> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
