#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($ana_reg,$dmr_reg,$ge_pos,$out)=@ARGV;
my $BIN = 60;

open POS,$ge_pos or die;
my %ana_pos;
while(my $line=<POS>){
        chomp $line;
        my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
        $chr =~ s/Chr/chr/g;
        next if $ele ne "gene";
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            $ana_pos{"$chr\t$i"} ++;
        }
}
close POS;

open ANA, $ana_reg or die "$!";
my %ana_sites;
while(<ANA>){
    chomp;
    my ($chr,$stt,$end) = split;
       $chr =~ s/Chr/chr/g; 
    for(my $i = $stt; $i < $end; ++$i){
        next if !exists $ana_pos{"$chr\t$i"};
        $ana_sites{"$chr\t$i"} ++;
    }
}
close ANA;

open DMR,$dmr_reg or die "$!";
my %dmr_sites;
while(<DMR>){
    chomp;
    my ($chr,$stt,$end) = split;
       $chr =~ s/Chr/chr/g;
    for(my $i = $stt; $i < $end; ++$i){
       next if !exists $ana_pos{"$chr\t$i"};
       $dmr_sites{"$chr\t$i"} ++;
    }
}
close DMR;

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$ge_pos or die;
my %ana_gene;
my %dmr_gene;
my $flag=1;

if($ge_pos =~ /gff$/){
    while(my $line=<POS>){
        print "$flag have been done\n" if $flag%5000==0;$flag++;
        chomp $line;
        my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
        $chr =~ s/Chr/chr/g;
        next if $ele ne "gene";
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            if(exists $ana_sites{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, "ana", $name);
            }
            if(exists $dmr_sites{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, "dmr", $name);
            }
        }
    }
}else{
    while(my $line=<POS>){
        chomp $line;
        my ($chr, $stt, $end, $name, $strand)=split(/\t/,$line);
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            if(exists $ana_sites{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, "ana", $name);
            }
            if(exists $dmr_sites{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, "dmr", $name);
            }
        }
    }
}

foreach(sort keys %ana_gene){
    my $num_ana = keys %{$ana_gene{$_}} || 0;
    my $num_dmr = keys %{$dmr_gene{$_}} || 0;
    my $perc = $num_dmr / ($num_ana + 0.0000001);
    my $key = $_;
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$num_ana\t$num_dmr\t$perc\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand, $pos1, $reg_type,$name) = @_;
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
    
    $ana_gene{$keys}->{$name} ++ if $reg_type eq "ana";
    $dmr_gene{$keys}->{$name} ++ if $reg_type eq "dmr";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <ana region> <dmr region> <gene pos> <OUTPUT>
    This is to get DMR distribution throughth imp gene
DIE
}
