#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($snp,$snp_geno,$cuff_trans,$out) = @ARGV;

open GENO,$snp_geno or die "$!";
my %snp_geno;
while(<GENO>){
    chomp;
    #GRMZM2G073609   372     T       33      T       25      G       8
    my ($chr,$pos,$ref,$alt) = split;
    $snp_geno{"$chr\t$pos"} = "$ref/$alt";
}

open SNP,$snp or die "$!";
my %hash_imp;
while(<SNP>){
    chomp;
    my ($chr,$pos,$bm_b,$bm_m,$mb_b,$mb_m,$pvalue1,$pvalue2) = split;
    next if ($pvalue1 eq "NA" ||$pvalue2 eq "NA" || $pvalue1 > 0.05 || $pvalue2 > 0.05);
    my ($imp_2to1,$imp_5to1) = &judge($bm_b,$bm_m,$mb_b,$mb_m);
    next if $imp_2to1 eq "NA";
    my $snp = "$snp_geno{\"$chr\t$pos\"}\t$bm_b\t$bm_m\t$mb_b\t$mb_m\t$pvalue1\t$pvalue2\t$imp_2to1\t$imp_5to1";
#    &judge_snp_struct($gene,$pos,$snp);
    $hash_imp{"$chr\t$pos"} = "$chr\t$pos\t$snp_geno{\"$chr\t$pos\"}\t$bm_b\t$bm_m\t$mb_b\t$mb_m\t$pvalue1\t$pvalue2\t$imp_2to1\t$imp_5to1";
}

open CUFF,$cuff_trans or die "$!";
my %hash_class_code;
while(<CUFF>){
    chomp;
    my ($chr,$stt,$end,$strand,$stat,$gene_id,$ref_id,$class_code) = split;
    $hash_class_code{$gene_id} .= $class_code;
}
close CUFF;

open OUT,"+>$out" or die "$!";
open CUFF,$cuff_trans or die "$!";
my %snp_imp;
while(<CUFF>){
    chomp;
    my ($chr,$stt,$end,$strand,$stat,$gene_id,$ref_id,$class_code) = split;
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
    print "$hash_imp{$_}\n";
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
    perl *.pl <snp> <SNP geno> <cuff_trans> <OUT put>  >> <SNP not loaded in assembled transcripts>
DIE
    exit 1;
}
