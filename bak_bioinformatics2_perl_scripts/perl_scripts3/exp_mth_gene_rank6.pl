#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($tissue,$forw,$rev,$pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,$pos or die;
my %meth_forw;my %meth_forw_nu;my %flag;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    next if $line =~/^#/;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand,$type,$rpkm,$rank)=split(/\s+/,$line);
    $chr="chr".$chr;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            &cal($stt,$end,$strand,$tem_pos1,$lev,$rank);
        }
    }
}

foreach(sort keys %flag){
    my $meth_rank0=$meth_forw{"$_\t0"}/$meth_forw_nu{"$_\t0"};
    my $meth_rank1=$meth_forw{"$_\t1"}/$meth_forw_nu{"$_\t1"};
    my $meth_rank2=$meth_forw{"$_\t2"}/$meth_forw_nu{"$_\t2"};
    my $meth_rank3=$meth_forw{"$_\t3"}/$meth_forw_nu{"$_\t3"};
    my $meth_rank4=$meth_forw{"$_\t4"}/$meth_forw_nu{"$_\t4"};
    my $meth_rank5=$meth_forw{"$_\t5"}/$meth_forw_nu{"$_\t5"};
    print OUT "$_\t$meth_rank0\t$meth_rank1\t$meth_rank2\t$meth_rank3\t$meth_rank4\t$meth_rank5\n";
}

system qq(sort -k2,2n -k1,1n $out > $out.res);

close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$rank)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys.="\t-1";                     # -1,0 and 1 represented promoter,gene body and 3'terminal respectively.
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys.="\t0";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys.="\t1";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys.="\t1";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys.="\t0";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys.="\t-1";
        }
    }
    $meth_forw{"$keys\t$rank"}+=$methlev;
    $meth_forw_nu{"$keys\t$rank"}++;
    $flag{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <Gene postion with RANK> <OUTPUT>
    This is to get the methylation distribution throughth gene for different rank of gene.
DIE
}
