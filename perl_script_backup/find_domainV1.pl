#!/usr/bin/perl -w
use strict;
my $die=<<EOF;
perl *.pl <HAMMER_file><domain>
EOF
die "$die" unless @ARGV==2;
my ($ham,$dom)=@ARGV;
open HAM, $ham;
my $ll=join'',<HAM>;
close HAM;
my @aa=split/Query sequence\:/,$ll;
splice(@aa,0,1);

foreach(@aa){
    my @sing=split(/\n/,$_);
    for(my $j=0;$j<@sing;++$j){
        if($sing[$j]=~/Alignments of top-scoring domains:/){
             splice(@sing,$j);
             last;
        }
    }
     
    foreach my $i(@sing){
         my @domain=split(/\s+/,$i);
         if(@domain==10 && $domain[7]=~/[\.\[][\.\]]/ && $domain[8]>0 && $i=~/$dom/i){
             $sing[0]=~s/\s//;
             print "$sing[0]\t$i\n";
         }
    }
  
    
}
