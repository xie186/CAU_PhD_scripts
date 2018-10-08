#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($ge_pos,$hapmap,$out_stat,$out) =@ARGV;

my $date = `date`;
print "Start at : $date\n";
print "Reading the hapmap file\n";
open SNP,$hapmap or die "$!";
my %hash_snp;
my $head = <SNP>;
chomp $head;
my ($snp_id,$geno,$chr,$pos,$na1,$na2,$na3,$na4,$na5,$na6,$na7,@head) = split(/\s+/,$head);
while(<SNP>){
    chomp;
    my ($snp_id,$geno,$chr,$pos,$na1,$na2,$na3,$na4,$na5,$na6,$na7,@geno) = split;
    my $tem_geno = join("\t",@geno);
       
    $hash_snp{"$chr\t$pos"} = $tem_geno;
}
close SNP;  print "Done!!! Reading the hapmap file\n";

open POS,$ge_pos or die "$!";   print "Starting searching SNPs for each gene\n";
open OUT,"+>$out" or die "$!";
open STAT,"+>$out_stat" or die "$!";
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
    my $snp_nu = 0;
    for(my $i = $stt;$i<=$end;++$i){
        print OUT "$gene\t$chr\t$i\t$hash_snp{\"$chr\t$i\"}\n" if exists $hash_snp{"$chr\t$i"};
        ++$snp_nu if exists $hash_snp{"$chr\t$i"};
    }
    my $gene_len = $end - $stt +1;
    print STAT "$gene\t$gene_len\t$snp_nu\n";
}
close SNP;  print "Done\n";
close OUT;

$date = `date`;
print "End at : $date\n";

close SNP;
sub usage{
    my $die=<<DIE;
    print *.pl <Gene pos> <Hapmap> <OUT stat> <OUT>
DIE
}
