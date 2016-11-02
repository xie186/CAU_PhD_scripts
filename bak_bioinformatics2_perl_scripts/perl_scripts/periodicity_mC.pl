#!/usr/bin/perl -w
use strict;use DBI;
die usage() unless @ARGV==4;
my ($tissue,$bed_file,$forw,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open BED,$bed_file or die "$!";
my %hash;
while(<BED>){
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if ($lev<0.8 || $depth<3);
    my $row2=$dbh->prepare(qq(select * from $forw where chrom="$chr" and pos1>$pos1-100 and pos1<=$pos1+500));
       $row2->execute();
    my ($tem_chrom,$tem_pos1,$tem_pos2,$tem_depth,$tem_lev)=(0,0,0,0,0);
       $row2->bind_columns(\$tem_chrom,\$tem_pos1,\$tem_pos2,\$tem_depth,\$tem_lev);
    while($row2->fetch()){
        next if ($tem_lev<0.8 || $depth<3);
        my $pos=$tem_pos1-$pos1;
        $hash{$pos}++;
    }
}
open OUT,"+>$out" or die "$!";
foreach(sort{$a<=>$b}keys %hash){
    print OUT "$_\t$hash{$_}\n";
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Tissue> <Bedgraph file> <Forw> <OUT>
DIE
}
