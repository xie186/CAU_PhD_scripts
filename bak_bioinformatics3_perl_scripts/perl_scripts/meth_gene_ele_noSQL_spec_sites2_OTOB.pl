#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;
my ($bed_OTOB,$ge_pos,$sites1,$sites2,$out)=@ARGV;

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

if($ge_pos =~ /gff$/){
    while(my $line=<POS>){
        print "$flag have been done\n" if $flag%5000==0;$flag++;
        chomp $line;
        my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
        next if $ele eq "gene";
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt;$i <= $end;++$i){
            if(exists $meth_pos{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, @{$meth_pos{"$chr\t$i"}},$ele);
            }
        }
    }
}else{
#    while(my $line=<POS>){
#        chomp $line;
#        my ($chr, $stt, $end, $name, $strand)=split(/\t/,$line);
#        $chr="chr".$chr if $chr !~ /chr/;
#        for(my $i = $stt - 1999;$i <= $end+1999;++$i){
#            if(exists $meth_pos{"$chr\t$i"}){
#                &cal($stt,$end,$strand,$i, @{$meth_pos{"$chr\t$i"}});
#            }
#        }
#    }
}

foreach(sort keys %meth_forw){
    my $meth_forwprint = 0;
    for(my $i =0;$i<=49;++$i){
        if(exists $meth_forw{$_}->{$i}){
            $meth_forwprint = ${$meth_forw{$_}->{$i}}[0]  / (${$meth_forw{$_}->{$i}}[0] + ${$meth_forw{$_}->{$i}}[1]);
        }
        print OUT "$_\t$i\t$meth_forwprint\n";
    }
}
close OUT;


sub cal{
    my ($stt,$end,$strand,$pos1,$c_num,$t_num,$ele)=@_;
    my $unit=($end-$stt+1)/50;
    my $keys=0;
    if($strand eq '+'){
        $keys=int (($pos1-$stt+1)/$unit);
    }else{
        $keys=int (($end-$pos1+1)/$unit);
    }
    $keys-=1 if $keys == 50;
    ${$meth_forw{$ele}->{$keys}}[0] += $c_num;
    ${$meth_forw{$ele}->{$keys}}[1] += $t_num;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <bed OTOB> <Gene position GFF> <Identical sites> <Identical sites2> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
