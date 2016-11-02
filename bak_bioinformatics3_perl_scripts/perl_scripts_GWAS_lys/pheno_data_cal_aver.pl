#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($input) = @ARGV;
open IN,$input or die "$!";
my $header = <IN>;
my @line = <IN>;
my $line = join("",@line);
   @line = split(/block/,$line);
my $aa = shift @line;
chomp $header;
print "$header\tnumber_of_measure\ttotal\n";
foreach(@line){
    my @tem_line = split(/\n/,$_);
    my $block_num = shift @tem_line;
    my %lys_content;
    foreach my $tem_line (@tem_line){
        my ($inbred,$content) = split(/\t/,$tem_line);
           ($inbred) = split(/-/,$inbred);
           push @{$lys_content{$inbred}} , $content;
    }

    foreach my $inbred (sort keys %lys_content){
        my $num =  @{$lys_content{$inbred}};
        my $sum = &sum(@{$lys_content{$inbred}});
        my $aver = $sum/$num;
        print "$inbred\t$aver\t$num\t$sum\n";
    }
}

sub sum{
    my @value = @_;
    my $sum = 0;
    foreach my $value (@value){
        $sum += $value;
    }
    return $sum;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <input> 
DIE
}
