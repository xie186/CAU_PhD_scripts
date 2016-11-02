#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==7;
my ($rpkm_both,$gene_pos,$tissue1,$tissue2,$forw,$rev,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue1","root","123456");
my $dbh1=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
   ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue2","root","123456");
my $dbh2=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die "$!";
open POS,$gene_pos or die "$!";
my %hash;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    $hash{$gene}=$_;
}

my %meth_forw;my %meth_forw_nu;
open RPKM,$rpkm_both or die "$!";
while(my $line=<RPKM>){
    chomp $line;
    my ($tem_gene)=(split(/\t/,$line))[0];
    my ($chr,$stt,$end,$gene,$strand)=split(/\s+/,$hash{$tem_gene});
    $chr="chr".$chr;
    foreach($forw,$rev){
        my $row=$dbh1->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            &cal($stt,$end,$strand,$tem_pos1,$lev,$tissue1);
        }
    }
    foreach($forw,$rev){
        my $row=$dbh2->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            &cal($stt,$end,$strand,$tem_pos1,$lev,$tissue2);
        }
    }
}

foreach(sort keys %meth_forw){
    my $meth=$meth_forw{$_}/$meth_forw_nu{$_};
    print OUT "$_\t$meth\n";
}
close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$tissue)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="a_prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys="b_body\t$keys";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys="c_term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="c_term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys="b_body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="a_prom\t$keys";
        }
    }
    $keys=$tissue."\t".$keys;
    $meth_forw{$keys}+=$methlev;
    $meth_forw_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM in both tissues> <Gene position> <Tissue1> <Tissue2> <Forword> <Reverse>  <OUTPUT>
    This is to get the methylation distribution throughth gene for expressed in both two tissues:seedlings and endosperm
DIE
}
