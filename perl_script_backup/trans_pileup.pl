#!/usr/bin/perl -w
use strict;
die "perl *.pl <TRAPOS><PILEUP>" unless @ARGV==2;
open TRAPOS,$ARGV[0] or die;
#open PILEUP,$ARGV[1] or die;

my $trapos;
my $pil;
#my @trinfo;
while($trapos=<TRAPOS>){
    my $seq=<TRAPOS>;
    print $trapos;
    chomp $trapos;
    my @trinfo=(split(/_/,$trapos))[1,2,3];
#    print $name;
    unshift(@trinfo,"IESmaBMfilter");
    open PILEUP,$ARGV[1] or die;
    while ($pil=<PILEUP>){
        chomp $pil;
        my($pilchr,$pilpos,$read_nu)=(split(/\s+/,$pil))[0,1,3];
        if($pilchr ne $trinfo[1]){
            next;
        }elsif($pilpos>=$trinfo[2]&& $pilpos<=$trinfo[3]){
#           unshift(@trinfo,"IESMA");
            my $name=join ('_',@trinfo);
            open OUT,"+>>$name" or die;
            print OUT "$pilchr\t$pilpos\t$read_nu\n";
#            print "$pil\n";
            close OUT;   
        }else{
            next;
        }
    }
    close PILEUP;
}

close TRAPOS;

