#!/usr/bin/perl -w
use strict;
use DBI;

die "\n",&die(),"\n" unless @ARGV==3;
my ($database,$tis,$load)=@ARGV;
my ($driver,$dsn,$root,$psword)=("mysql","database=$database","root","123456");

my $dbh=DBI->connect("dbi:$driver:$dsn",$root,$psword) or die "$DBI::errstr";
   $dbh->do(qq(create table $tis(chrom INT,pos1 INT,pos2 INT,strand VARCHAR(11),type VARCHAR(40),sub_type VARCHAR(40))));
   $dbh->do(qq(load data local infile '$load' into table $tis));
   $dbh->do(qq(CREATE INDEX TE_index ON $tis(chrom,pos1,pos2)));

$dbh->disconnect();

sub die{
    my $die=<<DIE;
    perl *.pl <Database [TE]>  <table name [TE_pos]>  <Load file>
    We use this scripts to load the data to table.
DIE
}
