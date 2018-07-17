#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($input, $out) = @ARGV;
open IN, $input or die "$!";
my %func_class;
while(<IN>){
    chomp;
    #chr5    11718856        11718856        chr5    11711929        11723225        TE      0
    #chr5    11723283        11723283        .       -1      -1              .       0
    my ($chr,$stt,$end,$chr2,$stt2,$end2, $class) = split;
    $func_class{"$chr\t$stt"} .= "\t$class";
}
close IN;

my %stat_class = (
"CDS" => 0,
"UTR" => 0,
"Intron" => 0,
"Upstream" => 0,
"Downstream" => 0,
"TE" => 0,
"IG" => 0
);

open OUT, "+>$out" or die "$!";
foreach(keys %func_class){
    #coding>  intronic>  untranslated regions > non-coding >  pseudogene > mobile element > intergenic
    my $class = "IG";
    if($func_class{$_} =~ /CDS/){
        $class = "CDS";
    }elsif($func_class{$_} =~ /Intron/){
        $class = "Intron";
    }elsif($func_class{$_} =~ /UTR/){
        $class = "UTR";
    }elsif($func_class{$_} =~ /Upstream/){
        $class = "Upstream";
    }elsif($func_class{$_} =~ /Downstream/){
        $class = "Downstream";
    }elsif($func_class{$_} =~ /TE/){
        $class = "TE";
    }else{
        $class = "IG"
    }
    print  OUT "$_\t$class\n";
    $stat_class{"$class"} ++;
}

foreach(sort keys %stat_class){
    print "$_\t$stat_class{$_}\n";
}

sub usage{
    my $die =<<DIE;
perl *.pl <Input> <OUT> 
DIE
}
