#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;

my ($bed_OTOB,$ge_pos,$sites1,$sites2,$out)=@ARGV;
my $BIN = 60;
open SIT,$sites2 or die "$!";
my %sites2;
while(<SIT>){
    chomp;
    my ($chr,$pos) = split;
    $sites2{"$chr\t$pos"} ++;
}
close SIT;

open SIT,$sites1 or die "$!";
my %sites;
while(<SIT>){
    chomp;
    my ($chr,$pos) = split;
    $sites{"$chr\t$pos"} ++ if exists $sites2{"$chr\t$pos"};
}

my %meth_pos;
open FOR,$bed_OTOB or die "$!";
while(<FOR>){
    chomp;
    my ($chrom,$pos1,$c_num,$t_num) = split;
    next if !exists $sites{"$chrom\t$pos1"};
    next if $c_num + $t_num <5;
    @{$meth_pos{"$chrom\t$pos1"}} = ($c_num, $t_num);
}
print "$bed_OTOB: Done\n";

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$ge_pos or die;
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    next if $line =~ /^#/;
    my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
    next if $chr =~ /UNKNOWN/;
    $chr="chr".$chr;
    my $report = 0;
    for(my $i = $stt - 1999;$i <= $end+1999;++$i){
        if(exists $meth_pos{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i, @{$meth_pos{"$chr\t$i"}});
            ++ $report;
        }
    }
    print "$name\n" if $report > 1;
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
    my $unit=($end-$stt+1)/($BIN-0.01);
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt+1)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt+1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end+1)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1+1)/100);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1+1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1+1)/100);
            $keys="prom\t$keys";
        }
    }
    ${$meth_forw{$keys}}[0] += $c_num;
    ${$meth_forw{$keys}}[1] += $t_num;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <BED OTOB> <repeat GFF> <Identical sites> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
