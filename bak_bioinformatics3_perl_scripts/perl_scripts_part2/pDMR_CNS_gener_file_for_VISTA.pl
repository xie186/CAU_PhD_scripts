#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($region, $gff, $input_dir, $out_dir, $out) = @ARGV;

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <gff> <input dir> <output dir> <out [run Vista]>
DIE
}

my $GENE = "GENE";
my $EXON = "EXON";
open GFF,$gff or die "$!";
my %hash_gff;
while(<GFF>){
    chomp;
    &ana_gff($_);
}

open REGION,$region or die "$!";
`mkdir $out_dir` if !-e "$out_dir";
open CMD,"+>./$out_dir/$out" or die "$!";
print CMD "export CLASSPATH=\"/NAS1/software/VISTA/target_path/vista/Vista.jar:/NAS1/software/VISTA/target_path/vista/retepPDF2.jar\"\n";
while(<REGION>){
    chomp;
    my ($dmr,$chr2, $stt2, $end2, $strand2, $chr1, $stt1, $end1, $strand1) = split;
    print "./$input_dir/$chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.align \n" if !-e "./$input_dir/$chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.align";
    open ALIGN, "./$input_dir/$chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.align" or die "$!";
    my ($id2,$seq2,$id1,$seq1) = <ALIGN>;
    chomp $seq2;
    chomp $seq1;
     
    &get_pos($chr2, $stt2, $end2, $strand2, $chr1, $stt1, $end1, $strand1, $seq2,$seq1);
    &get_exon($chr2, $stt2, $end2);
    &plotfile($dmr, $chr2, $stt2, $end2, $strand2, $chr1, $stt1, $end1, $strand1);
    print CMD "java Vista $chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.plotfile\n";
}

sub plotfile{
    my ($dmr,$chr2, $stt2, $end2, $strand2, $chr1, $stt1, $end1, $strand1) = @_;
    my ($stt,$end) = (1,$end2 - $stt2 +1);
    open PLOT,"+>./$out_dir/$chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.plotfile" or die "$!";
    print PLOT <<PLOT;
TITLE $dmr

OUTPUT $chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.pdf

ALIGN $chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.out
 SEQUENCES $chr2\_$stt2\_$end2 $chr1\_$stt1\_$end1
 REGIONS 75 100
 REGION_FILE $chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.txt
 ALIGNMENT_FILE $chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.alignment
END

GENES $chr2\_$stt2\_$end2.exons 

COORDINATE $chr2\_$stt2\_$end2

START $stt

END $end

WINDOW 100

NUM_PLOT_LINES 1

LEGEND on

AXIS_LABEL all

PLOT
}

sub get_exon{
    my ($chr2,$stt2,$end2) = @_;
    open REG, "+>./$out_dir/$chr2\_$stt2\_$end2.exons" or die "$!";
    foreach my $gene(keys %hash_gff){
#        print "$gene\n" if !exists $hash_gff{$gene}->{$GENE};
        my %hash_exon;
        my ($chr, $stt, $end, $strand) = split(/\t/,$hash_gff{$gene}->{$GENE});
        next if $chr ne $chr2; 
        if( ($stt < $stt2 && $end >= $stt2 ) || ($stt >= $stt2 && $stt <= $end2) ){
            ($stt, $end) = ($stt - $stt2 + 1, $end - $stt2 + 1);
            next if ( ($stt < 0 && $end < 0) || ($stt > $end2 - $stt2 + 1 && $end > $end2 - $stt2 + 1) );
            if($stt < 0){
                $stt = 1;
            }
            if($end > $end2 - $stt2 + 1){
                $end = $end2 - $stt2 + 1;
            }
            print REG "$strand\t$stt\t$end\t$gene\n";
            foreach my $exon(@{$hash_gff{$gene}->{$EXON}}){
                my ($stt,$end,$exon_name) = split(/\t/,$exon);
                ($stt, $end) = ($stt - $stt2 + 1, $end - $stt2 + 1);
                next if ( ($stt < 0 && $end < 0) || ($stt > $end2 - $stt2 + 1 && $end > $end2 - $stt2 + 1) );
                if($stt < 0){
                    $stt = 1;
                }
                if($end > $end2 - $stt2 + 1){
                    $end = $end2 - $stt2 + 1;
                }
                print REG "$stt\t$end\texon\n" if !exists $hash_exon{"$stt\t$end\texon"};
                $hash_exon{"$stt\t$end\texon"} ++;
            }
        }
    } 
}

sub ana_gff{
    my ($gff_line) = @_;
    my ($chr,$tool,$ele,$stt,$end,$dot1,$strand,$dot2,$id) = split(/\t/,$gff_line);
        $chr = "chr".$chr if $chr !~ /chr/;
    if($ele eq "gene"){
        my ($gene_id) = $id =~ /;Name=(.*);biotype/;
        if($strand eq "+"){
            $strand = ">";
        }else{
            $strand = "<";
        }
        $hash_gff{$gene_id} -> {$GENE} = "$chr\t$stt\t$end\t$strand";
    }elsif($ele eq "exon"){
        my ($gene_id) = $id =~ /Parent=(.*);Name/;
        if($gene_id =~ /GRM/){
             ($gene_id) = split(/_/,$gene_id);
        }else{
              $gene_id =~ s/FGT/FG/;
        }
        push @{$hash_gff{$gene_id} -> {$EXON}} , "$stt\t$end\texon\n";
    }
}

sub get_pos{
    my ($chr2, $stt2, $end2, $strand2, $chr1, $stt1, $end1, $strand1, $seq2,$seq1) = @_;
    if($strand2 eq "-"){
        $seq2 = reverse $seq2;
        $seq2 =~ tr/ATGC/TACG/;
        $seq1 = reverse $seq1;
        $seq1 =~ tr/ATGC/TACG/;
    }
    open OUT, "+>$out_dir/$chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.out"  or die "$!";    
    my @seq2 = split(//, $seq2);
    my @seq1 = split(//, $seq1);
    my ($mismatch_nu2,$mismatch_nu1) = (0,0);
    for(my $i = 0; $i < @seq2; ++ $i){
       my ($tem_base2, $tem_base1) =($seq2[$i] ,  $seq1[$i]);
       my ($pos2,$pos1,$link);
        if($seq2[$i] ne "-"){  ### maize
             $pos2 = $i + 1 - $mismatch_nu2;
       }else{
           $pos2 = " ";
           ++ $mismatch_nu2;
           $tem_base2 = "|";
       }
    
       if($seq1[$i] ne "-"){   ### sorghum
           $pos1 = $i + 1 - $mismatch_nu1;
        }else{
            ++ $mismatch_nu1;
            $pos1 = " ";
            $tem_base1 = "|";
        }
    
        if($seq2[$i] eq "-" || $seq2[$i] eq "-"){
            $link = " ";
        }else{
            $link = "-"
        }
        print OUT "$pos2 $tem_base2 $link $tem_base1 $pos1\n";
    }
}
