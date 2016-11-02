#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==5;
my ($database,$tissue,$ge_pos,$smRNA_tol,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$database","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$ge_pos or die;
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand,$type)=(split(/\t/,$line))[0,1,2,3,4,5];
    print "$line\n";
    $chr="chr".$chr;
    my %hash_forw;my %hash_rev;
    my $row=$dbh->prepare(qq(select * from $tissue where chrom="$chr" and pos>=$stt-1999-30 and pos<=$end+1999+30));
       $row->execute();
    my ($id,$len,$copy,$rna_strand,$chrom,$pos)=(0,0,0,0,0,0);
       $row->bind_columns(\$id,\$len,\$copy,\$rna_strand,\$chrom,\$pos);
    while($row->fetch()){
       print "$id,$len,$copy,$rna_strand,$chrom,$pos\n";
       next if ($pos<$stt-1999 || $pos>$end+1999);
       if($rna_strand==16){
          $pos=$pos+$len-1;
          &cal($stt,$end,$strand,$pos,$copy,$type,"forw_derive",$len);
       }else{
          &cal($stt,$end,$strand,$pos,$copy,$type,"rev_derive",$len);
       }
    }
}

foreach(sort keys %meth_forw){
    my $meth_forwprint=$meth_forw{$_}*1000000/$meth_forw_nu{$_}/$smRNA_tol;
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_forwprint\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$type,$derive,$len)=@_;
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
    $keys=$len."\t".$derive."\t".$type."\t".$keys;
    $meth_forw{$keys}+=$methlev;
    $meth_forw_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA databases> <tissues [smRNA_BM] [smRNA_MB]> <Gene position with type> <smRNA library [14943879][14077326]> <OUTPUT>
    This is to get the smRNA distribution through gene
DIE
}
