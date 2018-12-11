#!/usr/bin/perl -w 
use strict;
die "Usage:perl *.pl<IM><FW>" unless @ARGV==2;
open IM,$ARGV[0] or die; #IM for imprinting genes
open FW,$ARGV[1] or die; #FW for 50k_windows
my %impt;
while(<IM>){
    chomp $_;
    my ($im_nm)=(split(/\s+/,$_))[0];
    $impt{$im_nm}="IM imprint";
}

while(<FW>){
    chomp $_;
    my @luan=split;
    my $im_mark;
    my $im_count=0;
    for(my $i=0;$i<@luan;++$i){
        my $lu=$luan[$i];
#        my $im_count;
        if(exists($impt{$lu})){
            $luan[$i]="*$luan[$i]";
            $im_count++;
        }
    }
    unshift(@luan,$im_count);
    unshift(@luan,"IM_nu");
    $im_mark=join("\t",@luan);
    print "$im_mark\n";
}
