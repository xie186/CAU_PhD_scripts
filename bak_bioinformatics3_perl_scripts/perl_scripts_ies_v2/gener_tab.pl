#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($chisq,$snp_geno,$gff) = @ARGV;

my ($surfix) = $chisq =~ /(endo_.*DAP)/;

open GENO,$snp_geno or die "$!";
my %snp_geno;
while(<GENO>){
    chomp;
    #GRMZM2G073609   372     T       33      T       25      G       8
    my ($gene,$pos,$ref,$tot_dep,$alt1,$dep1,$alt2,$ref2) = split;
    if($ref eq $alt1){
        $snp_geno{"$gene\t$pos"} = "$ref/$alt2";
    }else{
        $snp_geno{"$gene\t$pos"} = "$ref/$alt1";
    }
}

open CHI,$chisq or die "$!";
my %hash_snp;
while(<CHI>){
    chomp;
    my ($gene,$pos,$bm_b,$bm_m,$mb_b,$mb_m,$pvalue1,$pvalue2) = split;
    next if ($pvalue1 eq "NA" ||$pvalue2 eq "NA" || $pvalue1 > 0.05 || $pvalue2 > 0.05);
    my ($imp_2to1,$imp_5to1) = &judge($bm_b,$bm_m,$mb_b,$mb_m);
    next if $imp_2to1 eq "NA";
    my $snp = "$gene\t$pos\t$snp_geno{\"$gene\t$pos\"}\t$bm_b\t$bm_m\t$mb_b\t$mb_m\t$pvalue1\t$pvalue2\t$imp_2to1\t$imp_5to1";
#    &judge_snp_struct($gene,$pos,$snp);
    $hash_snp{"$gene\t$pos"} = "$gene\t$pos\t$snp_geno{\"$gene\t$pos\"}\t$bm_b\t$bm_m\t$mb_b\t$mb_m\t$pvalue1\t$pvalue2\t$imp_2to1\t$imp_5to1";
}

open GFF,$gff or die "$!";
my %hash_gene;
my %gene_ele;
while(<GFF>){
    chomp;
    #9       ensembl gene    19970   20093   .       +       .       ID=GRMZM2G581216;Name=GRMZM2G581216;biotype=transposable_element
    &proc_gff($_);
}

sub judge_snp_struct{
    my ($gene,$pos,$snp) = @_;
    foreach my $ele (keys %{$gene_ele{$gene}}){
        foreach my $coor(@{$gene_ele{$gene} -> {$ele}}){
            my ($chr,$stt,$end) = split(/\t/,$coor); 
            for(my $i = $stt;$i <=$end;++$i){
                print "$snp\t$chr\t$ele\t$stt\t$end\t$surfix\n";
            }
        }
    }
}

sub proc_gff{
    my ($line) = @_;
    my ($chr,$tools,$ele,$stt,$end,$dot1,$strand,$dot2,$id) = split(/\t/,$line);
    if($ele eq "gene"){
        my ($gene) = $id =~ /ID=(.*);Name=/;
        $hash_gene{$gene} = "$stt\t$end";
    }elsif($ele eq "intron" || $ele eq "exon"){
     #   Parent=GRMZM2G163722_T01;Name=intron.8
        my ($gene) = $id =~ /Parent=(.*);Name/;
           ($gene) = split(/_/,$gene) if $gene =~ /^GRMZM/;
           $gene =~ s/FGT/FG/;
        print "$gene\n" if !exists $hash_gene{$gene};
        my ($tem_stt,$tem_end) = split(/\t/,$hash_gene{$gene});
        if($strand eq "+"){
            ($stt,$end) = ($stt - $tem_stt + 1, $end - $tem_stt + 1);
        }else{
            ($stt,$end) = ($tem_end - $end + 1, $tem_end - $stt + 1);
        }
        for(my $i = $stt; $i <= $end; ++$i){
            print "$hash_snp{\"$gene\t$i\"}\t$chr\t$ele\t$stt\t$end\t$surfix\n" if exists $hash_snp{"$gene\t$i"};
        }
#        push @{$gene_ele{$gene} -> {$ele}}, "$chr\t$stt\t$end";
    }
}

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
    my $die=<<DIE;
    perl *.pl <Chi sq results> <snp geno> <GFF>
DIE
}
