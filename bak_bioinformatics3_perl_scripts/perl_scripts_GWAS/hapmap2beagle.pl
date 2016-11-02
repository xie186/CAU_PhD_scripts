#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($hap,$bgl) = @ARGV;
open HAP,$hap or die "$!";
my $head = <HAP>;
chomp $head;
my @head = split(/\s+/,$head);
splice(@head,0,11);
my $tem_head = join("\t",@head);
#print "I\tid\t$tem_head\n";
my $inbred_nu = @head;
my %hash_snp;
my $snp_nu = 1;
open BGL,"+>$bgl" or die "$!";
#print BGL "I\tid\t$tem_head\n";
while(<HAP>){
    chomp;
#    rs      alleles chrom   pos     strand  assembly        center  protLSID        assayLSID       panel   QCcode
    my ($rs,$allel,$chr,$pos,$strand,$assembly,$center,$protLSID,$assayLSID,$panel,$QCcode,@geno) = split;
#    print "$_\n" if @geno != 126;
    my $tem_geno = join("\t",@geno);
       $tem_geno =~ s/AA/A\tA/g;
       $tem_geno =~ s/TT/T\tT/g;
       $tem_geno =~ s/GG/G\tG/g;
       $tem_geno =~ s/CC/C\tC/g;
       $tem_geno =~ s/NN/?\t?/g;
    my @tem = split(/\t/,$tem_geno);
#    print "$_\n" if @tem != 252;
    print BGL "M\tsnp_$chr\_$pos\t$tem_geno\n";
}

sub  usage{
    print <<DIE;
    perl *.pl <HAPMAP file> <OUT bgl>
DIE
    exit 1;
}
