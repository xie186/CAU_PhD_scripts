#!/usr/bin/perl -w
use strict;
use DBI;
my ($chip_db,$chip_tab,$ge_pos,$out)=@ARGV;
die usage() unless @ARGV==4;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$chip_db","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open POS,$ge_pos or die "$!";
my %mips_nu;my %mips_len;
open OUT,"+>$out" or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$strand)=(split)[0,1,2,3];
    next if !/^\d/;
    $chr="chr".$chr;
    my ($chip_reads,$num)=(0,0);
    my ($chrom,$tem_pos,$depth)=(0,0,0); 
    my $row=$dbh->prepare(qq(select * from $chip_tab where chrom="$chr" and pos>=$stt and pos<=$end));
        $row->execute();
        $row->bind_columns(\$chrom,\$tem_pos,\$depth);
    while($row->fetch()){
        $chip_reads+=$depth;
    }
    my $chip_aver = $chip_reads*1000/($end-$stt+1);  #methycytocine propotion	
    print OUT "$_\t$num\t$chip_aver\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <chip databases> <chip seq> <FGS position> <OUT> 
DIE
}
