#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($pheno,$inbred) =  @ARGV; 
my %hash_in_name;
open PHE,$pheno or die "$!";
my $header = <PHE>;
my ($inred_line,@phe_name) = split(/\s+/,$header);

while(<PHE>){
    chomp;
    my ($name,@phe) = split;
    $name =~ s/CAU0/CAU/;
    $name =~ s/IL_/IL/g;
    push @{$hash_in_name{$name}} , @phe;
}
close PHE;

open IN,$inbred or die "$!";
my %hash_out;
my @inbred_name;
while(<IN>){
    chomp;
    my ($name) = split(/\s+/,$_);
    push @inbred_name,$name;
    my $tem_name = $name;
       $tem_name =~ s/CAU0/CAU/g;
    if(exists $hash_in_name{$tem_name}){
        for(my $i =0;$i<@phe_name;++$i){
            my $tem_phe_name = $phe_name[$i];
            push @{$hash_out{$tem_phe_name}} , ${$hash_in_name{$tem_name}}[$i];
        }
        @{$hash_out{$name}} = @{$hash_in_name{$tem_name}};
    }else{
        for(my $i =0;$i<@phe_name;++$i){
            my $tem_phe_name = $phe_name[$i];
            push @{$hash_out{$tem_phe_name}} , "NaN";
        }
    }
}

for(my $i =0;$i<@phe_name;++$i){
    my $tem_phe_name = $phe_name[$i];
    open PHE,"+>$tem_phe_name.pheno" or die "$!";
    print PHE "Taxa\t$tem_phe_name\n";
    for(my $j = 0;$j < @inbred_name;++$j){
        print PHE "$inbred_name[$j]\t${$hash_out{$tem_phe_name}}[$j]\n";
    }
    close PHE;
}


sub usage{
    print <<DIE;
    perl *.pl <Phenotype> <kinship results>
DIE
   exit 1;
}
