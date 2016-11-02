#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==6;
my ($gff,$tis,$forw,$rev,$bin,$out) = @ARGV;

my $dbh=DBI->connect("dbi:mysql:database=$tis","root","123456") or die "$DBI::errstr\n";
open OUT,"|sort -k2,2n >$out" or die;
open POS,$gff or die;
my %meth_forw;my %meth_forw_nu;my %flag;my $flag=1;
my %hash_uniq;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%10000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$ele,$strand,$intron_nu,$te_or) = split(/\s+/,$line);
    $chr="chr".$chr if $chr !~/[a-z]/;
    if($te_or eq '.'){
        $te_or = "NT";
    }else{
        $te_or = "TE";
    }
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            &cal($stt,$end,$strand,$tem_pos1,$lev,$te_or);
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
    my $unit=($end-$stt+1)/$bin;
    my $keys=0;
    if($strand eq '+'){
        $keys=int (($pos1-$stt+1)/$unit);
    }else{
        $keys=int (($end-$pos1+1)/$unit);
    }
    $keys-=1 if $keys == $bin;
    $meth_forw{"$ele\t$keys"}+=$methlev;
    $meth_forw_nu{"$ele\t$keys"}++;
}

sub usage{
    print <<DIE;
    perl *.pl <GFF>  <tissue> <OT> <OB> <bin number> <out> 
DIE
    exit 1;
}
