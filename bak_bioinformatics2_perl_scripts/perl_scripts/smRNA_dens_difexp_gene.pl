#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==5;
my ($database,$tissue,$len_cut,$ge_pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$database","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$ge_pos or die;
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand,$type)=(split(/\t/,$line))[0,1,2,3,4,5];
    $chr="chr".$chr;
    my %hash_forw;my %hash_rev;
    my $row=$dbh->prepare(qq(select * from $tissue where chrom="$chr" and pos>=$stt-1999-30 and pos<=$end+1999+30));
       $row->execute();
    my ($id,$len,$copy,$rna_strand,$chrom,$pos)=(0,0,0,0,0,0);
       $row->bind_columns(\$id,\$len,\$copy,\$rna_strand,\$chrom,\$pos);
    while($row->fetch()){
       next if $len==$len_cut;
       if($rna_strand==16){
          $pos=$pos+$len-1;
          $hash_rev{"$chr\t$pos"}=$copy;
       }else{
          $hash_forw{"$chr\t$pos"}=$copy;
       }
    }
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        &cal($stt,$end,$strand,$i,$hash_forw{"$chr\t$i"},$type,"forw_derive") if(exists $hash_forw{"$chr\t$i"});
        &cal($stt,$end,$strand,$i,$hash_rev{"$chr\t$i"},$type,"rev_derive") if(exists $hash_rev{"$chr\t$i"});
    }
    %hash_forw=();
    %hash_rev=();
}

foreach(sort keys %meth_forw){
    my $meth_forwprint=$meth_forw{$_}/$meth_forw_nu{$_};
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_forwprint\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$type,$derive)=@_;
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
    $keys=$derive."\t".$type."\t".$keys;
    $meth_forw{$keys}+=$methlev;
    $meth_forw_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA> <tissue smRNA_em or smRNA_endo> <Length cutoff(24,22,21)> <Gene position with type(protein coding,pseudogene and transposable elements)> <OUTPUT>
    This is to get the methylation distribution through gene
DIE
}
