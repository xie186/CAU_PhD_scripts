#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==7;
my ($gff,$ele,$tis,$forw,$rev,$bin,$out) = @ARGV;

my $dbh=DBI->connect("dbi:mysql:database=$tis","root","123456") or die "$DBI::errstr\n";
open OUT,"|sort -k2,2n >$out" or die;
open POS,$gff or die;
my %meth_forw;my %meth_forw_nu;my %flag;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%10000==0;$flag++;
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand)=(split(/\s+/,$line))[0,2,3,4,6];
    next if ($ele=~/mRNA/ ||$ele=~/CDS/ || $ele=~/gene/ || $end-$stt+1 < 100);
    ($ele) = $ele =~ /_(.*)/ if $ele =~/_/;
    $chr="chr".$chr if $chr !~/[a-z]/;
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
    perl *.pl <GFF> <ele> <tissue> <OT> <OB> <bin number> <out> 
DIE
    exit 1;
}

