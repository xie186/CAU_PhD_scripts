#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==5;
my ($tissue,$forw,$rev,$ge_pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$ge_pos or die;
while(my $line=<POS>){
    chomp $line;
    my ($chr,$stt,$end)=(split(/\t/,$line))[0,1,2];
    $chr="chr".$chr;
    my ($meth_lev,$count)=(0,0);
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $meth_lev+=$lev;
           $count++;
        }
    }
    my $average_meth_lev=$meth_lev/($count+0.0000001);
    print OUT "$line\t$average_meth_lev\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <Gene position sepa by CpG o/e> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
