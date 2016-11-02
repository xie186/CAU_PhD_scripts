#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($hap) = @ARGV;

open HAP,$hap or die "$!";
<HAP>;
while(<HAP>){
    chomp;
#    rs      alleles chrom   pos     strand  assembly        center  protLSID        assayLSID       panel   QCcode
    my ($rs,$allel,$chr,$pos,$strand,$assembly,$center,$protLSID,$assayLSID,$panel,$QCcode,@geno) = split;
    my $tem_geno = join("\t",@geno);
    my ($mis_rate,$maf) = &maf($tem_geno);
    print "$mis_rate\t$maf\n";
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
    my $die =<<DIE;
    perl *.pl <hapmap>
DIE
}
