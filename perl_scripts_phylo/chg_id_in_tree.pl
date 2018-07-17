#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;

sub usage{
    my $die = <<DIE;
pelr $0 <fasta> <tree>  
DIE
}
my ($in, $tree) = @ARGV;

$/ = "\n>";
open IN, $in or die "$!";
my $num = 0;
my %rec_num;
while(<IN>){
    $_ =~ s/>//g;
    my ($id, $seq) = split(/\n/, $_, 2);
    ($id, my $spec) = split(/\s+/, $id);
    $seq =~ s/\n//g;
    my $tem_id = sprintf("%08d", $num);
    $num ++;
    if(/^AT\d+G/){
        $rec_num{$tem_id} = "$id";
    }else{
        $rec_num{$tem_id} = "$id--$spec";
    }
}
$/ = "\n";

open TREE, $tree or die "$!";
my @tree = <TREE>;
my $tree_info = join("", @tree);
foreach(keys %rec_num){
    $tree_info =~ s/$_\:/$rec_num{$_}:/;
}
print "$tree_info";
