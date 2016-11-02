#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;

my ($ge_pos)=@ARGV;
open POS,$ge_pos or die "$!";
my @aa;my %rpkm;
while(<POS>){
    chomp;
    my ($chr,$stt1,$end1,$name,$strand,$type,$rpkm)=(split);
    next if $rpkm <0.1;
    push (@aa,$rpkm) if !exists $rpkm{$name};
    $rpkm{$name}=$rpkm;
}
close POS;

my $for_r=join(',',@aa);
open OUT,"+>quantile.R" or die "$!";
print OUT "cc<-c($for_r)\nquantile(cc,probs=seq(0,1,0.01))";
my $quantile = `R --vanilla --slave <quantile.R`;
   $quantile =~ s/\d+%//g;
   $quantile =~ s/\n//g;
my @quant = split(/\s+/,$quantile);
   shift @quant;
   
open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    my @tem=(split);
    my ($chr,$stt1,$end1,$name,$strand,$type,$rp)=@tem;
    next if $rp < 0.1;
    for(my $i=1;$i<@quant;++$i){
        if($rp >=$quant[$i-1] && $rp< $quant[$i]){
            print "$_\t$i\n";
        }
    }
       
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genepos_FGS with categories>
    Rank to Six groups based on gene expression level.
DIE
}
