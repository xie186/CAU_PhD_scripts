#!/usr/bin/perl -w
use strict;
use DBI;

die "\n",&die(),"\n" unless @ARGV==2;
my ($spe,$snp)=@ARGV;
my ($driver,$dsn,$root,$psword)=("mysql","database=$spe","root","123456");

my $dbh=DBI->connect("dbi:$driver:$dsn",$root,$psword) or die "$DBI::errstr";
   $dbh->do(qq(create table snp(chrom VARCHAR(11),pos INT,allele1 VARCHAR(11),allele2 VARCHAR(11))));
   $dbh->do(qq(load data local infile '$snp' into table snp));
   $dbh->do(qq(CREATE INDEX CpG_OT_index ON snp(chrom,pos)));

$dbh->disconnect();

sub die{
    my $die=<<DIE;
    perl *.pl <Species> <SNP loadfile>
    We use this scripts to load the data to table.
DIE
}
