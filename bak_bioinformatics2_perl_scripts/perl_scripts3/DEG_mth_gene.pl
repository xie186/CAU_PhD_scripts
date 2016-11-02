#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==7;
my ($tis1,$tis2,$tis3,$forw,$rev,$prefer,$out)=@ARGV;
my @tissue=($tis1,$tis2,$tis3);
my @dbh;
my $i=0;
foreach(@tissue){
    my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue[$i]","root","123456");
    $dbh[$i]=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
    ++$i;
}

my %meth_forw;my %meth_forw_nu;my $flag=1;
open PRE,$prefer or die "$!";
while(my $line=<PRE>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$gene,$strand)=split(/\t/,$line);
    ####  Gene 
    my %hash;
    $chr = "chr".$chr;
    for(my $j=0;$j<@dbh;$j++){
        foreach my $context($forw,$rev){
            my $row=$dbh[$j]->prepare(qq(select * from $context where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
               $row->execute();
            my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
               $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
            while($row->fetch()){
               $hash{"$chr\t$pos1"}=$lev;
            }
        }
        foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
            if(exists $hash{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"},$j);
            }
        }
    %hash=();
    }
}

open OUT,"+>$out" or die "$!";
foreach(sort keys %meth_forw){
    my $meth_forwprint1=${$meth_forw{$_}}[0]/${$meth_forw_nu{$_}}[0];
    my $meth_forwprint2=${$meth_forw{$_}}[1]/${$meth_forw_nu{$_}}[1];
    my $meth_forwprint3=${$meth_forw{$_}}[2]/${$meth_forw_nu{$_}}[2];
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_forwprint1\t$meth_forwprint2\t$meth_forwprint3\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$j)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    ${$meth_forw{$keys}}[$j]+=$methlev;
    ${$meth_forw_nu{$keys}}[$j]++;
}

sub usage{
    my $die=<<DIE;
    \nperl *.pl <Tissue [3]> <Forword> <Reverse> <Preferred genes> <OUTPUT>
    This is to get the methylation distribution throughth of different types of genes:
    \n
DIE
}
