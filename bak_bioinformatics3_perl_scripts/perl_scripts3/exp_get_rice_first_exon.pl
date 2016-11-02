#!/usr/bin/perl -w
use strict;
my ($gff)=@ARGV;
die usage() unless @ARGV==1;

open GFF,$gff or die "$!";
my @all=<GFF>;
my $join=join('',@all);
   @all=split(/###\n/,$join);

foreach(@all){
    my @tem=split(/\n/,$_);
    my @cds;
    my ($name,$strand,$tss,$tts)=(0,0);
    foreach my $line(@tem){
        next if $line =~ /^#/;
        $line =~ s/Chr/chr/g;
        my ($chr,$spec,$ele,$stt,$end,$fie1,$tem_strd,$fei2,$id)=split(/\t/,$line);
        $strand = $tem_strd;
        if($ele eq "CDS"){
            push @cds,$line;
        }elsif($ele eq "mRNA"){
             ($name)=(split(/=/,$id))[-1];
             ($tss,$tts) = ($stt,$end);
             print "$chr\t-\t$ele\t$stt\t$end\t-\t$tem_strd\t-\t$name\n";
             &up_down($chr,$stt,$end,$strand,$name);
        }
    }
   
    if(@cds == 1){
        my ($chr,$spec,$ele,$stt,$end,$fie1,$tem_strd,$fei2,$id)=split(/\t/,$cds[0]);
        print "$chr\t-\tsingle_exon\t$tss\t$tts\t-\t$tem_strd\t-\t$name\n";
    }elsif(@cds == 2){
        my ($chr1,$spec1,$ele1,$stt1,$end1,$fie11,$tem_strd1,$fei21,$id1)=split(/\t/,$cds[0]);
        my ($chr2,$spec2,$ele2,$stt2,$end2,$fie12,$tem_strd2,$fei22,$id2)=split(/\t/,$cds[1]);
        if($strand eq "+"){
            my ($intron_stt,$intron_end) = ($end1+1,$stt2-1);
            print "$chr1\t-\tfirst_exon\t$tss\t$end1\t-\t$tem_strd1\t-\t$name\n";
            print "$chr1\t-\tsingle_intron\t$intron_stt\t$intron_end\t-\t$tem_strd1\t-\t$name\n";
            print "$chr1\t-\tlast_exon\t$stt2\t$tts\t-\t$tem_strd2\t-\t$name\n";
        }else{
            my ($intron_stt,$intron_end) = ($end2+1,$stt1-1);
            print "$chr1\t-\tlast_exon\t$tss\t$end1\t-\t$tem_strd1\t-\t$name\n";
            print "$chr1\t-\tsingle_intron\t$intron_stt\t$intron_end\t-\t$tem_strd1\t-\t$name\n";
            print "$chr1\t-\tfirst_exon\t$stt2\t$tts\t-\t$tem_strd2\t-\t$name\n";
        }
    }elsif(@cds > 2 ){
        if($strand eq "+"){
            my $intron_report=0;
            for(my $i=0;$i<@cds;++$i){
                if($i == 0){
                     my ($chr,$spec,$ele,$stt,$end,$fie1,$tem_strd,$fei2,$id)=split(/\t/,$cds[$i]);
                     print "$chr\t-\tfirst_exon\t$tss\t$end\t-\t$tem_strd\t-\t$name\n";
                }elsif($i > 0 && $i <= @cds-1){
                     my ($chr1,$spec1,$ele1,$stt1,$end1,$fie11,$tem_strd1,$fei21,$id1)=split(/\t/,$cds[$i-1]);
                     my ($chr2,$spec2,$ele2,$stt2,$end2,$fie12,$tem_strd2,$fei22,$id2)=split(/\t/,$cds[$i]);
                     my $intron_stt=$end1+1;
                     my $intron_end=$stt2-1;
                     if($intron_report == 0){
                     print "$chr1\t-\tfirst_intron\t$intron_stt\t$intron_end\t-\t$strand\t-\t$name\n";
                     }else{
                         print "$chr1\t-\tinternal_intron\t$intron_stt\t$intron_end\t-\t$strand\t-\t$name\n";
                     }
                     ++$intron_report;
                     if($i < @cds-1){
                         print "$chr2\t-\tinternal_exon\t$stt2\t$end2\t-\t$strand\t-\t$name\n";
                     }else{
                         print "$chr2\t-\tlast_exon\t$stt2\t$end2\t-\t$strand\t-\t$name\n";
                     }
                }else{
                }
            }
        }else{
            my $intron_report=0;
            for(my $i = 0;$i < @cds;++$i){
                if($i == 0){
                     my ($chr,$spec,$ele,$stt,$end,$fie1,$tem_strd,$fei2,$id)=split(/\t/,$cds[$i]);
                     print "$chr\t-\tfirst_exon\t$stt\t$tts\t-\t$tem_strd\t-\t$name\n";
                }elsif($i > 0 && $i <= @cds-1){
                     my ($chr1,$spec1,$ele1,$stt1,$end1,$fie11,$tem_strd1,$fei21,$id1)=split(/\t/,$cds[$i-1]);
                     my ($chr2,$spec2,$ele2,$stt2,$end2,$fie12,$tem_strd2,$fei22,$id2)=split(/\t/,$cds[$i]);
                     my $intron_stt=$end2+1;
                     my $intron_end=$stt1-1;
                     if($intron_report == 0){
                         print "$chr1\t-\tfirst_intron\t$intron_stt\t$intron_end\t-\t$strand\t-\t$name\n";
                     }else{
                         print "$chr1\t-\tinternal_intron\t$intron_stt\t$intron_end\t-\t$strand\t-\t$name\n";
                     }
                     ++$intron_report;
                     if($i < @cds-1){
                         print "$chr2\t-\tinternal_exon\t$stt2\t$end2\t-\t$strand\t-\t$name\n";
                     }else{
                         print "$chr2\t-\tlast_exon\t$stt2\t$end2\t-\t$strand\t-\t$name\n";
                     }
                }else{

                }
            } 
        }
    }
}

sub up_down{
    my ($chr,$stt,$end,$strand,$name)=@_;
    if($strand eq "+"){
        my ($up_stt,$up_end)=($stt-2000,$stt-1);
        my ($down_stt,$down_end)=($end+1,$end+2000);
        $chr =~s/Chr/chr/;
        print "$chr\t-\tupstream\t$up_stt\t$up_end\t-\t$strand\t-\t$name\n";
        print "$chr\t-\tdownstream\t$down_stt\t$down_end\t-\t$strand\t-\t$name\n";
    }else{
        my ($down_stt,$down_end)=($stt-2000,$stt-1);
        my ($up_stt,$up_end)=($end+1,$end+2000);
        $chr =~s/Chr/chr/;
        print "$chr\t-\tupstream\t$up_stt\t$up_end\t-\t$strand\t-\t$name\n";
        print "$chr\t-\tdownstream\t$down_stt\t$down_end\t-\t$strand\t-\t$name\n";
    }
}
sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <GFF>
DIE
}
