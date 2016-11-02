#!/usr/bin/perl -w
use strict;
use DBI;

die "\n",&die(),"\n" unless @ARGV==3;
my ($database,$tis,$load)=@ARGV;
my ($driver,$dsn,$root,$psword)=("mysql","database=$database","root","123456");

my $dbh=DBI->connect("dbi:$driver:$dsn",$root,$psword) or die "$DBI::errstr";
   $dbh->do(qq(create table $tis(chrom INT,mid INT,pos1 INT,pos2 INT,strand VARCHAR(11),type VARCHAR(11),cov_c INT,meth_lev float,tol_c INT)));
   $dbh->do(qq(load data local infile '$load' into table $tis));
   $dbh->do(qq(CREATE INDEX TE_index ON $tis(chrom,mid,type)));

$dbh->disconnect();

sub die{
    my $die=<<DIE;
    perl *.pl <Database [TE]> <[TE endo][TE sd]>  <Load file>
    We use this scripts to load the data to table.
DIE
}
