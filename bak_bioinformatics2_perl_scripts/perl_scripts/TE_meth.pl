#!/usr/bin/perl -w
use strict;
use DBI;
my ($te,$tissue,@meth)=@ARGV;
die usage() if @ARGV==0;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open TE,$te or die "$!";
my %mips_nu;my %mips_len;
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$strand)=(split)[0,1,2,3];
    my ($meth_lev,$c_nu)=(0,0);
    foreach(@meth){
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
        my $row=$dbh->prepare(qq(select * from $_ where chrom="chr$chr" and pos1>=$stt and pos1<=$end));
            $row->execute();
            $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            $meth_lev+=$lev;
            $c_nu++;
        }
    }
    $meth_lev=$meth_lev/(0.000001+$c_nu);  #methycytocine propotion	
    print "$_\t$c_nu\t$meth_lev\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE simply file> <Tissue> <Six methylation tables> 
DIE
}
