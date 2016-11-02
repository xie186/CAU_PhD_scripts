#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($tissue,$forw,$rev,$pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,$pos or die;
my %mth_lev;my %mth_nu;
my %flag;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    next if $line =~/^#/;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand,$type,$rpkm,$rank)=split(/\s+/,$line);
    my $unit = ($end-$stt+1)/100;
    ($stt,$end) = ($stt + 20*$unit,$end - 20*$unit);
    $chr="chr".$chr;
    my ($mth_lev,$nu)=(0,0);
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            $mth_lev{$rank} += $lev;
            ++$mth_nu{$rank}
        }
    }
}

foreach(sort{$a<=>$b}(keys %mth_lev)){
     my $aver= $mth_lev{$_}/($mth_nu{$_}+0.0000001);
     print OUT "$_\t$aver\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <Gene postion with RANK> <OUTPUT>
    This is to get the methylation distribution throughth gene for different rank of gene.
DIE
}
