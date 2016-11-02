#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==5;
my ($dmr,$forw,$rev,$out,$tissue)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die "$!";
open DMR,$dmr or die "$!";
while(<DMR>){
    chomp;
    my @print;
    my ($chr,$stt,$end)=(split)[0,5,6];
         my ($meth1,$unmeth1,$methlev1)=&get($chr,$stt,$end);
         my $reads=$meth1+$unmeth1;
        print OUT "$_\t$reads\t$methlev1\n";
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($meth,$unmeth,$methlev)=(0,0,0);
    foreach ($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chrom" and pos1>=$stt and pos1<=$end));
           $row->execute();
#        print "execute\n";
        my ($chrm,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrm,\$pos1,\$pos2,\$depth,\$lev);
#        print "bind_columns\n";
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
    Usage:perl *.pl <DMR region> <Forw> <Rev> <OUT1> <Tissue B73XB73>
    OUTPUT:
    <Chrom> <STT> <END> <T1_meth_nu> <T1-unmeth_nu> <T1_methlev> <T2_meth_nu> <T2_unmeth_nu> <T2_methlev> 
DIE
}
