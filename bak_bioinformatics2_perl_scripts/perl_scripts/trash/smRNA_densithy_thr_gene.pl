#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==3;
my ($small,$pos,$out)=@ARGV;

my %hash;
open SM,$small or die "$!";
while(<SM>){
    chomp;
    my ($id,$chr,$pos1,$pos2)=(split)[0,1,8,9];
    my $pos=int (($pos1+$pos2)/2);
    ($id)=$id=~/number-(\d+)/;
    $hash{"$chr\t$pos"}=$id;
}

open OUT,"+>$out" or die;
open POS,$pos or die;
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
    next if $ele!~/gene/;
    $chr="chr".$chr;
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"});
        }
    }
}

foreach(sort keys %meth_forw){
    my $meth_forwprint=$meth_forw{$_}/$meth_forw_nu{$_};
    print OUT "$_\t$meth_forwprint\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    $meth_forw{$keys}+=$methlev;
    $meth_forw_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA_blastm8> <Genes> <OUTPUT>
    This is to get the 24 nt smRNA dendity throughth gene
DIE
}
