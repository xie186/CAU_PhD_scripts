#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==6;
my ($tissue,$forw,$rev,$ge_pos,$dup,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$ge_pos or die;
my %hash_ge;
while(my $line=<POS>){
    chomp $line;
    my ($chr,$stt,$end,$name,$strand)=(split(/\t/,$line))[0,1,2,3,4];
    $hash_ge{$name}="chr".$line;
}
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
open DUP,$dup or die "$!";
while(my $line=<DUP>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($gene,$tem1,$tem2,$rpkm,$cpg_oe,$intron)=split(/\s+/,$line);
    if($cpg_oe>0.9){
        $cpg_oe="HIGH";
    }else{
        $cpg_oe="LOW";
    }
    if($rpkm>0){
        $rpkm="exp";
    }else{
        $rpkm="expno";
    }
    ####  Gene 
    my %hash;
    my ($chr,$stt,$end,$name,$strand)=split(/\s+/,$hash_ge{$gene});
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
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"},$cpg_oe,$intron,$rpkm);
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
system(qq(sort -k1,1n -k2,2n -k3,3n $out >$out.srt));

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$cpg_oe,$intron,$rpkm)=@_;
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
    $keys="$intron\t$cpg_oe\t$rpkm\t$keys";
    $meth_forw{$keys}+=$methlev;
    $meth_forw_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    \nperl *.pl <Tissue> <Forword> <Reverse> <Gene position> <Gene FPKM with CpG OE and TE status> <OUTPUT>
    This is to get the methylation distribution throughth of different types of genes:
    [High CpG && TE] 
    [High CpG && no TE]
    [Low CpG && TE]
    [Low CpG && no TE]\n
DIE
}
