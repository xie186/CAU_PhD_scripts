#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($snp,$cuff_trans,$out) = @ARGV;

open SNP,$snp or die "$!";
my %hash_imp;
while(<SNP>){
    chomp;
    my ($chr,$pos) = split;
    $hash_imp{"$chr\t$pos"} = $_;
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
    next if $stat == 0;
    my $tem_gene_id =$gene_id."\_$chr\_$stt\_$end\_$strand";
    for(my $i = $stt;$i <=$end;++$i){
        print OUT "$chr\t$stt\t$end\t$strand\t$stat\t$tem_gene_id\t$ref_id\t$class_code-$hash_class_code{$gene_id}\t$hash_imp{\"$chr\t$i\"}\n" if exists $hash_imp{"$chr\t$i"};
        $snp_imp{"$chr\t$i"} ++ if exists $hash_imp{"$chr\t$i"};
    }
}
close OUT;

foreach(keys %hash_imp){
    next if exists $snp_imp{$_};
    print "$hash_imp{$_}\n";
}
close CUFF;

sub usage{
    print <<DIE;
    perl *.pl <snp> <cuff_trans> <OUT put>  >> <SNP not loaded in assembled transcripts>
DIE
    exit 1;
}
