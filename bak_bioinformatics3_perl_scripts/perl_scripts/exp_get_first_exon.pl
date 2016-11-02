#!/usr/bin/perl -w
use strict;
my ($gff)=@ARGV;
die usage() unless @ARGV==1;
open GFF,$gff or die "$!";
my @file=<GFF>;
for(my $i=0;$i<@file;++$i){
    chomp $file[$i];
    my @aa=split(/\s+/,$file[$i]);
    ###next 
    if($aa[2]!~/exon/ && $aa[2]!~/intron/ && $aa[2]!~/mRNA/){
        print "$file[$i]\n";
    }elsif($aa[2]=~/mRNA/){
        print "$file[$i]\n";
        my ($pro1,$pro2,$ter1,$ter2)=(0,0,0,0);
        if($aa[6] eq "+"){
            ($pro1,$pro2)=($aa[3]-2000,$aa[3]);
            ($ter1,$ter2)=($aa[4],$aa[4]+2000);
        }else{
            ($pro1,$pro2)=($aa[4],$aa[4]+2000);
            ($ter1,$ter2)=($aa[3]-2000,$aa[3]);
        }
        ### upstream and downstream
        ($aa[2],$aa[3],$aa[4])=("upstream",$pro1,$pro2);
        my $print=join("\t",@aa);
        print "$print\n";
        ($aa[2],$aa[3],$aa[4])=("downstream",$ter1,$ter2);
        $print=join("\t",@aa);
        print "$print\n";
    }elsif($aa[2] eq "exon"){
        my @aa_up=split(/\s+/,$file[$i-1]);
        my @aa_down=split(/\s+/,$file[$i+1]);
        ###single exon
        if ($aa_up[2] eq "mRNA"){
            $aa[2]="single_exon";
        }elsif($aa_up[2] eq "intron" && $aa[6] eq "+"){
            $aa[2]="first_exon";    ## q
        }elsif($aa_up[2] eq "exon" && $aa[6] eq "-" && $aa_down[2] eq "CDS"){
            $aa[2]="last_exon";
        }elsif($aa_up[2] eq "exon" && $aa_down[2] eq "exon"){
            $aa[2]="internal_exon";
        }elsif($aa_up[2] eq "intron" && $aa[6] eq "-"){
            $aa[2]="first_exon";
        }else{
            $aa[2]="last_exon";
        }
        my $print=join("\t",@aa);
        print "$print\n";
    }elsif($aa[2] eq "intron"){
        my @aa_up=split(/\s+/,$file[$i-1]);
        my @aa_down=split(/\s+/,$file[$i+1]);
        if($aa_up[2] eq "mRNA" && $aa_down[2] eq "exon"){
            $aa[2]="single_intron";
        }elsif($aa_up[2] eq "mRNA" && $aa_down[2] eq "intron"){
            $aa[2]="first_intron";
        }else{
            $aa[2]="internal_intron";
        }
        my $print=join("\t",@aa);
        print "$print\n";
    }
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <GFF>
DIE
}
