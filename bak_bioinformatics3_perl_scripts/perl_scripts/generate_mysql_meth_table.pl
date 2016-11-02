#!/usr/bin/perl -w
use strict;
use DBI;

die "\n",&die(),"\n" unless @ARGV==7;
my ($tissue,$cpg_forw,$cpg_rev,$chg_forw,$chg_rev,$chh_forw,$chh_rev)=@ARGV;
my ($driver,$dsn,$root,$psword)=("mysql","database=$tissue","root","123456");

my $dbh=DBI->connect("dbi:$driver:$dsn",$root,$psword) or die "$DBI::errstr";
   $dbh->do(qq(create table CpG_OT(chrom VARCHAR(11),pos1 INT,pos2 INT,depth INT,meth_lev float)));
   $dbh->do(qq(load data local infile '$cpg_forw' into table CpG_OT));
   $dbh->do(qq(CREATE INDEX CpG_OT_index ON CpG_OT(chrom,pos1)));

   $dbh->do(qq(create table CpG_OB(chrom VARCHAR(11),pos1 INT,pos2 INT,depth INT,meth_lev float)));
   $dbh->do(qq(load data local infile '$cpg_rev' into table CpG_OB));
   $dbh->do(qq(CREATE INDEX CpG_OB_index ON CpG_OB(chrom,pos1)));

   $dbh->do(qq(create table CHG_OT(chrom VARCHAR(11),pos1 INT,pos2 INT,depth INT,meth_lev float)));
   $dbh->do(qq(load data local infile '$chg_forw' into table CHG_OT));
   $dbh->do(qq(CREATE INDEX CHG_OT_index ON CHG_OT(chrom,pos1)));

   $dbh->do(qq(create table CHG_OB(chrom VARCHAR(11),pos1 INT,pos2 INT,depth INT,meth_lev float)));
   $dbh->do(qq(load data local infile '$chg_rev' into table CHG_OB));
   $dbh->do(qq(CREATE INDEX CHG_OB_index ON CHG_OB(chrom,pos1)));

   $dbh->do(qq(create table CHH_OT(chrom VARCHAR(11),pos1 INT,pos2 INT,depth INT,meth_lev float)));
   $dbh->do(qq(load data local infile '$chh_forw' into table CHH_OT));
   $dbh->do(qq(CREATE INDEX CHH_OT_index ON CHH_OT(chrom,pos1)));

   $dbh->do(qq(create table CHH_OB(chrom VARCHAR(11),pos1 INT,pos2 INT,depth INT,meth_lev float)));
   $dbh->do(qq(load data local infile '$chh_rev' into table CHH_OB));
   $dbh->do(qq(CREATE INDEX CHH_OB_index ON CHH_OB(chrom,pos1)));

$dbh->disconnect();

sub die{
    my $die=<<DIE;
    perl *.pl <Tissue_name> <CpG_OT> <CpG_OB> <CHG_OT> <CHG_OB> <CHH_OT> <CHH_OB>
    We use this scripts to load the data to table.
DIE
}
