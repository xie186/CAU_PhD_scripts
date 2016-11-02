#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==4;
my ($forw,$rev,$pos,$out)=@ARGV;

open OUT,"+>$out" or die;
my $start_time=localtime();

open FORW,$forw or die "$!";my %hash;
while(<FORW>){
    chomp;
    my ($chrom,$pos,$depth,$meth_lev)=(split)[0,1,3,4];
    next if $depth<3;
    $hash{"$chrom\t$pos"}=$meth_lev;
    print "$chrom\t$pos\n";
}

open REV,$rev or die "$!";
while(<REV>){
    chomp;
    my ($chrom,$pos,$depth,$meth_lev)=(split)[0,1,3,4];
    next if $depth<3;
    $hash{"$chrom\t$pos"}=$meth_lev;
}

open POS,$pos or die;
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$strand)=(split(/\s+/,$line))[0,3,4,6];
    $chr="chr".$chr;
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $hash{"$chr\t$i"}){

            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"});
        }
    }
}
%hash=();

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
        }elsif($pos1>=$stt && $pos1<=$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys.="\tbody";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys.="\tter";
        }
    }else{
        if($pos1<$stt){
            $keys=int(($stt-$pos1)/100);
            $keys.="\tter";
        }elsif($pos1>=$stt && $pos1<=$end){
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
    perl *.pl <Forword> <Reverse> <Gene or TEs postion> <OUTPUT>
    This is to get the methylation distribution throughth gene or TEs
DIE
}
