#!/usr/bin/perl -w

die usage() unless @ARGV == 4;
my ($jvcf, $mis_cut, $maf_cut, $jvcf_fil) = @ARGV;
my $vcf = $jvcf;
   $vcf = "zcat $jvcf|" if $vcf =~ /.gz$/;
open VCF,"$vcf" or die "$!";
open FIL,"+>$jvcf_fil" or die "$!";
my $header = <VCF>;
print FIL $header;
while(<VCF>){
    chomp;
    my ($chr,$pos,$alle,@geno) = split;
    my $snp_infor = join("\t",@geno);
    my ($mis_rate,$maf) = &maf($snp_infor);
    if ($mis_rate > $mis_cut || $maf < $maf_cut){
        print "$_\n";
    }else{
        print FIL "$_\n";
    }
}

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
    my ($max,$min) = sort{$b<=>$a} @base_nu;
    my $mis_rate = $mis / $tot;
    my $maf = 0;
       $maf = $min / ($tot -  $mis) if $tot -  $mis != 0;
#    print "$line\t$mis_rate, $maf\t$max,$min\n";
    return ($mis_rate,$maf);
}

sub usage{
    my $die = <<DIE;
    perl *.pl <jvcf> <missing rate cutoff> <maf cutoff> <jvcf filter>
DIE
}
