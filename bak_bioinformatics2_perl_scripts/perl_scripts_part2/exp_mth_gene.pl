#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($tissue,$forw,$rev,$pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$pos or die "$!";
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$gene,$strand)=(split(/\t/,$line));
    $chr="chr".$chr;
    my %hash;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $hash{"$chr\t$pos1"}=$lev;
        }
    }
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"});
        }
    }
    %hash=();
}

foreach(sort keys %meth_forw){
    my $meth_forwprint=$meth_forw{$_}/$meth_forw_nu{$_};
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_forwprint\n";
}
close OUT;
#system qq(sort -k1,1n -k2,2n $out >$out.res;mv $out.res $out);

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev)=@_;
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
    $meth_forw{$keys}+=$methlev;
    $meth_forw_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <Genes> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
