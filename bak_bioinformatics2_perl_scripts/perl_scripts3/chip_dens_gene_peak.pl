#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==3;
my ($chip_peak,$pos,$out)=@ARGV;

open CHIP,$chip_seq or die "$!";
my %hash_peak;
while(<CHIP>){
    my ($chr,$stt,$end)=split;
    for(my $i = $stt;$i <= $end;++$i){
        $hash_peak{"$chr\t$i"}++;
    }
}

open OUT,"+>$out" or die;
open POS,$pos or die "$!";
my %chip_depth;my %chip_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$gene,$strand)=(split(/\t/,$line));
    $chr="chr".$chr;
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $hash_gene{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash_gene{"$chr\t$i"});
        }
    }
}

foreach(sort keys %chip_depth){
    my $chip_aver_dep=$chip_depth{$_}/$chip_nu{$_};
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$chip_aver_dep\n";
}
close OUT;

#system qq(sort -k1,1n -k2,2n $out >$out.res);

sub cal{
    my ($stt,$end,$strand,$pos1,$chip_dep)=@_;
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
    $chip_depth{$keys}+=$chip_dep;
    $chip_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Chip seq depth> <Genes> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
