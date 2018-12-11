#!/usr/bin/perl -w
use strict;
die "perl *.pl <TRAPOS><PILEUP>" unless @ARGV==2;
open NEI,$ARGV[0] or die;
#open PILEUP,$ARGV[1] or die;

my $pa1;
my $pa2;
my $pil;
#my @trinfo;
while($pa1=<NEI>){
    my $pa2=<NEI>;
    chomp $pa1;
    chomp $pa2;
    my @pair1=(split(/\s+/,$pa1));
    my @pair2=(split(/\s+/,$pa2));
#    print "$pair1[0]\n";
#    print $name;
#    unshift(@trinfo,"");
    open PILEUP,$ARGV[1] or die;
    while ($pil=<PILEUP>){
        chomp $pil;
        my($pilchr,$pilpos,$read_nu)=(split(/\s+/,$pil))[0,1,3];
        my ($chr1)=(split(/hr/,$pilchr))[1];
 #       print "$chr1";
        if($chr1 != $pair1[0]){
            next;
        }elsif($pilpos>=$pair1[1]-10000&& $pilpos<=$pair2[2]+10000){
#           unshift(@trinfo,"IESMA");
            open OUT,"+>>neiborMB_$pair1[3]" or die;
            print OUT "$pilchr\t$pilpos\t$read_nu\n";
#            print "$pil\n";
            close OUT;   
        }else{
            next;
        }
    }
    close PILEUP;
}

close NEI;

