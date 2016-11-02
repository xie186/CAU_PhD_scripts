#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($map_loca,$db,$tab,$gff,$out)=@ARGV;
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
open POS,$gff or die;
my %smRNA_nu;my %ele_len;my %flag;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%10000==0;$flag++;
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand)=(split(/\s+/,$line))[0,2,3,4,6];
    next if ($ele=~/mRNA/ ||$ele=~/CDS/ || $ele=~/gene/ || $end-$stt==0);
    $chr="chr".$chr;
      my $row=$dbh->prepare(qq(select * from $tab where chrom="$chr" and pos>=$stt-31 and pos<=$end+31));
           $row->execute();
      my ($id,$len,$copy,$strd,$chrom,$pos)=(0,0,0,0,0);
           $row->bind_columns(\$id,\$len,\$copy,\$strd,\$chrom,\$pos);
 
    $ele_len{"$ele"}+=($end-$stt+1);
    while($row->fetch()){
         next if ($len!=24 && $len!=22 && $len!=21);
         $pos=int ($pos+$len/2);
         my $nu_norm=$copy/$hash_loca{$id};
         &cal($stt,$end,$strand,$pos,$nu_norm,$ele,$len,$strd) if ($pos>=$stt && $pos<=$end);
    }
}

foreach(sort keys %smRNA_nu){
    my ($ele)=(split(/\t/))[-2];
    my $meth=$smRNA_nu{$_}*1000000*100/$ele_len{$ele};
    print OUT "$_\t$meth\n";
}
close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$nu_norm,$ele,$len,$strd)=@_;
    my $unit=($end-$stt+1)/100;
    my $keys=0;
    if($strand eq '+'){
        $keys=int (($pos1-$stt+1)/$unit);
    }else{
        $keys=int (($end-$pos1+1)/$unit);
    }
    $keys-=1 if $keys==100;
    $smRNA_nu{"$len\t$strd\t$ele\t$keys"}+=$nu_norm;
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Map location numner> <database [smRNA]> <table [smRNA_BM] <GFF_exp or noexp> <OUTPUT>
    This is to get the smRNA distribution througth gene for expressed or non expressed gene.
DIE
}
