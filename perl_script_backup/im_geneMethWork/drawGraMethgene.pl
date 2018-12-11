#!/usr/bin/perl -w
use strict;
use SVG;
die "Usage:perl *.pl <GeneList><GeneStructure><BratResults>>\n" unless @ARGV==3;
my ($gene_list,$gene_s,$meth)=@ARGV;
#my %strct;
open LIST,$gene_list or die "$!";
while(my $gene=<LIST>){
    print "Here we go!\n";
    chomp $gene;
    my @geneinfo=split(/\s+/,$gene);
    open STRU,$gene_s or die;
    my @genostru=<STRU>;
    close STRU;
    my @gestr=grep{/$geneinfo[0]/}@genostru;

    my %strct;
    my $uni;
    my $ex;
    my $pr;
    my @str;
    if(@gestr){
        foreach(@gestr){
            if (/gene/){
                my @tem=split;  $uni=3000/($tem[4]-$tem[3]);  $ex=$tem[3];$pr=$tem[4]; last;
            }
        }
        close STRU;
    #get the gene structure information
    # open F,$gene_s or die;
        foreach(@gestr){
           next if !/exon/;
           my @tem=split;
           if($tem[6]!~/-/){
              my $stt4=$tem[3]-$geneinfo[2]+3000;
              my $len4=$tem[4]-$tem[3];
              push @str,$stt4,$len4;
           }else{
              my $stt5=$geneinfo[3]+3000-$tem[4];
              my $len5=$tem[4]-$tem[3];
              push @str,$stt5,$len5;
           }
        }
    }else{
        $uni=3000/($geneinfo[3]-$geneinfo[2]);
        push @str,$geneinfo[2],$geneinfo[3];
    }

    #get meth information
    open OUT,"";
    my @methinfo;
    my @mapdep;
    my ($maxMeth,$maxdep)=(0,0);
    open METH,$meth or die "$!";
    while(my $me=<METH>){
       chomp $me;
       my @methlation=split(/\s+/,$me);
       $methlation[0]=~s/chr//;
       if($methlation[0] == $geneinfo[1] && $methlation[1]>=$geneinfo[2]-3000 && $methlation[1]<=$geneinfo[2]+3000){
           $maxMeth=$methlation[4] if $methlation[4]> $maxMeth;
           push @methinfo,$methlation[1]-$geneinfo[2]-3000,$methlation[4];
           my $depth=(split(/:/,$methlation[3]))[1];
           push @mapdep,$methlation[1]-$geneinfo[2]-3000,$depth;
           print "$methlation[1]-$geneinfo[2]-3000\t$methlation[4]\t$methlation[1]-$geneinfo[2]-3000\t$depth\n";
           $maxdep=$depth if $depth>$maxdep;  
       }elsif($methlation[0] == $geneinfo[1] && $methlation[1]>=$geneinfo[2]+3000){
           last;
       }else{
           next;
       }
    }
    close METH;
    my $i=0;$i++;
    print "$i\n";
    #print "$ex\t$pr\n";
    my $gra=SVG->new(width=>6000,height=>2500);
    my ($uni_met,$uni_dep)=(0,0);
    $uni_met=800/1 if($maxMeth != 0);
    $uni_dep=800/$maxdep if ($maxdep != 0);
    
    ################################################################################
    #draw gene structure
    $gra->line('x1',200,'y1',1000,'x2',200,'y2',200,'stroke','black','stroke-width',8);
    $gra->line('x1',200,'y1',1000,'x2',210,'y2',1000,'stroke','black','stroke-width',8);
    $gra->line('x1',200,'y1',600,'x2',210,'y2',600,'stroke','black','stroke-width',8);
    $gra->line('x1',200,'y1',200,'x2',210,'y2',200,'stroke','black','stroke-width',8);
    $gra-> text('x',120,'y',1000,style=>{'font','Arial','font-size',50})->cdata("0");
    $gra-> text('x',120,'y',600,style=>{'font','Arial','font-size',50})->cdata("0.5");
    $gra-> text('x',120,'y',200,style=>{'font','Arial','font-size',50})->cdata("1");
    #biaochi
    $gra->line('x1',4500,'y1',200,'x2',4000+($uni*1000),'y2',200,'stroke','black','stroke-width',8);
    $gra->text('x',(4500+($uni*1000)/2)-10,'y',250,style=>{'font','Arial','font-size',50})->cdata("1k");
    my $x;
    for($x=0;$x<@str-1;$x+=2){
        $gra->rect(x=>$uni*$str[$x]+200,y=>1025,width=>$uni*$str[$x+1],height=>50,fill=>"firebrick",'stroke','black','stroke-width',8);
    }
                                                                                                                                         
    for($x=0;$x<@str-1;$x+=2){
        $gra->line('x1',$methinfo[$x]*$uni+200,'y1',1000,'x2',$methinfo[$x]*$uni+200,'y2',1000-$methinfo[$x+1]*$uni_met,'stroke','red','stroke-width',2);
        $gra->line('x1',$mapdep[$x]*$uni+200,'y1',1150,'x2',$mapdep[$x]*$uni+200,'y2',1150+$mapdep[$x+1]*$uni_dep,'stroke','blue','stroke-width',2);
    }

    #open OUT,"+>$geneinfo[0].svg";
    #print OUT $gra->xmlify();
    close OUT;
}
