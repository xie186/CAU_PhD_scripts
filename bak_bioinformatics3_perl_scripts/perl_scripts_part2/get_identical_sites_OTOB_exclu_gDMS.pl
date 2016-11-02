#!/usr/bin/perl -w
use strict;
die usage() if @ARGV == 0;
my ($sam_num,@file)=@ARGV;
my $inclu_sites = shift @file;
open INCLU,$inclu_sites or die "$!";
my %inclu_sites;
while(<INCLU>){
    chomp;
    my ($chr,$pos) = split; 
    $inclu_sites{"$chr\t$pos"} ++;
}
my $meth_file_num = @file;
if($sam_num != $meth_file_num){
    die "sample number was wrong!\n";
}

my %meth_pos;
foreach my $file(@file){
    open FOR,$file or die "$!";
    while(<FOR>){
        chomp;
        my ($chrom,$pos1,$c_num,$t_bum) = split;
        next if $c_num + $t_bum <5;
        my $lev = $c_num/($c_num + $t_bum);
        push @{$meth_pos{"$chrom\t$pos1"}}, $lev if exists $inclu_sites{"$chrom\t$pos1"};
    }
}

foreach (keys %meth_pos){
    if(@{$meth_pos{$_}} == $sam_num){
        my $tem_lev = join("\t",@{$meth_pos{$_}});
        print "$_\t$tem_lev\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <sample number> <include sites> <file [N]>
    This is to get the methylation distribution throughth gene
DIE
}
