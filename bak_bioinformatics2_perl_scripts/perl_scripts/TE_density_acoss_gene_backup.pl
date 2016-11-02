#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==4;
my ($gff$pos,$out)=@ARGV;

open OUT,"+>$out" or die;
my $start_time=localtime();

open GFF,$forw or die "$!";my %hash;
while(<GFF>){
    chomp;
    my ($chrom,$pos,$depth,$meth_lev)=(split)[0,1,3,4];
    next if ($depth<3 || $chrom ne '1');
    $hash{"$chrom\t$pos"}=$meth_lev;
    print "$chrom\t$pos\n";
}

open POS,$pos or die;
my %meth_forw;my %meth_forw_nu;my %flag;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($name,$chr,$stt,$end,$strand,$rpkm,$rank)=split(/\s+/,$line);
    $chr="chr0".$chr;
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"},$rank);
        }
    }
}
%hash=();

foreach(sort keys %flag){
    my $meth_rank1=$meth_forw{"$_\t1"}/$meth_forw_nu{"$_\t1"};
    my $meth_rank2=$meth_forw{"$_\t2"}/$meth_forw_nu{"$_\t2"};
    my $meth_rank3=$meth_forw{"$_\t3"}/$meth_forw_nu{"$_\t3"};
    my $meth_rank4=$meth_forw{"$_\t4"}/$meth_forw_nu{"$_\t4"};
    my $meth_rank5=$meth_forw{"$_\t5"}/$meth_forw_nu{"$_\t5"};
    print OUT "$_\t$meth_rank1\t$meth_rank2\t$meth_rank3\t$meth_rank4\t$meth_rank5\n";
}

my $end_time=localtime();
print OUT "$start_time\t$end_time\n";
close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$rank)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
        }elsif($pos1>=$stt && $pos1<=$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys.="body";
        }else{
            $keys=int(($pos1-$end)/100);
        }
    }else{
        if($pos1<$stt){
            $keys=int(($stt-$pos1)/100);
        }elsif($pos1>=$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys.="body";
        }else{
            $keys=int(($end-$pos1)/100);
        }
    }
    $meth_forw{"$keys\t$rank"}+=$methlev;
    $meth_forw_nu{"$keys\t$rank"}++;
    $flag{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE postion> <Gene Position with RPKM> <OUTPUT>
    This is to get the TE density across the gene
DIE
}
