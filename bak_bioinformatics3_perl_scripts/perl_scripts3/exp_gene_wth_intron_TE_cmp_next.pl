#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($te_or)=@ARGV;
open TE,$te_or or die "$!";
my @aa=<TE>;
for(my $i=0;$i<@aa-1;++$i){
    my ($chr,$ele,$stt,$end,$strand,$name,$inser)=split(/\t/,$aa[$i]);
    next if $ele !~/intron/;
    if($inser =~ "TE"){
        $aa[$i-1] =~ s/UNK/TE/;
        $aa[$i+1] =~ s/UNK/TE/;
    }
}

foreach(my $i=0;$i<@aa-1;++$i){
    print "$aa[$i]";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <> 
DIE
}
