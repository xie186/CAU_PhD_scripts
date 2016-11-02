#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==1;
my ($tab)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=MO17","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr";
my %hash;
open TAB,$tab or die "$!";
while(<TAB>){
    chomp;
    my ($id,$len,$nu,$strand,$chr,$pos) =split;
    my $tem=$dbh->prepare(qq(select * from snp where chrom="$chr" and pos>=$pos and pos<=$pos+$len-1));
       $tem->execute();
    my ($chrom,$tem_pos,$alle1,$alle2)=(0,0,0,0);
       $tem->bind_columns(\$chrom,\$tem_pos,\$alle1,\$alle2);
    my $flag=0;
    while($tem->fetch()){
        $flag++;
    } 
    next if $flag==0;
    print "$_\t$chrom\t$tem_pos\n";  
}

sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA table>
DIE
}
