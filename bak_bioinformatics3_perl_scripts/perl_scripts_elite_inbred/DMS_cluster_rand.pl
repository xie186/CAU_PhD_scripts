#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($qval,$rand_num, $win_cut, $out_dir) = @ARGV;

open DMS,$qval or die "$!";
my $dms_num = 0;
my @dms_pos;
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval) = split;
    $dms_num ++ if $qval < 0.01;
    push @dms_pos, "$chr\t$stt\t$end";
}

`mkdir $out_dir` if !-e "$out_dir";
my $max = @dms_pos;
for(my $i = 1; $i <= $rand_num; ++ $i){
    open OUT, "+>./$out_dir/$out_dir\_rand$i" or die "$!";
    for(my $j =0; $j < $dms_num; ++$j ){
        my $rand_index = int(rand($max));
        print OUT "$dms_pos[$rand_index]\n";
    }
    close OUT;
    system qq(sort -k1,1 -k2,2n ./$out_dir/$out_dir\_rand$i | mergeBed -d $win_cut -n -i - > ./$out_dir/$out_dir\_rand$i.res &);
}

sub usage{
    my $die =<<DIE;
    perl *.pl <qvalue results> <rand number> <out_directory>
DIE
}
