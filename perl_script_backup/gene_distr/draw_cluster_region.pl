#!/usr/bin/perl -w
use strict;
use SVG;

die "perl *.pl <Region_stt><Region_end><CRET1><CRET5><CpG density>" unless @ARGV==5;
my ($stt,$end,$cret1,$cret4,$cg)=@ARGV;
my $gra=SVG->new(width=>5000,height=>2000);
my $unix=4400/($end-$stt);
#$gra->line('x1',200,'y1',1000,'x2',4600,'y2',1000,'stroke','black','stroke-width',5);
$gra->rect(x=>200,y=>800,width=>$unix*($end-$stt),height=>400,fill=>"#FFE6D5",'stroke','#FFE6D5','stroke',3);
$gra->line('x1',200,'y1',800,'x2',4600,'y2',800,fill=>"#71C837",'stroke','#71C837','stroke-width',3);
$gra->text(x=>200,y=>780,style=>{'front','Arial','font-size',65})->cdata("criteria 1:MEG");
$gra->line('x1',200,'y1',900,'x2',4600,'y2',900,fill=>"#71C837",'stroke','#71C837','stroke-width',3);
$gra->text(x=>200,y=>880,style=>{'front','Arial','font-size',65})->cdata("criteria 1:PEG");
$gra->line('x1',200,'y1',1000,'x2',4600,'y2',1000,fill=>"#71C837",'stroke','#71C837','stroke-width',3);
$gra->text(x=>200,y=>980,style=>{'front','Arial','font-size',65})->cdata("Non-imp in both criteria");
$gra->line('x1',200,'y1',1100,'x2',4600,'y2',1100,fill=>"#71C837",'stroke','#71C837','stroke-width',3);
$gra->text(x=>200,y=>1080,style=>{'front','Arial','font-size',65})->cdata("criteria 2:MEG");
$gra->line('x1',200,'y1',1200,'x2',4600,'y2',1200,fill=>"#71C837",'stroke','#71C837','stroke-width',3);
$gra->text(x=>200,y=>1180,style=>{'front','Arial','font-size',65})->cdata("criteria 2:PEG");
open CRET1,$cret1 or die;
while(<CRET1>){
    chomp;
    my @aa=split;
    my $cret1_stt=$aa[1];
    my $cret1_end=$aa[2];
    my $x_axis=$cret1_stt-$stt;
    if($_=~/mat/ && $_!~/pat/){
         $gra->circle(cx=>$unix*$x_axis+200,cy=>800,r=>10,fill=>"OrangeRed");
    }elsif($_=~/pat/ && $_!~/mat/){
         $gra->circle(cx=>$unix*$x_axis+200,cy=>900,r=>13,fill=>"#008080");
    }else{
         $gra->circle(cx=>$unix*$x_axis+200,cy=>1000,r=>10,fill=>"black");
    }
}
close CRET1;
open CRET5,$cret4 or die;
while(<CRET5>){
    chomp;
    my ($im_stt,$im_end,$im)=(split)[2,3,4];
    if($im eq "mat"){
        $gra->circle(cx=>$unix*($im_stt-$stt)+200,cy=>1100,r=>10,fill=>"red");
    }else{
        &draw($im_stt,$im_end,$im,$_);
    }
}
close CRET5;

open CG,$cg or die;
while(<CG>){
    chomp;
    my ($pos,$lev)=split;
    $gra->line('x1',($pos-$stt)*$unix+200,'y1',1900,'x2',($pos-$stt)*$unix+200,'y2',1900-(700*$lev),'stroke','lightblue','stroke-width',5);
}

sub draw{
    my ($im_stt,$im_end,$im,$lfile)=@_;
    if($lfile=~/^PTU/){
        $gra->circle(cx=>$unix*($im_stt-$stt)+200,cy=>1200,r=>10,fill=>"purple");
    }else{
        $gra->circle(cx=>$unix*($im_stt-$stt)+200,cy=>1200,r=>10,fill=>"blue");
    }
}

print $gra->xmlify();
