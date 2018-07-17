#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
sub usage{
    my $die =<<DIE;
perl $0 <results snpEff> <4 fold degenerate data> 
DIE
}
my ($results, $fold4codon) = @ARGV;
open COD, $fold4codon or die "$!";
my %rec_fold4codon;
while(<COD>){
     chomp;
     next if /^#/;
     my ($codon1, $codon2, $codon3, $codon4, $pos) = split;
     $rec_fold4codon{"$codon1\t$pos"} ++;
     $rec_fold4codon{"$codon2\t$pos"} ++;
     $rec_fold4codon{"$codon3\t$pos"} ++;
     $rec_fold4codon{"$codon4\t$pos"} ++;
} 
close COD;

open RES, $results or die "$!";
while(<RES>){
    chomp;
    next if /^#/;
    my ($chr,$pos,$dot1,$ref,$alt,$qual, $dot, $eff) = split;
    my @info = split(/,/, (split(/=/,$eff))[1]);
    my %uniq_pos;
    foreach my $info(@info){
        #SYNONYMOUS_CODING(LOW|SILENT|gcC/gcA|A26|147|GGA.4981|protein_coding|CODING|ENSGALT00000036371|1|1),
        #Effect ( Effect_Impact | Functional_Class | Codon_Change | Amino_Acid_change| Amino_Acid_length | Gene_Name | Transcript_BioType | Gene_Coding | Transcript_ID | Exon  | GenotypeNum [ | ERRORS | WARNINGS ]
        #MODERATE|MISSENSE|Gat/Cat|p.Asp3His/c.7G>C|429|AT1G01010|protein_coding|CODING|AT1G01010.1|1|1
        $info =~ s/\|WARNING.*\)/)/g;
        my ($effect, $impact, $class, $codon_chg, $amino_chg, $amino_len, $gene_name, $biotype,$gene_coding,$id,$exon,$GenotypeNum) = $info =~ /(.*)\((.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\)/;
        next if ($effect ne "missense_variant" && $effect ne "stop_gained" && $effect ne "stop_lost" && $effect ne "synonymous_variant");
        my ($codon1, $codon2) = split(/\//, $codon_chg);
        $codon1 =~ /[ATGC]/;
        my $upper_pos = 1 + (length $`);
        if($upper_pos == 2){
            $uniq_pos{"$chr\t$pos"} .= "Non-syn";
        }elsif($upper_pos == 3){
            $codon1 = uc $codon1;
            $uniq_pos{"$chr\t$pos"} .= "4-fold" if exists $rec_fold4codon{"$codon1\t$upper_pos"};
        }
    } 
    foreach my $out(keys %uniq_pos){
        if($uniq_pos{$out} =~ /Non-syn/){
            print "$out\tNon-syn\n";
        }else{
            print "$out\t4-fold\n";
        }
    }
}
