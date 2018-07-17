#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;

sub usage{
    my $die = <<DIE;
pelr $0 <sample list> <fasta> <tree>  
DIE
}
my ($sam_list, $in, $tree) = @ARGV;

open SAM, $sam_list or die "$!";
my %rec_acc; 
while(<SAM>){
    chomp;
    my ($acc, $clade) = split(/,/, $_);
    $clade =~ s/\s+/_/g;
    $clade =~ s/\(|\)//g;
    print "xxx\t$clade\n" if $clade =~ /\(|\)/;
    $rec_acc{$acc} = $clade;
}

$/ = "\n>";
open IN, $in or die "$!";
my $num = 0;
my %rec_num;
my %avoid_duplicate;
while(<IN>){
    $_ =~ s/>//g;
    my ($id, $seq) = split(/\n/, $_, 2);
    ($id, my $spec) = split(/\s+/, $id);
    $seq =~ s/\n//g;
    my $tem_id = sprintf("%08d", $num);
    $num ++;
    if(/^AT\d+G/){
        $id =~ s/\(|\)//g; #/AT1G(PYR1)/
        $rec_num{$tem_id} = "$id";
    }else{
        my ($acc) = split(/-/,$id);
        if(length $acc != 4){
            $spec =~ s/\(|\)//g;   #/AT1G(PYR1)/
            $rec_num{$tem_id} = "$id-$spec";
        }else{
            my $clade = $rec_acc{$acc};
            #print "xx$acc\n" if !$clade;
            $rec_num{$tem_id} = "$id-$clade";
        }
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
