#!/usr/bin/perl -w
use strict;
use DBI;
my ($cgi,$tissue,@meth)=@ARGV;
die usage() if @ARGV==0;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open CGI,$cgi or die "$!";
my %mips_nu;my %mips_len;
while(<CGI>){
    chomp;
    my ($chr,$stt,$end,$strand)=(split)[0,1,2,3];
    next if $chr eq "chr0";
    my ($meth_lev,$c_nu)=(0,0);
    foreach(@meth){
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt and pos1<=$end));
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
    perl *.pl <CGI position> <Tissue> <Six methylation tables> 
DIE
}
