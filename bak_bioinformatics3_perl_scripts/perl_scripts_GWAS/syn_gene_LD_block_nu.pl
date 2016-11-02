#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($bed_res) = @ARGV;
my $LDB = "LD_BLOCK_NUMBER";
my $LDB_LEN = "LD_BLOCK_LENGTH";
my $POS = "POS";
open RES,$bed_res or die "$!";
my %hash_gene;
while(<RES>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$chrom,$stt1,$end1,$block_nu) = split;
    if($chrom eq '.'){
        $hash_gene{$gene}->{"$LDB"} = 0;
        $hash_gene{$gene}->{"$LDB_LEN"} = 0;
        $hash_gene{$gene}->{"$POS"} = "$stt\t$end";
    }else{
        $hash_gene{$gene}->{"$LDB"} ++;
        $hash_gene{$gene}->{"$LDB_LEN"} = $end1 - $stt1 + 1;;
 	$hash_gene{$gene}->{"$POS"} = "$stt\t$end";
    }
}

foreach(keys %hash_gene){
    my $block_nu = $hash_gene{$_}->{"$LDB"};
    my $block_len = $hash_gene{$_}->{"$LDB_LEN"};
    my $pos = $hash_gene{$_}->{"$POS"};
    next if $block_len > 15460000;
    print "$_\t$pos\t$block_nu\t$block_len\n";
}

sub usage{
    print <<DIE;
    perl *.pl <BED intersect res> 
DIE
    exit 1;
}
