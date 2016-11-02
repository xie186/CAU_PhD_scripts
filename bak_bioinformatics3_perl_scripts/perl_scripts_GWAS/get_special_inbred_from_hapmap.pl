#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($inbred_alias,$hap,$out) = @ARGV;
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
    my $tem_nu = @geno;
    print "xx:inbred ne head\t $inbred_nu\t$tem_nu\n" if $inbred_nu != @geno;
    for(my $i= 0; $i< @head; ++ $i){
         push @tem_geno,  $geno[$i] if exists $hash_inbred{$head[$i]};
    }
    my $tar = join("\t",@tem_geno);
    print OUT "$tar\n";
}

sub usage{
    print <<DIE;
    perl *.pl <Inbred alias> <HAPMAP file>  <OUT hapmap>
DIE
    exit 1;
}
