#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($snp,$map,$ped) = @ARGV;
open SNP,$snp or die "$!";
my $head = <SNP>;
chomp $head;
my ($tem_chr,$tem_pos,$tem_b73,@head) = split(/\s+/,$head); # delete the two row belong to chrom and pos
my $inbred_nu = @head;
my %hash_snp;
my $snp_nu = 0;
open MAP,"+>$map" or die "$!";
open PED,"+>$ped" or die "$!";
my $snp_wrong = 0;
my $snp_tot = 0;
while(<SNP>){
    chomp;
    ++ $snp_tot;
    next if !/^chr\d+/;
    my ($chr,$pos,$b73_ref,@inbred) = split(/\s+/); # the third line is B73 reference
    my $snp_infor = join("\t",@inbred);
    my ($mis_rate,$maf,$third_base) = &maf($snp_infor);
    if($third_base > 0){
        print "$_\n"; 
        next;
    }
    my $tem_chr = $chr;
       $tem_chr =~ s/chr//;
    print MAP "$tem_chr\t$chr\_$pos\t$pos\n";
    ++ $snp_nu;
    if($inbred_nu != @inbred){
	++ $snp_wrong;
        next;
    }
    for(my $i= 0; $i< $inbred_nu; ++ $i){
         push @{$hash_snp{$head[$i]}},  "$inbred[$i] $inbred[$i]";
#         print "$head[$i]\n";
    }
}

my $flag = 1; 
foreach(@head){
    my $snp_infor = join("\t",@{$hash_snp{$_}});
       $snp_infor =~ s/X/0/g;
       $snp_infor =~ tr/ACGTx/12340/;
    print PED "family$flag\t$_\t0\t0\t0\t0\t$snp_infor\n";
    ++ $flag;
}
close PED;

print <<REPORT;
=== $snp ===
Total number :$snp_tot;
Wrong number :$snp_wrong;
Percentage: $snp_tot/$snp_wrong;

REPORT

sub maf{
    my ($snp_infor) = @_;
    my $tot_1 = $snp_infor =~ s/X/0/g;
    my $tot_2 = $snp_infor =~ tr/ACGTx/12340/;
    my $tot = $tot_1 + $tot_2;
    my $mis = $snp_infor =~ tr/0/0/ || 0;
    my @base_nu;
       $base_nu[0] = $snp_infor =~ s/1/1/g || 0;
       $base_nu[1] = $snp_infor =~ s/2/2/g || 0;
       $base_nu[2] = $snp_infor =~ s/3/3/g || 0;
       $base_nu[3] = $snp_infor =~ s/4/4/g || 0;
    my ($max,$min,$third_base) = sort{$b<=>$a} @base_nu;
    my $mis_rate = $mis / $tot;
    my $maf = 0;
       $maf = $min / ($tot -  $mis) if $tot -  $mis != 0;
#    print "$line\t$mis_rate, $maf\t$max,$min\n";
    return ($mis_rate,$maf,$third_base);
}

sub  usage{
    print <<DIE;
    perl *.pl <SNP> <OUT map> <OUT ped>
DIE
    exit 1;
}
