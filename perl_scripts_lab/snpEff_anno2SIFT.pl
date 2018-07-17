#!/usr/bin/perl -w
use strict;

my ($results, $pep, $codon_tab, $out) = @ARGV;
die usage() unless @ARGV == 4;
sub usage{
    my $die =<<DIE;
perl $0 <results> <protein> <codon tab> <out> 
DIE
}
open TAB, $codon_tab or die "$!";
my %codon_tab;
while(<TAB>){
    chomp;
    #Alanine         Ala       A             GCA,GCC,GCG,GCU
    my ($codon, $codon3, $codon1) = split(/\s+/);
    $codon_tab{$codon3} = $codon1;
}

$/ = "\n>";
open PEP, $pep or die "$!";
my %pep_seq;
while(<PEP>){
    chomp;
    $_ =~ s/>//g;
    my ($id, $seq) = split(/\n/, $_, 2);
    ($id) = split(/\s+/, $id);
    $seq =~ s/\n//g;
    $pep_seq{$id} = $seq;
}
close PEP;

$/ = "\n";
my %target_pep;
my %target_pos;
open RES, $results or die "$!";
while(<RES>){
    chomp;
    next if /^#/;
    my ($chr,$geno_pos,$dot1,$ref,$alt,$qual, $dot, $eff) = split;
    my @info = split(/,/, (split(/=/,$eff))[1]);
    foreach my $info(@info){
        #SYNONYMOUS_CODING(LOW|SILENT|gcC/gcA|A26|147|GGA.4981|protein_coding|CODING|ENSGALT00000036371|1|1),
        #Effect ( Effect_Impact | Functional_Class | Codon_Change | Amino_Acid_change| Amino_Acid_length | Gene_Name | Transcript_BioType | Gene_Coding | Transcript_ID | Exon  | GenotypeNum [ | ERRORS | WARNINGS ]
        #SYNONYMOUS_CODING(LOW|SILENT|gcC/gcA|A26|147|GGA.4981|protein_coding|CODING|ENSGALT00000036371|1|1),
        $info =~ s/\|WARNING.*\)/)/g;
        my ($effect, $impact, $class, $codon_chg, $amino_chg, $amino_len, $gene_name, $biotype,$gene_coding,$id,$exon,$GenotypeNum) = $info =~ /(.*)\((.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\)/;
        if($effect eq "missense_variant"){
            my ($aa1, $pos, $aa2) = $amino_chg =~ /p\.([A-Za-z]*)(\d+)(.*)\//;
            #$target_pep{$id} -> {"$codon_tab{$aa1}$pos$codon_tab{$aa2}"} ++;
            $target_pos{$id}->{$pos}= "$codon_tab{$aa1}\t$codon_tab{$aa2}";
            print "$chr\t$geno_pos\t$dot1\t$ref\t$alt\t$amino_chg\t$codon_tab{$aa1}\t$pos\t$codon_tab{$aa2}\t$id\n";
        }
    } 
}

open OUT, "+>$out.qsub" or die "$!";
print OUT <<OUT;
#!/bin/sh -l
#PBS -q zhu132
#PBS -l nodes=1:ppn=1,naccesspolicy=shared
#PBS -l walltime=100:00:00
#PBS -N SIFT
#PBS -d /scratch/conte/x/xie186/suspension_cell_adaptation/call_var_VarScan2/var_filter/cal_SIFT_score
#PBS -o $out.out
#PBS -e $out.err
OUT
foreach my $id(keys %target_pos){
    &process_protein_len($id);
    open FA, "+>protein_seq/$id.fasta" or die "$!";
    print FA ">$id\n$pep_seq{$id}\n";
    close FA;
    open SUB, "+>protein_seq/$id.subst" or die "$!";
    my $sub = join("\n", keys %{$target_pep{$id}});
    print SUB "$sub";
    close SUB;
    foreach my $rela_pos(keys %{$target_pep{$id}}){
        print "down\t$id\t$rela_pos\t$target_pep{$id}->{$rela_pos}\n";
    }
    print OUT "csh /scratch/conte/x/xie186/software/sift5.2.2/bin/SIFT_for_submitting_fasta_seq.csh ./protein_seq/$id.fasta /scratch/conte/x/xie186/software/sift5.2.2/db/uniref90.fasta ./protein_seq/$id.subst\n";
}
close OUT;

sub process_protein_len{
    my ($id) = @_;
    my $fa_len = length $pep_seq{$id};
    my @pos = keys %{$target_pos{$id}};
    #print "POS:\t$id\t@pos\n";
    my ($min, $max) = (sort{$a<=>$b} @pos)[0, -1];
    my $dis = $max - $min;
    if($fa_len > 500){
        #print "ERROR: distance between var is larger than 500 bp\n" if $dis > 500;
        my ($tem_min, $tem_max) = ($min-249 + int($dis/2+0.5), $max + 249 - int($dis/2+0.5));
        if($tem_min <= 0){
            $tem_min = 1;
            $tem_max = 498;
        }elsif($tem_max > $fa_len){
            $tem_max = $fa_len;
            $tem_min = $fa_len -498;
        }
        ($min, $max) = ($tem_min, $tem_max);
        #print "GT500\t$id\t$fa_len\n";
        $pep_seq{$id} = substr($pep_seq{$id}, $min -1, $max-$min +1);
        #print "SEQ:\t$id\t$min, $max\t$pep_seq{$id}\n";
    }
    foreach my $pos(@pos){
        my ($aa1, $aa2) = split(/\t/, $target_pos{$id}->{$pos});
        my $rela_pos = $pos - $min + 1;
        $target_pep{$id} -> {"$aa1$rela_pos$aa2"} = "$aa1$pos$aa2";
    }
}
