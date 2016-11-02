#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($ge_pos,$hapmap,$geno_len,$out) =@ARGV;

my $date = `date`;
print "Start at : $date\n";
open LEN,$geno_len or die "$!";
my %geno_len;
while(<LEN>){
    chomp;
    my ($chr,$len) = split;
    $geno_len{$chr} = $len;
}

print "Reading the hapmap file\n";
open SNP,$hapmap or die "$!";
my %hash_snp;
my $head = <SNP>;
chomp $head;
my ($snp_id,$geno,$chr,$pos,$na1,$na2,$na3,$na4,$na5,$na6,$na7,@head) = split(/\s+/,$head);
while(<SNP>){
    chomp;
    my ($snp_id,$geno,$chr,$pos) = split;
    $hash_snp{"$chr\t$pos"}->{"snp"}++;
}
close SNP;  print "Done!!! Reading the hapmap file\n";

open POS,$ge_pos or die "$!";   print "Starting searching SNPs for each gene\n";
my $flag = 0;
while(<POS>){
    chomp;
    ++$flag;
    $date = `date`;
    print "$flag has done\n$date" if $flag%100 ==0;
    my ($chr,$stt,$end,$gene,$strand) = split;
    next if ($end - $stt + 1 < 500 || $end - $stt + 1 > 10000);
    $chr = "chr".$chr if $chr !~ /chr/;
    next if $chr !~ /\d+/;
    my $mid = int(($stt+$end)/2);
    my $nu = 0;
    for(my $i = $mid; $nu < 30; --$i){
        if($i <= 0){
            print "$gene: SNP number is not enough\n";
            last;
        }
        next if !exists $hash_snp{"$chr\t$i"};
        $hash_snp{"$chr\t$i"}->{$gene}++;
        ++ $nu;
    }
       $nu = 0;
    for(my $i = $mid+1; $nu < 30; ++$i){
        last if $i > $geno_len{$chr};
        next if !exists $hash_snp{"$chr\t$i"};
        $hash_snp{"$chr\t$i"}->{$gene}++;
        ++ $nu;
    }
}
close SNP;  print "Done\n";

open OUT,"+>$out" or die "$!";
open SNP,$hapmap or die "$!";   print "Starting get the genotype of genes!!! GOOOO!!!\n";
    $head = <SNP>;
my %hash_gene_geno;
while(<SNP>){
    chomp;
    ### snp_chr1_176211660      G/A     chr1    176211660       NA      NA      NA      NA      NA      NA      NA
    my ($snp_id,$geno,$chr,$pos,$na1,$na2,$na3,$na4,$na5,$na6,$na7,@geno) = split;
    my $geno_hap = join("\t",@geno);
       $geno_hap =~ s/AA/1/g;
       $geno_hap =~ s/CC/2/g;
       $geno_hap =~ s/GG/3/g;
       $geno_hap =~ s/TT/4/g;
    my @gene = keys %{$hash_snp{"$chr\t$pos"}};
    my $gene_nu = @gene;
    if($gene_nu > 1){
        foreach my $ge_name(@gene){
             next if $ge_name eq "snp";
             $hash_gene_geno{$ge_name} -> {$pos} = $geno_hap;
        }
    }else{
        delete $hash_snp{"$chr\t$pos"};
    }    
}
close SNP;    print "Done !!!  get the genotype of genes!!!\n";
foreach my $tem_name(keys %hash_gene_geno){
    my @pos = sort {$a<=>$b} keys %{$hash_gene_geno{$tem_name}};
    my $snp_nu = @pos;
    my %hash_inbred_snp;
    foreach my $pos (@pos){
         my @geno_tem = split(/\t/,$hash_gene_geno{$tem_name} -> {$pos});
         for(my $i = 0;$i< @head;++$i){
             push @{$hash_inbred_snp{$head[$i]}}, $geno_tem[$i];
         }
    }
    for(my $i = 0;$i< @head;++$i){
        my $tem_geno = join("\t",@{$hash_inbred_snp{$head[$i]}});
        print OUT "$tem_name\t$head[$i]\t$tem_geno\n";
    }
}
   $date = `date`;
print "End at : $date\n";

close SNP;
sub usage{
    my $die=<<DIE;
    print *.pl <Gene pos> <Hapmap> <Genome length> <OUT>
DIE
}
