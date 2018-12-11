#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl <ACGT-COUNT><GENOME>\nWe use this to profile the local effects of the bases between 7 bases,and we the results to draw a graph\n"  unless @ARGV==2;
my @cc=(0,0,0,0);
my %methy;my @contexts=("CG","CHG","CHH");
for(my $i=0;$i<7;++$i){
    foreach(@contexts){
        my $dd=$_;
        $dd.="_$i";
        $methy{$dd}=\@cc;
    }
}

open GENO,$ARGV[1] or die;
my @geno=<GENO>;
shift @geno;
my $genome=join('',@geno);
$genome=~s/\n//g;

open RES,$ARGV[0] or die;
while(my $res=<RES>){
    chomp $res;
    my ($pos,$bb,$methlev)=(split(/\s+/,$res))[1,3,4];
    my ($text,$read)=(split(/:/,$bb))[0,1];
    next if $read<10;                                             #ensure the raads nu gt 10
    my $local=substr($genome,$pos-2,7);                           
    &methy($local,$text,$methlev);             
}

my @keys=sort(keys %methy);
foreach(@keys){
    printf ("$_\t%f\t%f\t%f\t%f\t%f\n",${$methy{$_}}[0],${$methy{$_}}[1],${$methy{$_}}[2],${$methy{$_}}[3]);
}

sub methy{
    my $aa=shift;
    my $text=shift;
    my $methlev=shift;
    my @sevbase=(split('',$aa))[0,1,2,3,4,5,6];
    for(my $i=0;$i<7;++$i){
        my $text.="_$i";
        if($sevbase[$i] eq "A"){
            ${$methy{$text}}[0]+=$methlev;
        }elsif($sevbase[$i] eq "C"){
            ${$methy{$text}}[1]+=$methlev;
        }elsif($sevbase[$i] eq "G"){
            ${$methy{$text}}[2]+=$methlev;
        }else{
            ${$methy{$text}}[3]+=$methlev;
        }
    }
}
