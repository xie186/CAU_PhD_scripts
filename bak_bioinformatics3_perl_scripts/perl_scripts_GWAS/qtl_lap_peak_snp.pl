#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($qtl_region,$peak,$cut) = @ARGV;
open QTL,$qtl_region or die "$!";
my @qtl = <QTL>;
my $qtl = join("",@qtl);
   @qtl = split(/####/,$qtl);
shift @qtl;
my %hash_qtl;
foreach(@qtl){
    my ($name,@region) = split(/\n/,$_);
    $name =~s/\s+//g;
    push @{$hash_qtl{$name}} , @region;
}

open SNP,$peak or die "$!";
my @snp = <SNP>;
my $snp = join("",@snp);
   @snp = split(/####/,$snp);
shift @snp;
foreach(@snp){
    my ($name,@peak) = split(/\n/,$_);
    next if !exists $hash_qtl{$name};
    foreach my $peak_pos(@peak){
        my ($chr,$pos,$maf,$p_log) = split(/\t/,$peak_pos);
            foreach my $region(@{$hash_qtl{$name}}){
                my ($chr1,$stt1,$end1) = split(/\t/,$region);
                print "$name\t$peak_pos\t$region\n" if ($chr eq "$chr1" && $pos >=$stt1 - $cut && $pos <=$end1 +$cut);
            }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <qtl> <peak SNPs> <Flanking region>
DIE
}
