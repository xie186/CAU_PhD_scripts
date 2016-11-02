#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==4;
my $start=localtime();
my ($tissue,$forw,$rev,$gff)=@ARGV;
my ($driver,$dsn,$user,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$user,$pswd) or die "$DBI::errstr\n";

open GFF,$gff or die "$!";
my ($fir,$sec,$thi,$for,$fiv,$six,$sev,$eig,$nine,$ten)=(0,0,0,0,0,0,0,0,0,0);
while(<GFF>){
    next if /^#/;
    chomp;
    my ($chr,$stt,$end)=(split)[0,1,2];
    $chr=0 if $chr eq "UNKNOWN";
    my $row=$dbh->prepare(qq(select * from $forw where chrom="chr$chr" and pos1>=$stt and pos1<=$end));
       $row->execute();
    my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev,$flag)=(0,0,0,0,0,0);
       $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
    while($row->fetch()){
       $flag++;
#       print "$chrom,$tem_pos1,$tem_pos2,$depth,$lev,$flag\n";
       &cal($chrom,$tem_pos1,$tem_pos2,$depth,$lev);
    }
        $row=$dbh->prepare(qq(select * from $rev where chrom="chr$chr" and pos1>=$stt and pos1<=$end));
        $row->execute();
        $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
    while($row->fetch()){
       $flag++;
       &cal($chrom,$tem_pos1,$tem_pos2,$depth,$lev);
    }
}

my $total=$fir+$sec+$thi+$for+$fiv+$six+$sev+$eig+$nine+$ten;
my ($fir_ratio,$sec_ratio,$thi_ratio,$for_ratio,$fiv_ratio,$six_ratio,$sev_ratio,$eig_ratio,$nine_ratio,$ten_ratio)=($fir/$total,$sec/$total,$thi/$total,$for/$total,$fiv/$total,$six/$total,$sev/$total,$eig/$total,$nine/$total,$ten/$total);
my $end_time=localtime();
print "$forw.$rev\t$fir_ratio\t$sec_ratio\t$thi_ratio\t$for_ratio\t$fiv_ratio\t$six_ratio\t$sev_ratio\t$eig_ratio\t$nine_ratio\t$ten_ratio\n$start\t$end_time\n";

sub cal{
    my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=@_;
            if($lev<=10){
                $fir++;
            }elsif($lev<=20 && $lev>10){
                $sec++;
            }elsif($lev<=30 && $lev>20){
                $thi++;
            }elsif($lev<=40 && $lev>30){
                $for++;
            }elsif($lev<=50 && $lev>40){
                $fiv++
            }elsif($lev<=60 && $lev>50){
                $six++;
            }elsif($lev<=70 && $lev>60){
                $sev++;
            }elsif($lev<=80 && $lev>70){
                $eig++;
            }elsif($lev<=90 && $lev>80){
                $nine++;
            }else{
                $ten++
            }
    return ($fir,$sec,$thi,$for,$fiv,$six,$sev,$eig,$nine,$ten);
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Tissue> <Bedgraph file OT> <Bedgraph file OB> <GFF repeats>
DIE
}

