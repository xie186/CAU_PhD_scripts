#!/usr/bin/perl -w
use strict;
use DBI;
my ($cluster,$out) = @ARGV;
die usage() unless @ARGV==2;
my ($driver,$dsn,$usr,$pswd) = ("mysql","database=MO17","root","123456");
my $dbh = DBI -> connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr";

open BED,$cluster or die "$!";
open OUT,"+>$out" or die "$!";
while(<BED>){
    chomp;
    my ($chr,$stt,$end) = split;
    my $tem = $dbh ->prepare(qq(select * from snp where chrom="$chr" and pos >=$stt-1 and pos <= $end-1));
       $tem -> execute();
    my ($chrom,$tem_pos,$alle1,$alle2)=(0,0,0,0);
       $tem->bind_columns(\$chrom,\$tem_pos,\$alle1,\$alle2);
    my $flag=0;
    while($tem->fetch()){
        $flag++;
        print "$chrom\t$tem_pos\n";
    }
    print OUT "$_\t$flag\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Cluster coordinate> <OUT>
DIE
}
