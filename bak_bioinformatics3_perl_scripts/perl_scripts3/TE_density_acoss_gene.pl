#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==5;
my ($gff,$te_select,$pos,$cut,$out)=@ARGV;

open OUT,"+>$out" or die;
my %hash_selec;
$hash_selec{$te_select} = 0;

open TE,$gff or die "$!";my %hash;
while(<TE>){
    chomp;
    next if /^#/;
    next if $_ !~/$te_select/;
    my ($chrom,$stt,$end,$strand,$type)=(split(/\t/,$_));
    my $pos=int (($end+$stt)/2);
    $hash{"$chrom\t$pos"}++;
}

open POS,$pos or die;
my %prom_density;my %body_density;my %terminal_density;my $flag=1;
my ($promot_len,$down_len,$body_len)=(0,0,0);
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand)=split(/\s+/,$line);
    next if $line !~ /^\d/;
    $promot_len += 2000;
    $down_len += 2000;
    $body_len += $end-$stt+1;
    foreach(my $i=$stt-1999;$i<=$end+1999;++$i){
        if(exists $hash{"$chr\t$i"}){
            print "$line\n";
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"});
        }
    }
}
%hash=();

foreach(sort{$a<=>$b}keys %prom_density){
    my $nomal_dens= $prom_density{$_}*1000000*100/$promot_len;
    print OUT "$_\t$nomal_dens\n";
}
foreach(sort{$a<=>$b}keys %body_density){
    my $nomal_dens= $body_density{$_}*1000000*$cut/$body_len;
    print OUT "$_\t$nomal_dens\n";
}
foreach(sort{$a<=>$b}keys %terminal_density){
    my $nomal_dens= $terminal_density{$_}*1000000*100/$down_len;
    print OUT "$_\t$nomal_dens\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev)=@_;
    my $unit=($end-$stt)/$cut;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $prom_density{$keys}++;
        }elsif($pos1>=$stt && $pos1<=$end){
            $keys=int (($pos1-$stt)/$unit);
            $body_density{$keys}++;
        }else{
            $keys=int(($pos1-$end)/100);
            $terminal_density{$keys}++;
        }
    }else{
        if($pos1<$stt){
            $keys=int(($stt-$pos1)/100);
            $terminal_density{$keys}++;
        }elsif($pos1>=$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $body_density{$keys}++;
        }else{
            $keys=int(($end-$pos1)/100);
            $prom_density{$keys}++;
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE GFF file> <TE selected> <Gene position> <Bin number> <OUTPUT>
    This is to get the methylation distribution throughth gene or TEs
DIE
}
