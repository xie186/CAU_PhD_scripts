#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($pheno_list,$ld_decay_reg) = @ARGV;

open PHE,$pheno_list or die "$!";
my %pheno;
while(<PHE>){
    chomp;
    my ($phe) = split;
    $pheno{$phe} ++;
}

open REG,$ld_decay_reg or die "$!";
my @tem_reg = <REG>;
my $tem_reg = join('', @tem_reg);
   @tem_reg = split(/###/,$tem_reg);
shift @tem_reg;
foreach my $tem_phe_reg(@tem_reg){
    #GAPIT.protein_content.GWAS.ps.p2log.gt6#
    my ($pheno, @region) = split(/\n/,$tem_phe_reg);
        ($pheno) = $pheno =~ /GAPIT\.(.*)\.GWAS\.ps\.p2log\.gt6/;
    foreach my $tem_region(@region){
        next if $tem_region !~ /^region/;
        my ($dot,$chr,$stt,$end) = split(/\t/,$tem_region);
        print "$chr\t$stt\t$end\t$pheno\n";
    }
}

sub usage{
    my $die =<<DIE;
   perl *.pl <pheno> <region> 
DIE
}
