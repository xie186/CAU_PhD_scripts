#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==3;
my ($db,$tab,$lhp)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$db","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr";
open LHP,$lhp or die "$!";
my %hash;
while(<LHP>){
     chomp;
     my ($chr)=$_=~/(chr\d+)/;
     my $fir=<LHP>;
     my ($pos1,$pos2)=$fir=~/(\d+)\s+.*\s+(\d+)\s*/;
        ($pos1,$pos2)=sort{$a<=>$b}($pos1,$pos2);
#     print "$chr,$pos1,$pos2\n";
     &get_smRNA($chr,$pos1,$pos2);
#     print "$chr,$pos1,$pos2\n";
     <LHP>;
     my $sec=<LHP>;
        ($pos1,$pos2)=$sec=~/(\d+)\s+.*\s+(\d+)\s*/;
        ($pos1,$pos2)=sort{$a<=>$b}($pos1,$pos2);
     &get_smRNA($chr,$pos1,$pos2);
#     print "$chr,$pos1,$pos2\n";
}

foreach(sort{$a<=>$b}keys %hash){
    print "$_\t$hash{$_}\n";
}
sub get_smRNA{
    my ($chr,$stt,$end)=@_;
    my $row=$dbh->prepare(qq(select * from $tab where chrom="$chr" and pos>=$stt-31 and pos<=$end+31));
       $row->execute();
    my ($id,$len,$copy,$strd,$chrom,$pos)=(0,0,0,0,0);
       $row->bind_columns(\$id,\$len,\$copy,\$strd,\$chrom,\$pos);
    while($row->fetch()){
#       next if ($len!=24 && $len!=22 && $len!=21);
       $pos=int ($pos+$len/2);
       $hash{$len}+=$copy if($pos>=$stt && $pos<=$end);
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl  <database [smRNA]> <smRNA_BM> <lhp>
DIE
}
