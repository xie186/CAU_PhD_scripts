#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==5;
my ($map_loca,$db,$tab,$ge_pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$db","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open MAP,$map_loca or die "$!";
my %hash_loca;
while(<MAP>){
    chomp;
    my ($id,$len,$copy,$map_loca)=split;
    $hash_loca{$id}=$map_loca;
}

open OUT,"+>$out" or die;
open POS,$ge_pos or die;
my %smrna;my %smrna_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand,$type)=(split(/\t/,$line))[0,1,2,3,4,5];
    $chr="chr".$chr;
    my %hash;

        my $row=$dbh->prepare(qq(select * from $tab where chrom="$chr" and pos>=$stt-2031 and pos<=$end+2031));
           $row->execute();
        my ($id,$len,$copy,$strd,$chrom,$pos)=(0,0,0,0,0);
           $row->bind_columns(\$id,\$len,\$copy,\$strd,\$chrom,\$pos);
        while($row->fetch()){
           next if ($len!=24 && $len!=22 && $len!=21);
           $pos=int ($pos+$len/2);
           $hash{"$chrom\t$pos"}+=$copy/$hash_loca{$id};
        }
    
    foreach(my $i=$stt-1999;$i<=$end+1999;++$i){
        &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"},$type,$len,$strd) if exists $hash{"$chr\t$i"};
    }
    %hash=();
}

foreach(sort keys %smrna){
    my $smrna_print=$smrna{$_}/$smrna_nu{$_};
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$smrna_print\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$smrna_nu,$type,$len,$strd)=@_;
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
    $keys=$len."\t".$strd."\t".$type."\t".$keys;
    $smrna{$keys}+=$smrna_nu;
    $smrna_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA> <table> <Gene position with type(protein coding,pseudogene and transposable elements)> <OUTPUT>
    This is to get the smRNA distribution througth gene
DIE
}
