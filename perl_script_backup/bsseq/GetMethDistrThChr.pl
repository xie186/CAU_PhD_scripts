#!/usr/bin/perl -w
use strict;
use SVG;
die "Usage:perl *.pl <GENOME><Positive_str><Negative_str>.\nWe use this to get the info of genome-wide distribution of methylation.\nThis script can also be used to get the info of distribution through genome in each context,we can just take some little modifications.\n" unless @ARGV==3;
my ($geno,$forw,$rev)=@ARGV;
open GENO,$geno or die;
my $genome;
while(<GENO>){
    next if />/;
    chomp;
     $genome.=$_;
}
close GENO;
my $genolen=length($genome);              #Calulate the genome length
my $devi=int ($genolen/100000);
my $resi=$genolen/100000;
if($resi==0){
    $devi=int ($genolen/100000);
}else{
    $devi=int ($genolen/100000)+1;
}
my @formet;my @fwcount; my @revmet;my @revcount;
for(my $i=0;$i<$devi;++$i){
    $formet[$i]=0;
    $fwcount[$i]=1;
    $revmet[$i]=0;
    $revcount[$i]=1;
}
open FORW,$forw or die;
while(my $fw=<FORW>){
    chomp $fw;
    #next if ($fw=~/CHG/ || $fw=~/CG/);                 #this is used when just want get the CG methy info
    my ($pos,$conread,$lev)=(split(/\s+/,$fw))[1,3,4];
    my ($conxt,$read)=(split(/:/,$conread))[0,1];
    next if $read<10;
    for(my $i=0;$i<$devi;++$i){
        if($pos>=100000*$i && $pos<100000*($i+1)){
            $formet[$i]+=$lev;
            $fwcount[$i]++;
        }
    }
}
close FORW;
open REV,$rev or die;
while(my $rev=<REV>){
    chomp $rev;
    # next if ($rev=~/CHG/ || $rev=~/CG/);
    my ($pos,$conread,$lev)=(split(/\s+/,$rev))[1,3,4];
    my ($conxt,$read)=(split(/:/,$conread))[0,1];
    next if $read<10;
    for(my $i=0;$i<$devi;++$i){
        if($pos>=100000*$i && $pos<100000*($i+1)){
            $revmet[$i]+=$lev;
            $revcount[$i]++;
        }
    }
}
close REV;
my @xcoor;
for(my $j=0;$j<$devi;++$j){
    $formet[$j]=$formet[$j]/$fwcount[$j];
    $revmet[$j]=0-$revmet[$j]/$revcount[$j];
    $xcoor[$j]=$j;
    printf( "%.3f\t%.3f\n",$formet[$j],$revmet[$j]);
}

# Draw the polyline
my $gra=SVG->new(width=>6000,height=>3000);
my $xv=\@formet;my $yv=\@xcoor;
my $points=$gra->get_path(
    x=>$xv,y=>$yv,
    -type=>'polyline',
    -closed=>'true'     #specify that the polyline is closed
);
my $tag=$gra->polyline(
    %$points,
    id=>'pline_1',
    style=>{
        'fill-opacity'=>0,
        'stroke-color'=>'rgb(250,123,23)'
    }
);

#print $gra->xmlify();
