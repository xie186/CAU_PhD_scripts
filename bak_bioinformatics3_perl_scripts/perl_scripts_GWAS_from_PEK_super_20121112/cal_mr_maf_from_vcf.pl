#!/usr/bin/perl -w

die usage() unless @ARGV == 2;
my ($snp_vcf,$out) = @ARGV;
open R,$snp_vcf or die "$!";
<R>;
open OUT,"+>$out" or die "$!";
while (<R>){
    chomp;
        my ($chr,$pos,$ref,@geno) = split; # the third line is B73 reference
        my $snp_infor = join("\t",@geno);
        my ($mis_rate,$maf) = &maf($snp_infor);
#        next if ($mis_rate >= $mis_cut || $maf < $maf_cut);
        print OUT "$chr\t$pos\t$ref\t$mis_rate\t$maf\n";
}

sub maf{
    my ($snp_infor) = @_;
    my $tot_1 = $snp_infor =~ s/[ATGC]\/[ATGC]/0/g;
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
print <<REPORT;
Total line: $total_line;
Wrong line: $wrong_line;
Percentage: $wrong_line/$total_line;
REPORT

sub usage{
    print <<DIE;
    perl *.pl <SNP data> <real_278> <inbred_alias> <miss rate cut> <MAF cut> <OUT> 
    we use this to delete some inred lines in the snp data [/datastore/workspace/caulai/jiao/GWAS_2012_June/3_cat-snp/delete-inbred.pl]
DIE
    exit 1;
}
