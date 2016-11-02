#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==8;
my ($gff,$ele,$tis,$forw,$rev,$bin,$syn,$out) = @ARGV;

open SYN,$syn or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($zm_gene,$rice_gene) = split;
    $hash_syn{$zm_gene} ++;
    $hash_syn{$rice_gene} ++;
}

my $dbh=DBI->connect("dbi:mysql:database=$tis","root","123456") or die "$DBI::errstr\n";
open OUT,"|sort -k2,2n >$out" or die;
open POS,$gff or die;
my %meth_forw;my %meth_forw_nu;my %flag;my $flag=1;
my %hash_uniq;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%10000==0;$flag++;
    chomp $line;
    my ($chr,$tool,$ele,$stt,$end,$flag1,$strand,$flag2,$name) = split(/\s+/,$line);
    next if $chr !~ /\d/;
    next if ($ele=~/mRNA/ ||$ele=~/CDS/ || $ele=~/gene/ || $end-$stt+1 < 100);
    my ($gene_name) = &get_gene_name($name, $tis);
    #print "$name, $tis\n";
    next if !exists $hash_syn{$gene_name};
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

sub get_gene_name{
    my ($name, $tem_spec) = @_;
    my $gene_name;
    if($tem_spec =~ /ara/ || $tem_spec =~ /rice/){
        ($gene_name) = $name =~ /(.*)\.\d+/;
    }else{
        ($gene_name) = $name =~ /Parent=(.*);Name=/;
        ($gene_name) = split(/_/,$gene_name) if $gene_name =~ /^GRMZM/;
    }
#    print "$name, $tem_spec \t $gene_name\n";
    return $gene_name;
}

sub usage{
    print <<DIE;
    perl *.pl <GFF> <ele> <tissue> <OT> <OB> <bin number> <Syntenic genes> <out> 
DIE
    exit 1;
}
