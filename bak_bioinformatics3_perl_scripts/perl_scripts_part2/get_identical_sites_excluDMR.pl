#!/usr/bin/perl -w
use strict;
die usage() if @ARGV == 0;
my ($sam_num, $dmr, @file)=@ARGV;

my $meth_file_num = @file;
if($sam_num != $meth_file_num){
    die "sample number was wrong!\n";
}

open DMR,$dmr or die "$!";
my %exclu_site;
while(<DMR>){
    chomp;
    my ($chr,$stt,$end) = split;
    for(my $i = $stt;$i <=$end;++$i){
        $exclu_site{"$chr\t$i"} ++;
    }
}

my %meth_pos;
foreach my $file(@file){
    open FOR,$file or die "$!";
    while(<FOR>){
        chomp;
        my ($chrom,$pos1,$pos2,$depth,$lev) = split;
        next if ($depth <5 || exists $exclu_site{"$chrom\t$pos1"});
        push @{$meth_pos{"$chrom\t$pos1"}}, $lev;
    }
}

for(my $i =0; $i < @file;++$i){
    if($file[$i]=~/BSR/){
        ($file[$i]) = $file[$i] =~ /(BSR\d+)/;
    }elsif($file[$i]=~/hybrid/){
        ($file[$i]) = $file[$i] =~ /hybrid_([mp]aternal)/;
    }else{
       
    }
}
my $header = join("\t",@file);
print "chr\tpos\t$header\n";
foreach (keys %meth_pos){
    if(@{$meth_pos{$_}} == $sam_num){
        my $tem_lev = join("\t",@{$meth_pos{$_}});
        print "$_\t$tem_lev\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <sample number> <DMR region> <file [N]>
    This is to get the methylation distribution throughth gene
DIE
}
