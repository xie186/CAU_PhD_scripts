#!/usr/bin/perl -w
use strict;
use DBI;
my ($tissue,$forw,$rev,$context)=@ARGV;
die usage() unless @ARGV==4;
my $symmetric=1 if $context eq "CpG";
   $symmetric=2 if $context eq "CHG";
my ($asy_nu,$sym_nu)=(0,0);
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open FORW,$forw or die "$!";
while(<FORW>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $lev<80; 
    my $row=$dbh->prepare(qq(select * from $rev where chrom="$chr" and pos1=$stt+1));
    $row->execute();
    my ($chrom,$tem_pos1,$tem_pos2,$tem_depth,$tem_lev)=("0",0,0,0,0);
       $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$tem_depth,\$tem_lev);
    while($row->fetch()){
        last if $chrom eq "0";
         if($tem_lev<80){
             $asy_nu++;
         }else{
             $sym_nu++;
         }
   }
}
my $ratio=$sym_nu/($asy_nu+$sym_nu);
print "$asy_nu\t$sym_nu\t$ratio\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissues> <Forw_bedfile> <Reverse mysql> <Context CpG or CHG>
DIE
}
