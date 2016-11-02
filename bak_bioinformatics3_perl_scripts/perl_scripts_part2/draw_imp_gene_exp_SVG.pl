#!/usr/bin/perl -w
use strict;
use SVG;
die "Usage:perl *.pl <gene_stru><express_BM><express_MB><SNP>\n" unless @ARGV==4;
my ($gene_s,$expressBM,$expressMB,$snp_ale)=@ARGV;
open STRU,$gene_s or die;
my %strct;
my $uni;
my $ex;
my $pr;
while(<STRU>){
    if (/gene/){
        my @tem=split;  $uni=3900/($tem[4]-$tem[3]);  $ex=$tem[3];$pr=$tem[4]; last;
    }
}
close STRU;

open BM,$expressBM or die;
my %exBM;my %exMB;
my $max1 = 0;
my $max2 = 0;
while(<BM>){
    my @tem1=split;
    $max1 = $tem1[3] if $tem1[3] > $max1;
    $exBM{int($tem1[1]*$uni)+200}=$tem1[3];
}
close BM;

open MB,$expressMB or die;
while(<MB>){
    my @tem2=split;
    $max2 = $tem2[3] if $tem2[3] > $max2;
    $exMB{int($tem2[1]*$uni)+200}=$tem2[3];
}
close MB;

#bm expression 
open SNP,$snp_ale;
my %snp;
while(<SNP>){
    chomp;
    my @tem3=split;
    $snp{int($tem3[1]*$uni)+200}=[$tem3[2],$tem3[3],$tem3[4],$tem3[5]]; 
}

open F,$gene_s or die;
my @str;
while(<F>){
       next if !/exon/;
       my @tem=split;
       if($tem[6]!~/-/){
          my $stt4=$tem[3]-$ex;
          my $len4=$tem[4]-$tem[3];
          push @str,$stt4,$len4;
       }else{
          my $stt5=$pr-$tem[4];
          my $len5=$tem[4]-$tem[3];
          push @str,$stt5,$len5;
       }
}
close F;
#print "@str\n";
my $gra=SVG->new(width=>5000,height=>2000);
#$max1  = 10*(int($max1/10));
#$max2  = 10*(int($max2/10));
# $max=400 if $max>400;
my $uni_y1 = 800/$max1 if $max1 != 0;
my $uni_y2 = 800/$max2 if $max2 != 0;

#   $uni_y=0 if $max == 0;
################################################################################
#draw gene structure
#my $mid=$max/2;
$gra->line('x1',200,'y1',1000,'x2',200,'y2',200,'stroke','black','stroke-width',2);
$gra->line('x1',200,'y1',1000,'x2',210,'y2',1000,'stroke','black','stroke-width',2);
$gra->line('x1',200,'y1',600,'x2',210,'y2',600,'stroke','black','stroke-width',2);
$gra->line('x1',200,'y1',200,'x2',210,'y2',200,'stroke','black','stroke-width',2);
$gra-> text('x',100,'y',1000,style=>{'font','Arial','font-size',50})->cdata("0");
$gra-> text('x',100,'y',600,style=>{'font','Arial','font-size',50})->cdata("50%");
$gra-> text('x',100,'y',200,style=>{'font','Arial','font-size',50})->cdata("100%");

$gra->line('x1',200,'y1',1100,'x2',200,'y2',1900,'stroke','black','stroke-width',2);
$gra->line('x1',200,'y1',1100,'x2',210,'y2',1100,'stroke','black','stroke-width',2);
$gra->line('x1',200,'y1',1500,'x2',210,'y2',1500,'stroke','black','stroke-width',2);
$gra->line('x1',200,'y1',1900,'x2',210,'y2',1900,'stroke','black','stroke-width',2);
$gra-> text('x',100,'y',1100,style=>{'font','Arial','font-size',50})->cdata("0");
$gra-> text('x',100,'y',1500,style=>{'font','Arial','font-size',50})->cdata("50%");
$gra-> text('x',100,'y',1900,style=>{'font','Arial','font-size',50})->cdata("100%");



my $x;
for($x=0;$x<@str-1;$x+=2){
    $gra->rectangle(x=>$uni*$str[$x]+200,y=>1025,width=>$uni*$str[$x+1],height=>50,fill=>"firebrick",'stroke','black','stroke-width',3);
}

foreach(keys %exBM){
    my $v1=1000-$exBM{$_}*$uni_y1;
    $gra->line('x1',$_,'y1',1000,'x2',$_,'y2',$v1,'stroke','LightSkyBlue');
}
foreach(keys %exMB){
    my $v1=1100+$exMB{$_}*$uni_y2;
    $gra->line('x1',$_,'y1',1100,'x2',$_,'y2',$v1,'stroke','LightSkyBlue');
}
foreach(keys %snp){
    my $v1=1000-$uni_y1*$snp{$_}->[0];
    my $v2=$v1-$uni_y1*$snp{$_}->[1];
    my $v3=1100+$uni_y2*$snp{$_}->[3];
    my $v4=$v3+$uni_y2*$snp{$_}->[2];
    $gra->line('x1',$_,'y1',1000,'x2',$_,'y2',$v1,'stroke','OrangeRed','stroke-width',5);
    $gra->line('x1',$_,'y1',$v1,'x2',$_,'y2',$v2 ,'stroke','RoyalBlue','stroke-width',5);
    $gra->line('x1',$_,'y1',1100,'x2',$_,'y2',$v3,'stroke','OrangeRed','stroke-width',5);
    $gra->line('x1',$_,'y1',$v3,'x2',$_,'y2',$v4,'stroke','RoyalBlue','stroke-width',5);
}

print $gra->xmlify();
