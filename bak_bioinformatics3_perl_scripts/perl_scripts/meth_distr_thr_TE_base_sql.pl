#!/usr/bin/perl -w
use strict;use DBI;
my ($tissue,$forw,$rev,$pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

die "\n",usage(),"\n" unless @ARGV==5;
open OUT,"+>$out" or die;
my $start_time=localtime();
open POS,$pos or die;
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    next if $line=~/^#/;
    my ($chr,$stt,$end,$strand)=(split(/\s+/,$line))[0,3,4,6];
    $chr="chr".$chr;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" AND pos1>=$stt-1999 AND pos1<=$end+1999));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
        $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            &cal($stt,$end,$strand,$tem_pos1,$lev);
        }
    }
}

foreach(sort keys %meth_forw){
    my $meth_forwprint=$meth_forw{$_}/$meth_forw_nu{$_};
    print OUT "$_\t$meth_forwprint\n";
}

my $end_time=localtime();
#print OUT "$start_time\t$end_time\n";
close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$methlev)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys.="\tprom";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys.="\tbody";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys.="\tter";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys.="\tter";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys.="\tbody";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys.="\tprom";
        }
    }
    $meth_forw{$keys}+=$methlev;
    $meth_forw_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue>,<Forw>,<Rev>,<GFF>,<OUT>
    This is to get the methylation distribution throughth gene or TEs
DIE
}
