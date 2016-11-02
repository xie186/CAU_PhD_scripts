#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==6;
my ($geno_len,$forw,$rev,$tissue1,$tissue2,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue1","root","123456");
my $dbh1=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
   ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue2","root","123456");
my $dbh2=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
my ($chrom_rcode)=$geno_len=~/(chr\d+)/;
open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    $hash{$chr}=$len;
}

open OUT,"+>$out" or die "$!";
foreach my $chrom(keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/100-1;++$i){
        my ($stt,$end)=(($i-1)*100,($i-1)*100+300);
        my ($meth1,$unmeth1,$methlev1)=&get($chrom,$stt,$end,$dbh1);
        my ($meth2,$unmeth2,$methlev2)=&get($chrom,$stt,$end,$dbh2);
#        my ($fish)=&fish($meth1,$unmeth1,$meth2,$unmeth2);
        #print OUT "$chrom\t$stt\t$end\t$meth1\t$unmeth1\t$methlev1\t$meth2\t$unmeth2\t$methlev2\t$fish\n";
        print OUT "$chrom\t$stt\t$end\t$meth1\t$unmeth1\t$methlev1\t$meth2\t$unmeth2\t$methlev2\n";
    }
}

sub fish{
    my ($meth1,$unmeth1,$meth2,$unmeth2)=@_;
    open OUT1,"+>DMR_$chrom_rcode.R" or die "$!";
    print OUT1 "dmr<-c($unmeth1,$unmeth2,$meth1,$meth2)\ndim(dmr)=c(2,2)\nfisher.test(dmr)";
    close OUT1;
    my $report=`R --vanilla --slave <DMR_$chrom_rcode.R`;
    my ($p_value)=$report=~/p-value\s+=\s+(.*)\nalternative/;
    return $p_value;
}
sub get{
    my ($chrom,$stt,$end,$dbh)=@_;
    my ($meth,$unmeth,$methlev)=(0,0,0);
    foreach ($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chrom" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrm,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrm,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $methlev+=$lev;
           if($lev>=20){
               $meth++;
           }else{
               $unmeth++;
           }
        }
    }
    $methlev=$methlev/($meth+$unmeth+0.00001);
    return ($meth,$unmeth,$methlev);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <Forw> <Rev> <Tissue1> <Tissue2> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> <T1_meth_nu> <T1-unmeth_nu> <T1_methlev> <T2_meth_nu> <T2_unmeth_nu> <T2_methlev> <Fiser P-value>

DIE
}
