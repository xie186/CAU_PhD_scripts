#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($ge_pos,$hapmap,$chrom,$out) =@ARGV;

open SNP,$hapmap or die "$!";
open OUT,"+>$out" or die "$!";
my $head = <SNP>;
my ($tem_snp_id,$tem_geno,$tem_chr,$tem_pos,$tem_na1,$tem_na2,$tem_na3,$tem_na4,$tem_na5,$tem_na6,$tem_na7,@name) = split(/\s+/,$head);
my %snp_pos;
while(<SNP>){
    chomp;
    my ($snp_id,$geno,$chr,$pos,$na1,$na2,$na3,$na4,$na5,$na6,$na7,@geno) = split;
    my $geno_hap = join("\t",@geno);
       $geno_hap =~ s/AA/1/g;
       $geno_hap =~ s/CC/2/g;
       $geno_hap =~ s/GG/3/g;
       $geno_hap =~ s/TT/4/g;
    $snp_pos{"$chr\t$pos"} = "$chr\t$pos\t$geno_hap";
}

open POS,$ge_pos or die "$!";
my %hash_geno;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene) = split;
    $chr = "chr".$chr if $chr =~ /^\d/;
    next if $chr ne "$chrom";
    my $mid = int(($stt+$end)/2);
    my $nu = 0;
    for(my $i = $mid; $nu <= 29; --$i){
        next if !exists $snp_pos{"$chr\t$i"};
        if($i <= 0){
            print "SNP number is not enough\n";
	    last;
        }
        ++ $nu;
        my ($chr, $pos, @geno) = split(/\t/,$snp_pos{"$chr\t$i"});
        for(my $j = 0; $j < @name; ++$j){
            unshift @{$hash_geno{$gene}->{$name[$j]}}, $geno[$j];
        }
    }
       $nu = 0;
    for(my $i = $mid; $nu <= 29; ++$i){
        next if !exists $snp_pos{"$chr\t$i"};
        ++ $nu;
        my ($gene_id, $chr, $pos, @geno) = split(/\t/,$snp_pos{"$chr\t$i"});
        for(my $j = 0; $j < @name; ++$j){
            push @{$hash_geno{$gene}->{$name[$j]}}, $geno[$j];
        }
    }
}

foreach my $gene(keys %hash_geno){
     foreach my $inbred (keys %{$hash_geno{$gene}}){
         my $geno = join("\t",@{$hash_geno{$gene}->{$inbred}});
         print OUT "$gene\t$inbred\t$geno\n";
     }
}

sub usage{
    my $die=<<DIE;
    print *.pl <Candidate gene pos> <Hapmap> <Gene name> <OUT>
DIE
}
