#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($dup_sd,$fc)=@ARGV;
open SD,$dup_sd or die "$!";
my %hash_gt;
while(<SD>){
    chomp;
    my ($id_block,$id,$gene1,$rpkm1,$gene2,$rpkm2)=split;
    next if ($rpkm1==0 && $rpkm2==0);
    my ($tem1,$tem2)=sort{$a<=>$b}($rpkm1,$rpkm2);
#    next if $tem2/($tem1+0.0000001)<$fc;
    if($tem2/($tem1+0.0000001) > $fc && $tem2 >=1){
       print "$_\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Duplicated gene with RPKM> <FC>
DIE
}
