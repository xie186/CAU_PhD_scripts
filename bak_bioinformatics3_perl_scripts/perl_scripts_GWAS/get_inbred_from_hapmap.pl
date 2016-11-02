#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==5;
my ($inbred_alias,$hap,$miss_cut,$maf_cut,$out) = @ARGV;
open ALIAS,$inbred_alias or die "$!";
my %hash_inbred;
my %hash_test;
while(<ALIAS>){
    chomp;
    my ($group,$alias,$inbred,$depth) = split;
    $hash_inbred{$alias} ++;
    $hash_test{$alias} ++;
}

open HAP,$hap or die "$!";
open OUT,"+>$out" or die "$!";
my $head = <HAP>;
chomp $head;
my @head = split(/\s+/,$head);
my @tem_head;
foreach(1..11){
    my $tem_head = shift @head;
    push @tem_head, $tem_head;
}
foreach(@head){
    push @tem_head, $_ if exists $hash_inbred{$_};
    delete $hash_test{$_} if exists $hash_inbred{$_};
}

foreach(keys %hash_test){
    print "$_\n";
}

my $tem_head = join("\t",@tem_head);
print OUT "$tem_head\n";
my $inbred_nu = @head;
my $snp_nu = 1;
while(<HAP>){
    chomp;
#    rs      alleles chrom   pos     strand  assembly        center  protLSID        assayLSID       panel   QCcode
    my ($rs,$allel,$chr,$pos,$strand,$assembly,$center,$protLSID,$assayLSID,$panel,$QCcode,@geno) = split;
    my @tem_geno;
       push @tem_geno,($rs,$allel,$chr,$pos,$strand,$assembly,$center,$protLSID,$assayLSID,$panel,$QCcode);
    ++ $snp_nu;
    print "xx:inbred ne head\n" if $inbred_nu != @geno;
    my @tem_geno_maf;
    for(my $i= 0; $i< @head; ++ $i){
         push @tem_geno,  $geno[$i] if exists $hash_inbred{$head[$i]};
         push @tem_geno_maf,  $geno[$i] if exists $hash_inbred{$head[$i]};
    }
    my $tem_geno = join("\t",@tem_geno_maf);
    my ($mis_rate,$maf) = &maf($tem_geno);
    next if ($mis_rate > $miss_cut || $maf < $maf_cut);
    my $tar = join("\t",@tem_geno);
    print OUT "$tar\n";
}

sub maf{
    my ($snp_infor) = @_;
#    my $tot_1 = $snp_infor =~ s/[ATGC]\/[ATGC]/0/g;
    my $tot = $snp_infor =~ tr/ACGTN/12340/;
    my $mis = $snp_infor =~ tr/0/0/ || 0;
    my @base_nu;
       $base_nu[0] = $snp_infor =~ s/1/1/g || 0;
       $base_nu[1] = $snp_infor =~ s/2/2/g || 0;
       $base_nu[2] = $snp_infor =~ s/3/3/g || 0;
       $base_nu[3] = $snp_infor =~ s/4/4/g || 0;
    my ($max,$min) = sort{$b<=>$a} @base_nu;
    my $mis_rate = $mis / $tot;
    my $maf = 0;
       $maf = $min / ($tot -  $mis) if $tot -  $mis != 0;
#    print "$line\t$mis_rate, $maf\t$max,$min\n";
    return ($mis_rate,$maf);
}

sub usage{
    print <<DIE;
    perl *.pl <Inbred alias> <HAPMAP file> <Missing rate cutoff> <maf cut> <OUT ped>
DIE
    exit 1;
}
