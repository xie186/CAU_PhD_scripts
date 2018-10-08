#!/usr/bin/perl -w 
use strict;

die usage() unless @ARGV == 5;
my ($vcf, $control, $mut, $depth_lim, $out) = @ARGV;

my ($min_dep, $max_dep) = split(/:/, $depth_lim);
my ($idx_control, $idx_mut) = (-1, -1);

open OUT, "+>$out" or die "$!";
print OUT "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tT1_geno\tT1_tot_depth\tT1_dep_ref\tT1_dep_alt\tT2_geno\tT2_tot_depth\tT2_dep_ref\tT2_dep_alt\n";
#CHROM  POS    ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  0426    0887    30119   3029    3049    3059    3069 
open VCF, $vcf or die "$!";
while(<VCF>){
    chomp;
    ($idx_control, $idx_mut) = &header($_) if $_ =~ /^#CHROM/;
    next if /^#/;
    &var_process($_); 
}

sub var_process{
    my ($line) = @_;
    die "control and mutant line index number are not available\n" if ($idx_control == -1 || $idx_mut == -1);
    my ($chr, $pos, $id, $ref, $alt, $qual, $filter, $infor, $format, @individual) = split;
    my @alt = split(/,/, $alt);
    return if @alt >= 2;
    &geno_infor($chr, $pos, $id, $ref, $alt, $qual, $filter, $infor, $format, $individual[$idx_control], $individual[$idx_mut]);
}

sub geno_infor{
   my ($chr, $pos, $id, $ref, $alt, $qual, $filter, $infor, $format, $tem_control, $tem_mut) = @_;
   my @control = split(/:/, $tem_control);
   my @mut     = split(/:/, $tem_mut); 
   if($tem_control =~ /\.\/\./ || $tem_mut =~ /\.\/\./){
        print "./. existsed: $chr\t$pos: PASS\n";
        return;
    }
    if($tem_control =~ /0\/1/ || $tem_mut =~ /0\/1/){
        print "hetero genotype existsed: $chr\t$pos: PASS\n";
        return;
    }
    my @format = split(/:/, $format);
    my %info_control;my %info_mut;
    for(my $i =0; $i < @format; ++$i){
        $info_control{$format[$i]} = $control[$i];
        $info_mut{$format[$i]}     = $mut[$i];
    }
   my ($tem_T1_geno, $tem_T2_geno) = &jug_geno($ref, $alt, $info_control{"GT"}, $info_mut{"GT"});
   my ($T1_geno, $T1_tot_depth, $T1_dep_ref, $T1_dep_alt);
   my ($T2_geno, $T2_tot_depth, $T2_dep_ref, $T2_dep_alt);
   if($format eq "GT:DP" || $format eq "GT:AD:DP" ){
        ($T1_geno, $T1_tot_depth, $T1_dep_ref, $T1_dep_alt) = ($tem_T1_geno, $info_control{"DP"}, $info_control{"DP"}, 0);
        ($T2_geno, $T2_tot_depth, $T2_dep_ref, $T2_dep_alt) = ($tem_T2_geno, $info_mut{"DP"},     $info_mut{"DP"},     0);
    }else{
        ($T1_geno, $T1_tot_depth, $T1_dep_ref, $T1_dep_alt) = ($tem_T1_geno, $info_control{"DP"}, split(/,/, $info_control{"AD"}));
        ($T2_geno, $T2_tot_depth, $T2_dep_ref, $T2_dep_alt) = ($tem_T2_geno, $info_mut{"DP"},     split(/,/, $info_mut{"AD"}));
    }
    if($T1_tot_depth >= $min_dep && $T1_tot_depth <= $max_dep && $T2_tot_depth >= $min_dep && $T2_tot_depth <= $max_dep && $T1_dep_ref + $T1_dep_alt >= $min_dep && $T1_dep_ref + $T1_dep_alt <= $max_dep && $T2_dep_ref + $T2_dep_alt >= $min_dep && $T2_dep_ref + $T2_dep_alt <= $max_dep){
       ###criteria 5 & 6
       #if($T1_dep_ref * $T1_dep_alt == 0 && $T2_dep_ref * $T2_dep_alt == 0 && $T1_dep_ref + $T1_dep_alt >= $T1_tot_depth && $T2_dep_ref + $T2_dep_alt >=  $T2_tot_depth){
            print "stat\t$chr\t$pos\n";
            print OUT "$chr\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$T1_geno\t$T1_tot_depth\t$T1_dep_ref\t$T1_dep_alt\t$T2_geno\t$T2_tot_depth\t$T2_dep_ref\t$T2_dep_alt\n";
       #}
    }
}

sub jug_geno{
        my ($ref, $alt, $geno_control, $geno_mut) = @_; 
        my ($tem_T1_geno, $tem_T2_geno) = (-1, -1);
        if($geno_control eq "0/0"){
            $tem_T1_geno = $ref;
        }else{
            $tem_T1_geno = $alt;
        }
        if($geno_mut eq "0/0"){
            $tem_T2_geno = $ref;
        }else{
            $tem_T2_geno = $alt;
        }
        return ($tem_T1_geno, $tem_T2_geno);
}

sub header{
    my ($header) = @_;
    my ($CHROM, $POS, $ID, $REF, $ALT, $QUAL, $FILTER, $INFO, $FORMAT, @sam_id) = split(/\t/, $header);
    my ($idx_control, $idx_mut, $flag) = ("NA", "NA");
    for(my $i = 0; $i < @sam_id; ++$i){
        if($sam_id[$i] eq $control){
            $idx_control = $i;
            ++$flag;
        }
        if($sam_id[$i] eq $mut){
            $idx_mut = $i;
            ++$flag;
        }
    }
    return ($idx_control, $idx_mut);
}

sub usage{
    my $die = <<DIE;
    perl *.pl <vcf raw variant> <sample 1> <sample2 mutation> <depth Limitation [min:max]> <out file> 
DIE
}
