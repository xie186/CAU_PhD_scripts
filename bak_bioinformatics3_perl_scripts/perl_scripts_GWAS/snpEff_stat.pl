#!/usr/bin/perl -w
use strict;

my ($anno,$out) = @ARGV;
die usage() unless @ARGV ==2;
open ANNO,$anno or die "$!";
my %stat_type;

open OUT,"+>$out" or die "$!";
while(<ANNO>){
    chomp;
    #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO 
    next if /^#/;
    my ($chrom,$pos,$id,$ref,$alt,$qual,$filter,$infor) = split;
    $infor =~ s/EFF=//;
    my @infor = split(/,/,$infor);
    foreach my $tem_infor(@infor) {
        #NON_SYNONYMOUS_CODING(MODERATE|MISSENSE|aaG/aaC|K7N||GRMZM5G888250|||GRMZM5G888250_T01|)
        my ($type,$order,$effect,$amino_acid,$chg_pos,$gene,$trans,$intron_num) = $tem_infor =~ /(.*)\((.*)\|(.*)\|(.*)\|(.*)\|\|(.*)\|\|\|(.*)\|(.*)\)/;
        print OUT "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$type\t$order\t$effect\t$amino_acid\t$chg_pos\t$gene\t$trans\t$intron_num\n";
        $stat_type{"$type"} -> {"snp_num"} -> {"$chrom\t$pos"} ++;
        $stat_type{"$type"} -> {"gene_num"}-> {"$gene"} ++;
    }
}    

foreach my $type(keys %stat_type){
    my $snp_num = keys  %{$stat_type{$type} -> {"snp_num"}};
    my $gene_num = keys  %{$stat_type{$type} -> {"gene_num"}};
    print "$type\t$snp_num\t$gene_num\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <anno> <out> 
DIE
}
