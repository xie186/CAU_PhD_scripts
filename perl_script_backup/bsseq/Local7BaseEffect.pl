#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl <ACGT-COUNT><GENOME>\nWe use this to profile the local effects of the bases between 7 bases,and we the results to draw a graph\n"  unless @ARGV==2;
my %methy;my @contexts=("CG","CHG","CHH");
for(my $i=0;$i<7;++$i){
    foreach(@contexts){
        my $dd=$_;
        $dd.="_$i";
        $methy{$dd}=[0,0,0,0];
    }
}
my @rr=sort(keys %methy);
foreach(@rr){
 #   print "$_\t${$methy{$_}}[0]\t${$methy{$_}}[1]\t${$methy{$_}}[2]\t${$methy{$_}}[3]\n";
 #    print "$_\n";
}
open GENO,$ARGV[1] or die;
my @geno=<GENO>;
shift @geno;
my $genome=join('',@geno);
$genome=~s/\n//g;
my ($cg_count,$chg_count,$chh_count);
open RES,$ARGV[0] or die;
while(my $res=<RES>){
    chomp $res;
    my ($pos,$bb,$methlev)=(split(/\s+/,$res))[1,3,4];
    my ($text,$read)=(split(/:/,$bb))[0,1];
#    print "$text\n";
    next if $read<10;                                             #ensure the raads nu gt 10
    my $local=substr($genome,$pos-2,7);                           
    &methy($local,$text,$methlev);             
}

my @keys=sort(keys %methy);
foreach(@keys){
    my $context_count=&context_judge($_);
    printf "%s\t%f\t%f\t%f\t%f\n",$_,${$methy{$_}}[0]/$context_count,${$methy{$_}}[1]/$context_count,${$methy{$_}}[2]/$context_count,${$methy{$_}}[3]/$context_count;
}
sub methy{
    my $local  =shift;
    my $text   =shift;
    my $methlev=shift;
    $cg_count++ if $text eq "CG";
    $chg_count++ if $text eq "CHG";
    $chh_count++ if $text eq "CHH";
    my @sevbase=(split('',$local));
    for(my $i=0;$i<7;++$i){
        my $text1=$text."_$i";
        if($sevbase[$i] eq "A"){
           # ${$methy{$text1}}[0]+=$methlev;
             ${$methy{$text1}}[0]++;
        }elsif($sevbase[$i] eq "C"){
           # ${$methy{$text1}}[1]+=$methlev;
             ${$methy{$text1}}[1]++;
        }elsif($sevbase[$i] eq "G"){
          #  ${$methy{$text1}}[2]+=$methlev;
             ${$methy{$text1}}[2]++;
        }else{
          #  ${$methy{$text1}}[3]+=$methlev;
             ${$methy{$text1}}[3]++;
        }
    }
}

sub context_judge{
    shift;
    return $cg_count if /CG/;
    return $chg_count if /CHG/;
    return $chh_count if /CHH/;
}
