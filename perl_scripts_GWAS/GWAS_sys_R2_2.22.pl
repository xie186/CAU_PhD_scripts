#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 10;
my ($gapit_dir,$gapit_code, $geno_dir, $geno_prefix,$geno_surfix,$kin,$pca,$res_dir,$file_num,$pheno) = @ARGV;

print <<R;
setwd("$gapit_dir")
library(multtest)
library("gplots")
library("LDheatmap")
library("genetics")
source("emma.R")
source("$gapit_code")
myY <-read.table("$pheno",sep="",head = TRUE)
myGFile <- "$geno_prefix"
myGFileExt <- "$geno_surfix"
myKI <- read.table("$kin",sep="", head = FALSE)
myCV <- read.table("$pca",sep="", head = TRUE)
setwd("$res_dir")
myGAPIT <- GAPIT(Y=myY,file.G=myGFile,file.Ext.G=myGFileExt,file.path="$geno_dir",file.from=1,file.to=$file_num,,KI=myKI,CV=myCV,SNP.P3D=TRUE)
R

sub usage{
    my $die =<<DIE;
    perl *.pl <gapit_dir> <gapit_code> <geno_dir> <geno_prefix> <geno_surfix> <kin> <pca> <res_dir> <file_num> <phenotype>
DIE
}
