#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==4;
my ($chip_db,$his_mod,$gff,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$chip_db","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,$gff or die;
my %chip_dep;my %chip_len;my %flag;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%10000==0;$flag++;
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand)=split(/\s+/,$line);
    next if ($ele=~/mRNA/ ||$ele=~/CDS/ || $ele=~/gene/ || $end-$stt==0);
    $chr="chr".$chr;
    $chip_len{$ele} += ($end-$stt+1)/20;
    my $row=$dbh->prepare(qq(select * from $his_mod where chrom="$chr" and pos>=$stt and pos<=$end));
       $row->execute();
    my ($chrom,$tem_pos1,$depth)=(0,0,0);
        $row->bind_columns(\$chrom,\$tem_pos1,\$depth);
    while($row->fetch()){
        &cal($stt,$end,$strand,$tem_pos1,$depth,$ele);
    }
}

foreach(sort keys %chip_dep){
    my ($ele) = split(/\t/,$_);
    my $aver=$chip_dep{$_}/$chip_len{$ele};
    print OUT "$_\t$aver\n";
}
close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$depth,$ele)=@_;
    my $unit=($end-$stt+1)/20;
    my $keys=0;
    if($strand eq '+'){
        $keys=int (($pos1-$stt+1)/$unit);
    }else{
        $keys=int (($end-$pos1+1)/$unit);
    }
    $keys-=1 if $keys==20;
    $chip_dep{"$ele\t$keys"}+=$depth;
}
sub usage{
    my $die=<<DIE;
    perl *.pl <chip_dens> <histone modification> <GFF_exp or noexp> <OUTPUT>
    This is to get the chip reads throughth gene for expressed or non expressed gene.
DIE
}
