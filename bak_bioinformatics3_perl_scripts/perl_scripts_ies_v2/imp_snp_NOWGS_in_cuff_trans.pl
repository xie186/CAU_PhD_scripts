#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($snp,$cuff_trans,$out_in_trans,$out_no_trans) = @ARGV;

open SNP,$snp or die "$!";
my %hash_imp;
while(<SNP>){
    chomp;
    my ($chr,$pos,$bm_b,$bm_m,$mb_b,$mb_m,$pvalue1,$pvalue2, $alleles,$imp_2to1,$imp_5to1,$gene,$rela_pos,$ele,$stt,$end,$strand) = split;
    $hash_imp{"$chr\t$pos"} = "$chr\t$pos\t$bm_b\t$bm_m\t$mb_b\t$mb_m\t$pvalue1\t$pvalue2\t$alleles\t$imp_2to1\t$imp_5to1";
}

open CUFF,$cuff_trans or die "$!";
my %hash_class_code;
while(<CUFF>){
    chomp;
    my ($chr,$stt,$end,$strand,$stat,$gene_id,$ref_id,$class_code) = split;
    $hash_class_code{$gene_id} .= $class_code;
}
close CUFF;

open OUT,"+>$out_in_trans" or die "$!";     ## imp snp that were not located in WGS , but in cuff trans
open OUTNO,"+>$out_no_trans" or die "$!";   ## imp snp that were not located in WGS and cuff trans
open CUFF,$cuff_trans or die "$!";
my %snp_imp;
while(<CUFF>){
    chomp;
    my ($chr,$stt,$end,$strand,$stat,$gene_id,$ref_id,$class_code) = split;
    print "$chr,$stt,$end,$strand,$stat,$gene_id,$ref_id,$class_code\n";
#    next if $stat == 0;
    my $tem_gene_id =$gene_id."\_$chr\_$stt\_$end\_$strand";
    for(my $i = $stt;$i <=$end;++$i){
        print OUT "$hash_imp{\"$chr\t$i\"}\t$tem_gene_id\t$ref_id\t$class_code-$hash_class_code{$gene_id}\n" if exists $hash_imp{"$chr\t$i"};
        $snp_imp{"$chr\t$i"} ++ if exists $hash_imp{"$chr\t$i"};
    }
}
close OUT;

foreach(keys %hash_imp){
    next if exists $snp_imp{$_};
    print OUTNO "$hash_imp{$_}\n";
}
close CUFF;

sub judge{
    my ($bm_b,$bm_m,$mb_b,$mb_m) = @_;
    my ($imp_2to1,$imp_5to1) = (0,0);
    if(($bm_b/($bm_b+$bm_m) > 2/3 && $mb_m/($mb_b+$mb_m)>2/3)){
        $imp_2to1 = "mat";
        if($bm_b/($bm_b+$bm_m) > 10/11 && $mb_m/($mb_b+$mb_m)>10/11){
            $imp_5to1 = "mat";
        }else{
            $imp_5to1 = "NA";
        }
    }elsif($bm_m/($bm_b+$bm_m) > 1/3 && $mb_b/($mb_b+$mb_m)>1/3){
        $imp_2to1 = "pat";
        if(($bm_m/($bm_b+$bm_m) > 5/7 && $mb_b/($mb_b+$mb_m)>5/7)){
            $imp_5to1 = "pat";
        }else{
            $imp_5to1 = "NA";
        }
    }else{
        $imp_2to1 = "NA";
    }
    return ($imp_2to1,$imp_5to1);
}

sub usage{
    print <<DIE;
    perl *.pl <snp> <cuff_trans> <OUTput [snp in cuff trans]> <snp not loaded in assembled transcripts>
DIE
    exit 1;
}
