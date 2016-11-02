#!/usr/bin/perl -w
use strict;
use DBI;

die "\n",&die(),"\n" unless @ARGV==3;
my ($database,$tis,$load)=@ARGV;
my ($driver,$dsn,$root,$psword)=("mysql","database=$database","root","123456");

my $dbh=DBI->connect("dbi:$driver:$dsn",$root,$psword) or die "$DBI::errstr";
   $dbh->do(qq(create table $tis(chrom VARCHAR(11),pos INT,depth INT)));
   $dbh->do(qq(load data local infile '$load' into table $tis));
   $dbh->do(qq(CREATE INDEX TE_index ON $tis(chrom,pos)));

$dbh->disconnect();

sub die{
    my $die=<<DIE;
    perl *.pl <Database [chip_seq]> <[h3k27_shoot][h3k36_shoot][h3k4_shoot][h3k9_shoot]>  <Load file>
    We use this scripts to load the data to table.
DIE
}
