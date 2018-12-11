#!/usr/bin/perl -w
use strict;
use warnings;
use SVG;
####read files
die("usage: perl plot.pl <gene_s> <expressBM> <expressMB> <clone> <allele> \n") unless @ARGV==5;
my ($gene_s,$expressBM,$expressMB,$clone,$allele)=@ARGV;
#open F,$gene_s or die;
#my @str;
#while(<F>){
#	my @tem=split;
#	push @str,$tem[0],$tem[1];
#}
#close F;

open F,$gene_s or die;
my %strct;
my $uni;
my $ex;
my $pr;
while(<F>){
	if(/gene/){my @tem=split;$uni=1900/($tem[4]-$tem[3]);$ex=$tem[3];$pr=$tem[4]; last;}
}
close F;

my %cln;
open CL,$clone or die;
while(<CL>){
	my @tem=split;
	push @{$cln{$tem[-1]}},($tem[0],$tem[1]);
}
close CL;

open F,$gene_s or die;
while(<F>){
	next if !/exon/;
	my @tem=split;
	if($tem[6] eq "-"){
		$tem[3]=$pr-$tem[3];
		$tem[4]=$pr-$tem[4];
	}
	else{
		$tem[3]=$tem[3]-$ex;
		$tem[4]=$tem[4]-$ex;
	}
	/Parent=(\S+);Name/;
	push @{$strct{$1}},($tem[4],$tem[3]);
}

#my @aa=keys %strct;
#print "all is @aa\n";

#my $uni=1900/$str[-1];

open F,$expressBM or die;
my %exBM;
my %exMB;
my $max=0;
while(<F>){
	my @tem=split;
#	my $va;
	$max=$tem[3] if $tem[3]>$max;
#	if($tem[3]==0){$va=500-25}
#	else{
#		$va=500-$tem[3]-25;
#		$va=100 if $va<100;
#	}
	$exBM{int($tem[1]*$uni)+150}=$tem[3];
}
close F;

open F,$expressMB or die;
while(<F>){
        my @tem=split;
#	my $va;
	$max=$tem[3] if $tem[3]>$max;
#	if($tem[3]==0){$va=525}
#	else{
#		$va=500+$tem[3]+25;
#		$va=900 if $va>900;
#	}
        $exMB{int($tem[1]*$uni)+150}=$tem[3];
}
close F;
my %snp;
open F,$allele or die;
while(<F>){
	my @tem=split;
#	print "@tem[2,3,4,5]\n";
	$snp{int($tem[1]*$uni)+150}=[$tem[2],$tem[5],$tem[3],$tem[4]];
}
close F;



#### plot y-axis
my $svg= SVG->new(width=>2100,height=>2000);
#$svg-> line('x1',0,'y1',0,'x2',0,'y2',2000,'stroke','red');
#$svg-> line('x1',0,'y1',0,'x2',2000,'y2',0,'stroke','red');
#$svg-> line('x1',2000,'y1',2000,'x2',0,'y2',2000,'stroke','red');
#$svg-> line('x1',2000,'y1',2000,'x2',2000,'y2',0,'stroke','red');
#print "3#################max is $max###############\n";
$max=10*(int($max/10)+1);
$max=400 if $max>400;

my $uni_y=400/$max;
#$uni_y=2*$uni_y if $max>800;

#print "##################now is $max#############\n";
$svg-> line('x1',120,'y1',500,'x2',120,'y2',100,'stroke','black','stroke-width',2);

$svg-> line('x1',120,'y1',500,'x2',128,'y2',500,'stroke','black','stroke-width',4);
$svg-> line('x1',120,'y1',300,'x2',128,'y2',300,'stroke','black','stroke-width',4);
$svg-> line('x1',118,'y1',400,'x2',128,'y2',400,'stroke','black','stroke-width',4);
$svg-> line('x1',118,'y1',100,'x2',128,'y2',100,'stroke','black','stroke-width',4);
$svg-> line('x1',120,'y1',200,'x2',128,'y2',200,'stroke','black','stroke-width',4);

my $tt;
$svg-> text('x',70,'y',305,style=>{'font','Arial','font-size',40})->cdata("0");
$tt=$max/2;
$svg-> text('x',60,'y',405,style=>{'font','Arial','font-size',40})->cdata("$tt");
$svg-> text('x',60,'y',505,style=>{'font','Arial','font-size',40})->cdata("$max");
$svg-> text('x',60,'y',205,style=>{'font','Arial','font-size',40})->cdata("$tt");
$svg-> text('x',60,'y',105,style=>{'font','Arial','font-size',40})->cdata("$max");






$svg-> line('x1',120,'y1',1200,'x2',120,'y2',800,'stroke','black','stroke-width',2);

$svg-> line('x1',120,'y1',1200,'x2',128,'y2',1200,'stroke','black','stroke-width',4);
$svg-> line('x1',120,'y1',1000,'x2',128,'y2',1000,'stroke','black','stroke-width',4);
$svg-> line('x1',118,'y1',1100,'x2',128,'y2',1100,'stroke','black','stroke-width',4);
$svg-> line('x1',118,'y1',800,'x2',128,'y2',800,'stroke','black','stroke-width',4);
$svg-> line('x1',120,'y1',900,'x2',128,'y2',900,'stroke','black','stroke-width',4);

#$tt;
$svg-> text('x',70,'y',1005,style=>{'font','Arial','font-size',40})->cdata("0");
#$tt=$max/2;
$svg-> text('x',60,'y',1105,style=>{'font','Arial','font-size',40})->cdata("$tt");
$svg-> text('x',60,'y',1205,style=>{'font','Arial','font-size',40})->cdata("$max");
$svg-> text('x',60,'y',905,style=>{'font','Arial','font-size',40})->cdata("$tt");
$svg-> text('x',60,'y',805,style=>{'font','Arial','font-size',40})->cdata("$max");


