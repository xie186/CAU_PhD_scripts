#!/usr/bin/perl -w
use strict;
use DBI;
die usage() if @ARGV==0;
my ($dmr,$forw,$rev,$out,@tissue)=@ARGV;
my @dbh;my $i=0;
foreach(@tissue){
    my ($driver,$dsn,$usr,$pswd)=("mysql","database=$_","root","123456");
    $dbh[$i]=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
    ++$i;
}
open DMR,$dmr or die "$!";
open OUT,"+>$out" or die "$!";
while(<DMR>){
    chomp;
    my ($chrom,$stt,$end)=split;
    my @print;
    for(my $j=0;$j<@dbh;++$j){
        my ($meth1,$unmeth1,$methlev1)=&get($chrom,$stt,$end,$dbh[$j]);
        push @print,($meth1,$unmeth1,$methlev1);
    }
    my $print=join("\t",@print);
    print OUT "$chrom\t$stt\t$end\t$print\n";
}

sub get{
    my ($chrom,$stt,$end,$dbh)=@_;
    my ($meth,$unmeth,$methlev)=(0,0,0);
    foreach ($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chrom" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrm,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrm,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $methlev+=$lev;
           if($lev>=20){
               $meth++;
           }else{
               $unmeth++;
           }
        }
    }
    $methlev=$methlev/($meth+$unmeth+0.00001);
    return ($meth,$unmeth,$methlev);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <DMR> <Forw> <Rev> <OUT1> <Tissue INT>
    OUTPUT:
    <Chrom> <STT> <END> <T1_meth_nu> <T1-unmeth_nu> <T1_methlev> <T2_meth_nu> <T2_unmeth_nu> <T2_methlev> <Fiser P-value>

DIE
}
