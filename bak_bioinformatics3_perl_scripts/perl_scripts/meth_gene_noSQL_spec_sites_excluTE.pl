#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;
my ($forw,$rev,$ge_pos,$sites, $te_asso,$out)=@ARGV;

open TE,$te_asso or die "$!";
my %te_asso;
while(<TE>){
    chomp;
    #1       2123    2608    Ty1/copia       .       -1      -1      .       -1      0
    my ($chr,$stt,$end,$type,$chr2) = split;
    next if $chr2 eq ".";
    $chr = "chr".$chr if $chr !~/chr/;
    for(my $i = $stt;$i<=$end;++$i){
        $te_asso{"$chr\t$i"} ++;
    }
}

open SIT,$sites or die "$!";
my %sites;
while(<SIT>){
    chomp;
    my ($chr,$pos) = split;
    $sites{"$chr\t$pos"} ++;
}

my %meth_pos;
open FOR,$forw or die "$!";
while(<FOR>){
    chomp;
    my ($chrom,$pos1,$pos2,$depth,$lev) = split;
    next if !exists $sites{"$chrom\t$pos1"};
    next if $depth <5;
    my $c_num = int ($depth*$lev/100 + 0.5);
    my $t_num = $depth - $c_num;
    next if exists $te_asso{"$chrom\t$pos1"};
    @{$meth_pos{"$chrom\t$pos1"}} = ($c_num, $t_num);
}
print "$forw: Done\n";
open REV,$rev or die "$!";
while(<REV>){
    chomp;
    my ($chrom,$pos1,$pos2,$depth,$lev) = split;
    next if !exists $sites{"$chrom\t$pos1"};
    next if $depth <5;
    my $c_num = int ($depth*$lev/100 + 0.5);
    my $t_num = $depth - $c_num;
    next if exists $te_asso{"$chrom\t$pos1"};
    @{$meth_pos{"$chrom\t$pos1"}} = ($c_num, $t_num);
}

print "$rev: Done\n";

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$ge_pos or die;
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;

if($ge_pos =~ /gff$/){
    while(my $line=<POS>){
        print "$flag have been done\n" if $flag%5000==0;$flag++;
        chomp $line;
        my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
        next if $ele ne "gene";
        $chr="chr".$chr;
        for(my $i = $stt - 1999;$i <= $end+1999;++$i){
            if(exists $meth_pos{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, @{$meth_pos{"$chr\t$i"}});
            }
        }
    }
}else{
    while(my $line=<POS>){
        chomp $line;
        my ($chr, $stt, $end, $name, $strand)=split(/\t/,$line);
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i <= $end+1999;++$i){
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
    my $unit=($end-$stt+1)/99.99;
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
    perl *.pl <Forword> <Reverse> <Gene position GFF> <Identical sites> <TE asso FGS> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
