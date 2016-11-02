#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($tissue,$forw,$rev,$gff,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,$gff or die;
my %meth_forw;my %meth_forw_nu;my %flag;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%10000==0;$flag++;
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand)=(split(/\s+/,$line))[0,2,3,4,6];
    next if ($ele=~/mRNA/ ||$ele=~/CDS/ || $ele=~/gene/ || $end-$stt==0);
    $chr="chr".$chr;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            &cal($stt,$end,$strand,$tem_pos1,$lev,$ele);
        }
    }
}

foreach(sort keys %meth_forw){
    my $meth=$meth_forw{$_}/$meth_forw_nu{$_};
    print OUT "$_\t$meth\n";
}
close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$ele)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        $keys=int (($pos1-$stt)/$unit);
    }else{
        $keys=int (($end-$pos1)/$unit);
    }
    $meth_forw{"$ele\t$keys"}+=$methlev;
    $meth_forw_nu{"$ele\t$keys"}++;
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <GFF_exp or noexp> <OUTPUT>
    This is to get the methylation distribution throughth gene for expressed or non expressed gene.
DIE
}
