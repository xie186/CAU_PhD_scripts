#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($snp,$gff,$out1,$out2) = @ARGV;
my ($code) = $snp =~ /(\d+DAP_in_cuff)/;

open GFF,$gff or die "$!";
my %gene_pos;
my %gene_ele;
while(<GFF>){
    &proc_gff($_);
}
open OUT, "|sort -u > $out1" or die "$!";
open OUT2,"|sort -u > $out2" or die "$!";
open SNP,$snp or die "$!";
my %hash_imp;
while(<SNP>){
    chomp;
    my ($chr, $pos, $alt, $bm_b, $bm_m, $mb_b, $mb_m, $pvalue1, $pvalue2, $imp_2to1, $imp_5to1, $tem_gene_id, $ref_id, $class_code) = split;
    if($class_code =~ /[=cjeoprs\.]/){
        if($ref_id ne "-"){
            my ($gene_id) = split(/\|/,$ref_id);
            &judge($chr,$pos,$alt, $bm_b, $bm_m, $mb_b, $mb_m, $pvalue1, $pvalue2, $imp_2to1, $imp_5to1, $gene_id);
        }
    }else{
        print OUT2 "$_\t$code\n";        
    }
}

sub judge{
    my ($chr,$pos,$alt, $bm_b, $bm_m, $mb_b, $mb_m, $pvalue1, $pvalue2, $imp_2to1, $imp_5to1, $gene_id) = @_;
    my ($chrom,$stt,$end,$strand) = split(/\t/,$gene_pos{$gene_id});
    my $len = $end - $stt + 1;
    if($strand eq "+"){
        my $rela_pos = $pos - $stt + 1;
        my $print_pre = "$gene_id\t$rela_pos\t$alt\t$bm_b\t$bm_m\t$mb_b\t$mb_m\t$pvalue1\t$pvalue2\t$imp_2to1\t$imp_5to1\t$chr";
        if ($rela_pos < 0){
            print OUT "$print_pre\tpromoter\t$code\n";
        }elsif($rela_pos > $len){
            print OUT "$print_pre\tdownstream\t$code\n";
        }else{
             &judge_ele($gene_id,$chr,$stt,$end,$strand,$rela_pos,$print_pre);
        }
    }else{
        my $rela_pos = $end - $pos + 1;
        my $print_pre = "$gene_id\t$rela_pos\t$alt\t$bm_b\t$bm_m\t$mb_b\t$mb_m\t$pvalue1\t$pvalue2\t$imp_2to1\t$imp_5to1\t$chr";
        if ($rela_pos < 0){
            print OUT "$print_pre\tpromoter\t$code\n";
        }elsif($rela_pos > $len){
            print OUT "$print_pre\tdownstream\t$code\n";
        }else{
            &judge_ele($gene_id,$chr,$stt,$end,$strand,$rela_pos,$print_pre);
        }
    }
}

sub judge_ele{
    my ($gene,$chr,$gene_stt,$gene_end,$strand,$rela_pos,$print_pre) = @_;
    foreach my $ele (keys %{$gene_ele{$gene}}){
        foreach my $region (@{$gene_ele{$gene} ->{$ele}}){
             my ($chr,$stt,$end,$strand) = split(/\t/,$region);
             my ($rela_stt,$rela_end) = &rela_ele_pos($gene_stt,$gene_end,$strand,$stt,$end);
             for(my $i = $rela_stt;$i <= $rela_end; ++$i){
                 print OUT "$print_pre\t$ele\t$rela_stt\t$rela_end\t$code\n" if $i == $rela_pos;
             }
        }
    } 
}

sub rela_ele_pos{
    my ($gene_stt,$gene_end,$strand,$stt,$end) = @_;
    my ($rela_stt,$rela_end) = (0,0);
    if($strand eq "+"){
        ($rela_stt,$rela_end) = ($stt - $gene_stt +1, $end - $gene_stt + 1);
    }else{
        ($rela_stt,$rela_end) = ($gene_end - $end +1, $gene_end - $stt + 1);
    }
    return ($rela_stt,$rela_end);
}

sub proc_gff{
    my ($line) = @_;
    my ($chr,$tools,$ele,$stt,$end,$dot1,$strand,$dot2,$id) = split(/\t/,$line);
    if($ele eq "gene"){
        my ($gene) = $id =~ /ID=(.*);Name=/;
        $gene_pos{$gene} = "$chr\t$stt\t$end\t$strand";
    }elsif($ele eq "intron" || $ele eq "exon"){
        my ($gene) = $id =~ /Parent=(.*);Name/;
           ($gene) = split(/_/,$gene) if $gene =~ /^GRMZM/;
           $gene =~ s/FGT/FG/;
        push @{$gene_ele{$gene}->{$ele}} , "$chr\t$stt\t$end\t$strand";
    }
}

sub usage{
    print <<DIE;
    perl *.pl <GFF> <SNP infor> <OUT1 with gene> <OUT2 novel>
DIE
    exit 1;
}