#### plot y-axis


#### plot gene structure

#$svg->line('x1',150,'y1',500,'x2',$uni*11200+150,'y2',500,'stroke','black','stroke-width',5);
#my $x;
#for($x=0;$x<@str-1;$x+=2){
#	$svg->rectangle(x=>$uni*$str[$x]+150,y=>475,width=>$uni*($str[$x+1]-$str[$x]),height=>50,fill=>"firebrick",'stroke','black','stroke-width',3);
#	$svg-> line('x1',$uni*$str[$x+1]+150,'y1',500,'x2',$uni*$str[$x+2]+150,'y2',500,'stroke','black') if $str[$x+2];
#}


#### plot expression level
#foreach (keys %exBM){
#	$exBM{$_}= $exBM{$_} || 0;
#	$exMB{$_}= $exMB{$_} || 0;
#	my $v1=500-$exBM{$_}*$uni_y;
#	my $v2=500+$exMB{$_}*$uni_y;
#	$v1=100 if $v1<100;
#	$v2=900 if $v2>900;
#	if($snp{$_}){
#		$v1=475-($snp{$_}->[0]+475-$snp{$_}->[2])*$uni_y;
#		$v2=525+($snp{$_}->[1]+475-$snp{$_}->[3])*$uni_y;
#	}
#	$svg-> line('x1',$_,'y1',500,'x2',$_,'y2',$v1,'stroke','LightSkyBlue');
#	$svg-> line('x1',$_,'y1',500,'x2',$_,'y2',$v2,'stroke','LightSkyBlue');
#}
#### plot methernal express

foreach (keys %snp){
	my $po=$_;
#	print "snp is @{$snp{$_}}\n";
	my $v1=300-$uni_y*$snp{$_}->[0];
	my $v3=300+$uni_y*$snp{$_}->[2];
	my $v2=1000+$uni_y*$snp{$_}->[1];
	my $v4=1000-$uni_y*$snp{$_}->[3];
#	my $bm_r=$uni_y*$snp{$_}->[0]/$uni_y*$snp{$_}->[2];
#	my $mb_r=$uni_y*$snp{$_}->[1]/$uni_y*$snp{$_}->[3];
#	my $st1=500-$bm_r*400-25;
#	my $st2=500+$mb_r*400+25;
#	$v1=475-$exBM{$_}*$uni_y if $v1<475-$exBM{$_}*$uni_y;
#	$v2=525+$exMB{$_}*$uni_y if $v2>525+$exMB{$_}*$uni_y;
#	$v3=475-$exBM{$_}*$uni_y if $v3<475-$exBM{$_}*$uni_y;
#	$v4=525+$exMB{$_}*$uni_y if $v4>525+$exMB{$_}*$uni_y;
#	print "#################33 now $v1 $v2 $v3 $v4 ###################\n";
#	$v1=100 if $v1<100;
#	$v2=900 if $v2>900;
#	$v2=1125 if $v2>1125;
	$svg-> line('x1',$po,'y1',300,'x2',$po,'y2',$v1,'stroke','OrangeRed','stroke-width',3);
#	$svg-> line('x1',$po,'y1',$v2,'x2',$po,'y2',$v4,'stroke','blue','stroke-width',3);
	$svg-> line('x1',$po,'y1',300,'x2',$po,'y2',$v3,'stroke','RoyalBlue','stroke-width',3);
#	$svg-> line('x1',$po,'y1',$v1,'x2',$po,'y2',$v3,'stroke','blue','stroke-width',3);
	$svg-> line('x1',$po,'y1',1000,'x2',$po,'y2',$v4,'stroke','OrangeRed','stroke-width',3);
	$svg-> line('x1',$po,'y1',1000,'x2',$po,'y2',$v2,'stroke','RoyalBlue','stroke-width',3);

}
my $level;
foreach my $strc(keys %strct){
	$level+=30;
	my @detal=@{$strct{$strc}};
	@detal=sort {$a<=>$b} @detal;
#	print "level is $level\n\t@detal\n";
	my $x;
	for($x=0;$x<@detal-1;$x+=2){
#		print "hahah $detal[$x]\t$detal[$x+1]\t$detal[$x+2]haha\n";
	       $svg->rectangle(x=>$uni*$detal[$x]+150,y=>1300+$level,width=>$uni*($detal[$x+1]-$detal[$x]),height=>20,fill=>"firebrick",);
	       $svg-> line('x1',$uni*$detal[$x+1]+150,'y1',1310+$level,'x2',$uni*$detal[$x+2]+150,'y2',1310+$level,'stroke','black') if $detal[$x+2];
	}
}

#foreach my $strc(keys %cln){
#	$level+=30;
#	my @detal=@{$cln{$strc}};
#	@detal=sort {$a<=>$b} @detal;
#	my $x;
#	for($x=0;$x<@detal-1;$x+=2){
#		$svg->rectangle(x=>$uni*$detal[$x]+150,y=>1300+$level,width=>$uni*($detal[$x+1]-$detal[$x]),height=>20,fill=>"black",);
#		$svg-> line('x1',$uni*$detal[$x+1]+150,'y1',1310+$level,'x2',$uni*$detal[$x+2]+150,'y2',1310+$level,'stroke','black') if $detal[$x+2];
#	}	
#}
#### done
$svg->line('x1',150,'y1',300,'x2',$uni*($pr-$ex)+150,'y2',300,'stroke','black','stroke-width',4);
$svg->line('x1',150,'y1',1000,'x2',$uni*($pr-$ex)+150,'y2',1000,'stroke','black','stroke-width',4);

print $svg->xmlify;
