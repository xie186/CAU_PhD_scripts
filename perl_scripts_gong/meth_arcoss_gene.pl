#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($bed_OT, $bed_OB, $ge_pos, $out)=@ARGV;
my $BIN = 60;

my %meth_pos;
$bed_OT = "zcat $bed_OT|" if $bed_OT =~ /gz$/;
open BED,$bed_OT or die "$!";
while(<BED>){
    chomp;
    my ($chrom,$pos1,$pos2, $depth, $lev) = split;
        $chrom =~ s/Chr/chr/g;
    next if ($depth < 4 || $depth > 100);
    my $c_num = int ($depth*$lev/100 + 0.5);
    my $t_num = $depth - $c_num;
    @{$meth_pos{"$chrom\t$pos1"}} = ($c_num, $t_num);
}
close BED;
print "Reading $bed_OT: Done\n";

$bed_OB = "zcat $bed_OB|" if $bed_OB =~ /gz$/;
open BED,$bed_OB or die "$!";
while(<BED>){
    chomp;
    my ($chrom,$pos1,$pos2, $depth, $lev) = split;
        $chrom =~ s/Chr/chr/g;
    next if ($depth < 4 || $depth > 100);
    my $c_num = int ($depth*$lev/100 + 0.5);
    my $t_num = $depth - $c_num;
    @{$meth_pos{"$chrom\t$pos1"}} = ($c_num, $t_num);
}
close BED;
print "Reading $bed_OB: Done\n";

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$ge_pos or die "$!";
my %meth_forw;
my $flag=1;

if($ge_pos =~ /gff$/){
    while(my $line=<POS>){
        print "$flag have been done\n" if $flag%5000==0;$flag++;
        chomp $line;
        my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
        $chr =~ s/Chr/chr/g;
        next if $ele ne "gene";
        $chr="chr".$chr if $chr !~ /chr/;
        my $report = 0;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            if(exists $meth_pos{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, @{$meth_pos{"$chr\t$i"}});
                ++ $report;
            }
        }
        print "$name\n" if $report > 0;
    }
}else{
    while(my $line=<POS>){
        chomp $line;
        my ($chr, $stt, $end, $name, $strand)=split(/\t/,$line);
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            if(exists $meth_pos{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, @{$meth_pos{"$chr\t$i"}});
            }
        }
    }
}

foreach(sort keys %meth_forw){
    my $meth_forwprint = ${$meth_forw{$_}}[0] / (${$meth_forw{$_}}[0] + ${$meth_forw{$_}}[1]);
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_forwprint\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$c_num,$t_num) = @_;
    my $unit=($end-$stt+1)/($BIN - 0.01);
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt+1)/$unit);
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
            $keys=int (($end-$pos1+1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    
    ${$meth_forw{$keys}}[0] += $c_num;
    ${$meth_forw{$keys}}[1] += $t_num;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <bed OT> <bed OB> <Gene position GFF> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
