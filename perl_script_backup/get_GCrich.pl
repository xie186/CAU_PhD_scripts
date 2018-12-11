#!/usr/bin/perl -w
#use strict;
open NEISEQ,$ARGV[0] or die;

while (my $neinm=<NEISEQ>){
    my $seq=<NEISEQ>;
    chomp $neinm;
    chomp $seq;
#    print "$neinm\n";
    my @neiseq=split(//,$seq);
#    print @neiseq; 
    for(my $i=0;$i<=@neiseq-13;++$i){
        my %hash=('A'=>0,
                  'C'=>0,
                  'G'=>0,
                  'T'=>0);
#        print "$hash{'A'}\n";
        my @windows;
        for (my $j=0;$j<=13;++$j){
            push (@windows,$neiseq[$i+$j]);
        }
        my $base=0;
        foreach $base(@windows){
            next if $base=~/N/;
            $hash{$base}++; 
        }
        if ($hash{'G'}+$hash{'C'}+$hash{'A'}+$hash{'T'}==0){
            next;
        }elsif(($hash{'G'}+$hash{'C'})/($hash{'G'}+$hash{'C'}+$hash{'A'}+$hash{'T'})>=0.9){
            my $gc=join('',@windows);
            my $rela_pos=$i+1;
            print "$neinm\t$rela_pos\t$gc\n";
        }else{
            next;
        }
    } 
}
