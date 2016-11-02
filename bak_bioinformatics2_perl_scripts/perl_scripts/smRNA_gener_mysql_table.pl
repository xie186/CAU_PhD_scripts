#!/usr/bin/perl -w
use strict;
use DBI;

die "\n",&die(),"\n" unless @ARGV==3;
my ($smRNA,$tissue1,$tissue2)=@ARGV;
my ($driver,$dsn,$root,$psword)=("mysql","database=$smRNA","root","123456");

my $dbh=DBI->connect("dbi:$driver:$dsn",$root,$psword) or die "$DBI::errstr";
   $dbh->do(qq(create table smRNA_BM(ID VARCHAR(11),length INT,copy INT,strand INT,chrom VARCHAR(11),pos INT)));
   $dbh->do(qq(load data local infile '$tissue1' into table smRNA_BM));
   $dbh->do(qq(CREATE INDEX em_index ON smRNA_BM(chrom,pos)));

   $dbh->do(qq(create table smRNA_MB(ID VARCHAR(11),length INT,copy INT,strand INT,chrom VARCHAR(11),pos INT)));
   $dbh->do(qq(load data local infile '$tissue2' into table smRNA_MB));
   $dbh->do(qq(CREATE INDEX em_index ON smRNA_MB(chrom,pos)));

$dbh->disconnect();

sub die{
    my $die=<<DIE;
    perl *.pl <smRNA [smRNA]> <smRNA_ BM> <smRNA MB>
    We use this scripts to load the data to table.
DIE
}
