#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($par4,$out)=@ARGV;
open PAR,"cut -f1,2,3,4,5,6,12,14 $par4 | " or die "$!";
open OUT,"+>$out" or die "$!";
while(<PAR>){
    chomp;
    my ($chr,$stt,$end,$strand,$gene,$type,$cpg_oe,$te_or)=split;
    my $clas;
    if($cpg_oe >=0.9){
        $clas="HC".$te_or;
    }else{
        $clas="LC".$te_or;
    }
    $clas=~s/NO/NT/g;
    print OUT "$chr\t$stt\t$end\t$strand\t$gene\t$type\t$clas\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CpG O/E TE insertion or> <OUTPUT> 
DIE
}
