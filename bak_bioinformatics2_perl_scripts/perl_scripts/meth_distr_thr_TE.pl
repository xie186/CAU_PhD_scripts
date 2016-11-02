#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==3;
my ($gff,$pos,$out)=@ARGV;

open OUT,"+>$out" or die;
my $start_time=localtime();

open FORW,$gff or die "$!";my %hash;
while(<FORW>){
    chomp;
    my ($chrom,$stt,$end,$strands)=(split(/\t/,$_))[0,1,2,-1];
    my $pos=int ($end+$stt)/2;
    $hash{"$chrom\t$pos"}++;
    print "$chrom\t$pos\n";
}

open POS,$pos or die;
my %te_density;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand)=split(/\s+/,$line);
    $chr=$chr;
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"});
        }
    }
}
%hash=();

foreach(sort keys %te_density){
#    my $meth_forwprint=$meth_forw{$_}/$meth_forw_nu{$_};
    print OUT "$_\t$te_density{$_}\n";
}

my $end_time=localtime();
print OUT "$start_time\t$end_time\n";
close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$methlev)=@_;
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
    $te_density{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE GFF file> <Gene position> <OUTPUT>
    This is to get the methylation distribution throughth gene or TEs
DIE
}
