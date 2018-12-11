#!/usr/bin/perl -w
use strict;
open TRFK,$ARGV[0] or die;  #open the file which holds the genes in 50k windows
while (<TRFK>){
    chomp $_;
    my @tra_50k=(split(/\s+/,$_));
    shift @tra_50k;
    shift @tra_50k;
    shift @tra_50k;
    shift @tra_50k;
    my $tra_name=shift @tra_50k;
    $tra_name=~s/>//;
    print "$tra_name\n";
#    print "$tra_name\n";
    my @traninfo=split(/_/,$tra_name);
    my $len=@tra_50k;
    if($len==0){
        open IESFK,"+>>pa$tra_name" or die;
        print IESFK "$tra_name\t$traninfo[2]\t$traninfo[3]\n";
        close IESFK;
    }else{
        open IESFK,"+>>pa$tra_name" or die;
        print IESFK "$tra_name\t$traninfo[2]\t$traninfo[3]\n";
        for(my $i=0;$i<$len;$i+=5){
        print IESFK "$tra_50k[$i+3]\t$tra_50k[$i+1]\t$tra_50k[$i+2]\n";
        }
        close IESFK;
    }
     
}
