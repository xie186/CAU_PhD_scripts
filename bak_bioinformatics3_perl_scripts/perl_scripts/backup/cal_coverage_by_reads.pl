#!/usr/bin/perl -w
use strict;
my $die=<<DIE;
  perl *.pl <Reads> <OUT_put>
  We use this to cal bps of bases which we have sequenced.
DIE
die "$die" if @ARGV==0;
my $out=pop @ARGV;
die "$out exists!!\n" if -e $out;
open OUT, "+>$out";
my $lenTotal;
foreach(@ARGV){
    $lenTotal=1;
    open TRIM,$_ or die "$!";
    while(my $fir=<TRIM>){
        my $sec=<TRIM>;
        chomp $sec;
    #    my ($seq)=split(/\s+/,$_);
        $lenTotal+=length($sec);
        my $third=<TRIM>;
        my $forth=<TRIM>;
    }
    close TRIM;
    
    my $bps=$lenTotal/1000000000/2.33;
    print OUT "$_\t$bps\n";
}

close OUT;
