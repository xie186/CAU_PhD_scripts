#!/usr/bin/perl -w
use strict;
use SVG;
die usage() unless @ARGV==3;
my ($cgi,$pos,$imp)=@ARGV;
open CGI,$cgi or die "$!";
my %cgi;my %cgi_len;
while(<CGI>){
    chomp;
    my ($chr,$stt,$end,$oe)=(split(/\s+/,$_))[0,1,2,5];
    my $pos=int (($end+$stt)/2);
    next if $oe<0.1;
    $cgi{"$chr\t$pos"}="CGI";
    $cgi_len{"$chr\t$pos"}=$end-$stt;
}

my %ge_hash;
open IMP,$imp or die "$!";
while(<IMP>){
    chomp;
    my ($ge1,$ge2)=split(/\s+/,$_);
    $ge_hash{$ge1}++;
#    $ge_hash{$ge2}=$ge1;
}
open POS,$pos or die "$!";
while(<POS>){
    chomp; 
    my ($chr,$stt,$end,$gene,$strand)=split;
    $chr="chr".$chr;
    if(exists $ge_hash{$gene}){
           print "$gene exists!!!\n";
          &draw($chr,$stt,$end,$gene,$strand);
        
    }
}

sub draw{
    my ($chr,$stt,$end,$gene,$strand)=@_;
    my $flank=4000;
    print "$chr,$stt,$end,$gene,$strand\n";
    open FF,"+>$gene.CGI.imp.svg" or die "$!";
    my $gra=SVG->new(width=>4500,height=>1000);
    my ($init,$uni_x)=(200,4000/($end-$stt+4000));

    $gra->line('x1',$init,'y1',500,'x2',$init+4000,'y2',500,'stroke','black','stroke-width',4);
    $gra->line('x1',$init+$flank*$uni_x,'y1',500,'x2',$init+$flank*$uni_x,'y2',200,'stroke','black','stroke-width',4);
    $gra->line('x1',$init+4000-$flank*$uni_x,'y1',500,'x2',$init+4000-$flank*$uni_x,'y2',200,'stroke','black','stroke-width',4);
    my $flag=0;
    for(my $i=$stt-$flank;$i<=$end+$flank;++$i){
        if(exists $cgi{"$chr\t$i"}){
             print "FOR recycle!!!$chr,$stt,$end,$gene,$strand\n";
             my $add=20;
             $flag++;
             if($strand eq '+'){
                 $gra->rect(x=>200+($i-$stt+$flank)*$uni_x,y=>485,width=>$uni_x*$cgi_len{"$chr\t$i"},height=>30,fill=>"firebrick",'stroke','black','stroke-width',3);
                 $gra->text('x',200+($i-$stt+$flank)*$uni_x,'y',600+$add,style=>{'font','Arial','font-size',78})->cdata("$cgi{\"$chr\t$i\"}");
             }else{
                  $gra->rect(x=>200+($end+$flank-$i)*$uni_x,y=>485,width=>$uni_x*$cgi_len{"$chr\t$i"},height=>30,fill=>"firebrick",'stroke','black','stroke-width',3);
                  $gra->text('x',200+($end+$flank-$i)*$uni_x,'y',600+$add,style=>{'font','Arial','font-size',78})->cdata("$cgi{\"$chr\t$i\"}");
             }
        }
    }
    print FF $gra->xmlify();
    close FF;
}
sub usage{
    my $die=<<DIE;
    perl *.pl <CGI position> <Gene pos> <imp duplication>
DIE
}
