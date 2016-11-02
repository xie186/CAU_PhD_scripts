#!/usr/bin/perl -w
use strict;
use SVG;

die "Usage:perl *.pl <gene_stru> <express_BM> <express_MB> <SNP>\n" unless @ARGV==4;

my ($gene_s,$expressBM,$expressMB,$ale)=@ARGV;
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
my %exBM;my %exMB;my $max=0;
while(<BM>){
    my @tem1=split;
    $max=$tem1[3] if $tem1[3]>$max;
    $exBM{int($tem1[1]*$uni)+150}=$tem1[3];
}
close BM;
open MB,$expressMB or die;
while(<MB>){
    my @tem2=split;
    $max=$tem2[3] if $tem2[3]>$max;
    $exMB{int($tem2[1]*$uni)+150}=$tem2[3];
}
close MB;
my %snp;
open SNP,$ale or die;
while(<SNP>){
    my @tem3=split;
    $snp{int($tem3[1]*$uni)+150}=[$tem3[2],$tem3[3],$tem3[4],$tem3[5]];
}
close MB;
#draw the up coordinate
my $gra=SVG->new(width=>5000,height=>2000);
$max=10*(int($max/10));
# $max=400 if $max>400;
my $uni_y=1000/$max;
$gra->line('x1',120,'y1',500,'x2',120,'y2',100,'stroke','black','stroke-width',5);
#$gra->line('x1',120,'y1',500,'x2',128,'y2',500,'stroke','black','stroke-width',5);
$gra->line('x1',120,'y1',300,'x2',128,'y2',300,'stroke','black','stroke-width',5);
#$gra->line('x1',118,'y1',400,'x2',128,'y2',400,'stroke','black','stroke-width',5);
$gra->line('x1',118,'y1',100,'x2',128,'y2',100,'stroke','black','stroke-width',5);
#$gra->line('x1',120,'y1',200,'x2',128,'y2',200,'stroke','black','stroke-width',5);

my $tt;my $end=2*$max;
$gra-> text('x',70,'y',305,style=>{'font','Arial','font-size',40})->cdata("");
$tt=$max/2;
#$gra-> text('x',60,'y',405,style=>{'font','Arial','font-size',40})->cdata("$tt");
$gra-> text('x',60,'y',505,style=>{'font','Arial','font-size',40})->cdata("0");
#$gra-> text('x',60,'y',205,style=>{'font','Arial','font-size',40})->cdata("$tt");
$gra-> text('x',58,'y',105,style=>{'font','Arial','font-size',40})->cdata("$end");
$gra-> text('x',58,'y',305,style=>{'font','Arial','font-size',40})->cdata("$max");
#drw the down coordinates
$gra->line('x1',120,'y1',1000,'x2',120,'y2',600,'stroke','black','stroke-width',5);
$gra-> text('x',60,'y',605,style=>{'font','Arial','font-size',40})->cdata("0");
$gra-> text('x',55,'y',805,style=>{'font','Arial','font-size',40})->cdata("$max");
$gra-> text('x',55,'y',1005,style=>{'font','Arial','font-size',40})->cdata("$end");
#draw the gene structure
$gra->line('x1',150,'y1',550,'x2',$uni*($pr-$ex)+150,'y2',550,'stroke','black','stroke-width',4);
foreach(keys %exBM){
    my $exp_BM=500-($uni_y*$exBM{$_})/1;
    $gra->line('x1',$_,'y1',500,'x2',$_,'y2',$exp_BM,'stroke','LightSkyBlue','stroke-width',5);
}
foreach(keys %exMB){
    my $exp_MB=600+($uni_y*$exMB{$_})/1;
    $gra->line('x1',$_,'y1',600,'x2',$_,'y2',$exp_MB,'stroke','LightSkyBlue','stroke-width',5);
}
#draw the snp
foreach(keys %snp){
    my $po=$_;
    my $v1=500-($uni_y*$snp{$_}->[0])/1;
    my $v2=$v1+($uni_y*$snp{$_}->[1])/1;
    my $v3=600+($uni_y*$snp{$_}->[2])/1;
    my $v4=$v3+($uni_y*$snp{$_}->[3])/1;
    $gra->line('x1',$po,'y1',500,'x2',$po,'y2',$v1,'stroke','OrangeRed','stroke-width',5); 
    $gra->line('x1',$po,'y1',$v1,'x2',$po,'y2',$v2 ,'stroke','RoyalBlue','stroke-width',5);
    $gra->line('x1',$po,'y1',600,'x2',$po,'y2',$v3,'stroke','OrangeRed','stroke-width',5);
    $gra->line('x1',$po,'y1',$v3,'x2',$po,'y2',$v4,'stroke','RoyalBlue','stroke-width',5);
}

#draw gene structure
open F,$gene_s or die;
my @str;
while(<F>){
       next if !/exon/;
       my @tem=split;
        $tem[3]=$pr-$tem[3];
        $tem[4]=$pr-$tem[4];
       push @str,$tem[3],$tem[4];
}
close F;
my $x;
for($x=0;$x<@str-1;$x+=2){
       $gra->rectangle(x=>$uni*$str[$x]+150,y=>525,width=>$uni*($str[$x+1]-$str[$x]),height=>50,fill=>"firebrick",'stroke','black','stroke-width',3);
       $gra-> line('x1',$uni*$str[$x+1]+150,'y1',500,'x2',$uni*$str[$x+2]+150,'y2',500,'stroke','black') if $str[$x+2];
}

#draw transcripts splicing 
open STRU,$gene_s or die; 
my @t1;my @t2;
while(<STRU>){
   next if !/exon/;
   my @tem=split;
   if($tem[6] eq "-"){
       $tem[3]=$pr-$tem[3];
       $tem[4]=$pr-$tem[4];
   }else{
       $tem[3]=$tem[3]-$ex;
       $tem[4]=$tem[4]-$ex;
   }
#  print "GRMZM2G062650_T01\t$tem[4]\t$tem[3]\n";   
   push @t1,($tem[4],$tem[3]) if /_T01/;
   push @t2,($tem[4],$tem[3]) if /_T02/;
 #  print "GRMZM2G062650_T01\t$tem[4]\t$tem[3]\n";
   
}
my $level=0;  $gra->line('x1',150,'y1',1325+$level,'x2',$uni*($pr-$ex)+150,'y2',1325+$level,'stroke','black','stroke-width',4);
for (my $x=0;$x<@t1-1;$x+=2){
    $gra->rectangle(x=>$uni*$t1[$x]+150,y=>1300+$level,width=>$uni*($t1[$x+1]-$t1[$x]),height=>50,fill=>"firebrick",'stroke','black','stroke-width',3);
}
$level=60;   $gra->line('x1',150,'y1',1325+$level,'x2',$uni*($pr-$ex)+150,'y2',1325+$level,'stroke','black','stroke-width',4);
for (my $x=0;$x<@t1-1;$x+=2){
    $gra->rectangle(x=>$uni*$t2[$x]+150,y=>1300+$level,width=>$uni*($t2[$x+1]-$t2[$x]),height=>50,fill=>"firebrick",'stroke','black','stroke-width',3);
 #   $gra-> line('x1',$uni*$t2[$x+1]+150,'y1',1325+$level,'x2',$uni*$t2[$x+2]+150,'y2',1325+$level,'stroke','black','stroke-width',5) if $t2[$x+2];
}

print $gra->xmlify();
