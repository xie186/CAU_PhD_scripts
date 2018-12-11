#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl<geneposition><transcripts><genome>" unless @ARGV==3;
open TRANS,$ARGV[1] or die;
while(my $tran=<TRANS>){
    chomp $tran;
    my ($chr1,$stt1,$end1)=(split(/_/,$tran))[1,2,3];
    my $nm=join('_',($chr1,$stt1,$end1));
 
#    print "$nm\n";
    my ($ch)=(split(/hr/,$chr1))[1];
    my $transeq=<TRANS>;
    open GENPOS,$ARGV[0] or die;
    while (my $gepos=<GENPOS>){
        next if $gepos=~/^UNKNOWN/;
        chomp $gepos;
        my($chr2,$stt2,$end2,$gene_nm)=(split(/\s+/,$gepos))[0,1,2,3];
 #       print $chr2;
        if($ch ne $chr2){
 #           print "$ch\t$chr2\n";
            next;
        }elsif($stt2>=$stt1-50000 && $end2<=$end1+50000){
     
      #      open OUT,"+>>pa_$nm\_50kgene";
      #      print OUT "$gepos";
      #      close OUT;
     
            open GENOME,$ARGV[2];
            while(my $chr3=<GENOME>){
                my $seq=<GENOME>;
                chomp $chr3;
                my ($chr_genome)=(split(/hr/,$chr3))[1];
                if($chr_genome != $ch){
                    next;
                }else{
                    my $subseq=substr($seq,$stt2-1,$end2-$stt2+1);
           #         open OUT,"+>>pa_$nm\_50kgeneseq";
           #         print "ma_$nm\_50kgeneseq\n";
                    print "\>$gene_nm\n$subseq\n";
          #          close OUT;
                }
            }
      }else{
           next;    
      }

    }
}

