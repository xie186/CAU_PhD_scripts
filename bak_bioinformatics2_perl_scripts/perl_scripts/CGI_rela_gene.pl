#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==4;
my ($cgi,$pos,$rela,$nore)=@ARGV;
open CGI,$cgi or die "$!";my %hash;
while(<CGI>){
    chomp;
    my ($chrom,$stt,$end,$strands)=(split(/\t/,$_))[0,1,2];
    my $pos=int (($end+$stt)/2);
    $hash{"$chrom\t$pos"}=$end-$stt+1;
}
open OUT1,"+>$rela" or die;
open OUT2,"+>$nore" or die;
open POS,$pos or die;
my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand)=split(/\s+/,$line);
    $chr="chr".$chr;
    my $report=0;
    foreach(my $i=$stt-1999;$i<=$end+1999;++$i){
        if(exists $hash{"$chr\t$i"}){
            $report++;
            print OUT1 "$line\t$hash{\"$chr\t$i\"}\n";
        }
    }
    print OUT2 "$line\n" if $report==0;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CGI position> <Gene position> >>OUTPUT
DIE
}
