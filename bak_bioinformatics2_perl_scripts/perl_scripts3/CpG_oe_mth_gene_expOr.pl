#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==6;
my ($tissue,$forw,$rev,$rpkm,$ge_cpg,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open RPKM,$rpkm or die "$!";
my %hash_exp;
while(<RPKM>){
    chomp;
    my ($gene,$tem_rpkm)=(split)[0,-1];
    $hash_exp{$gene}=$tem_rpkm;
}

my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
open DUP,$ge_cpg or die "$!";
while(my $line=<DUP>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$gene,$strand,$type,$cpg_com)=(split(/\s+/,$line))[0,1,2,3,4,5,11];
       $chr="chr".$chr;
    my $cpg;
    if($cpg_com<0.9){
        $cpg="low";
    }else{
        $cpg="high";
    }
    my $exp="expno";
       $exp="exp" if $hash_exp{$gene}>0;
    ####  Gene 
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
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"},$cpg,$exp);
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
system(qq(sort -k3,3n -k4,4n $out >$out.srt));

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$teOr,$rpkm)=@_;
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
    $keys="$teOr\t$rpkm\t$keys";
    $meth_forw{$keys}+=$methlev;
    $meth_forw_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    \nperl *.pl <Tissue> <Forword> <Reverse> <RPKM> <CpG O/E> <OUTPUT>
    This is to get the methylation distribution throughth of different types of genes:
    Low exp 
    Low non-exp
    High exp
    High no-nexp\n
DIE
}
