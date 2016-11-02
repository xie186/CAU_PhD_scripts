#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($vcf,$hap) = @ARGV;

open VCF,$vcf or die "$!";
open HAP,"+>$hap" or die "$!";
my $header = <VCF>;
my ($chr,$pos,$b73,@inbred) = split(/\t/,$header);
my $inbred = join("\t",@inbred);
print HAP "rs\talleles\tchrom\tpos\tstrand\tassembly\tcenter\tprotLSID\tassayLSID\tpanel\tQCcode\t$inbred";
while(<VCF>){
    chomp;
    my ($chr,$pos,$alle,@geno) = split;
    my $snp_infor = join("\t",@geno);
    my ($mis_rate,$maf,$third_alle) = &maf($snp_infor);
    if($third_alle != 0){
        print "$_\n";
        next;
    }
    my $geno = join("\t",@geno);
#       $geno =~ s/\w\/\w/NN/g;
       $geno =~ s/x/NN/gi;
       $geno =~ s/A/AA/g;
       $geno =~ s/T/TT/g;
       $geno =~ s/G/GG/g;
       $geno =~ s/C/CC/g;
    print HAP "$chr\_$pos\t$alle\t$chr\t$pos\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$geno\n";
}

sub maf{
    my ($snp_infor,$ref) = @_;
#    my $tot_1 = $snp_infor =~ s/[ATGC]\/[ATGC]/0/g;
    my $tot_1 = $snp_infor =~ s/X/0/g;
    my $tot_2 = $snp_infor =~ tr/ACGTx/12340/;
    my $tot = $tot_1 + $tot_2;
    my $mis = $snp_infor =~ tr/0/0/ || 0;
    my %base_nu;
       $base_nu{"A"} = $snp_infor =~ s/1/1/g || 0;
       $base_nu{"C"} = $snp_infor =~ s/2/2/g || 0;
       $base_nu{"G"} = $snp_infor =~ s/3/3/g || 0;
       $base_nu{"T"} = $snp_infor =~ s/4/4/g || 0;
    my ($max,$min,$third_alle) = sort{$b<=>$a} values %base_nu;
    my $mis_rate = $mis / $tot;
    my $maf = 0;
       $maf = $min / ($tot -  $mis) if $tot -  $mis != 0;
#    print "$line\t$mis_rate, $maf\t$max,$min\n";
    return ($mis_rate,$maf,$third_alle);
}

sub  usage{
    print <<DIE;
    perl *.pl <vcf file> <OUT hapmap>
DIE
    exit 1;
}
