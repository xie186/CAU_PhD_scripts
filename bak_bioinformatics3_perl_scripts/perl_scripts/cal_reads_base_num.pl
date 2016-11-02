#!/usr/bin/perl -w

my @aa=@ARGV;
die usage() if @ARGV==0;
foreach(@aa){
    chomp;
    open FILE,$_ or die "$!";
    $base_nu=0;
    while(my $fir=<FILE>){
        my $sec=<FILE>;
        my $thi=<FILE>;
        my $qua=<FILE>;
        chomp $sec;
        my $len=length $sec;
        $base_nu+=$len;
    }

    print "$_\t$base_nu\n";
}

sub usage{
    my $die=<<DIE;

    perl *.pl <*fq INT> 
    
DIE
}
