#!/usr/bin/perl -w
use strict;
use DBI;

die "\n",&die(),"\n" unless @ARGV==3;
my ($database,$load_file,$tab_name)=@ARGV;
my ($driver,$dsn,$root,$psword)=("mysql","database=$database","root","123456");

my $dbh=DBI->connect("dbi:$driver:$dsn",$root,$psword) or die "$DBI::errstr";
   $dbh->do(qq(create table $tab_name(chrom VARCHAR(11),pos1 INT,pos2 INT)));
   $dbh->do(qq(load data local infile '$load_file' into table $tab_name));
   $dbh->do(qq(CREATE INDEX intron_index ON $tab_name(chrom,pos1,pos2)));

$dbh->disconnect();

sub die{
    my $die=<<DIE;
    perl *.pl <DATABASE name> <Load file> <Table name [SD_intron][EM_intron][EN_intron]> 
    We use this scripts to load the data to table.
DIE
}
