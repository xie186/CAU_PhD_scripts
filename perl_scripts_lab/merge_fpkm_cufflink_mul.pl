#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($cuff_file, $context) = @ARGV;

my @cuff = split(/,/,$cuff_file);
my $tis_num = @cuff;
my @tis = split(/,/, $context);
my %hash_fpkm;
my %hash_exp_sum;
my %hash_unexp;
$context =~s/,/\t/g;
foreach my $cuff(@cuff){
    open CUFF,"./$cuff/genes.fpkm_tracking" or die "$!";
    my %tem_fpkm;
    while(my $line = <CUFF>){
        #tracking_id     class_code      nearest_ref_id  gene_id gene_short_name tss_id  locus   length  coverage        FPKM    FPKM_conf_lo    FPKM_conf_hi    FPKM_status
        next if $line =~ /tracking_id/;
        my ($gene,$fpkm) = (split(/\s+/,$line))[0,9];
#        print "$id\t$fpkm\n";
#           $hash_fpkm_sum{$gene} += $fpkm;
#           $hash_exp_sum{$gene} ++ if $fpkm > 1;    #assure there is at least one gene with FPKM greater than 1;
#	    $hash_unexp{$gene} ++ if $fpkm == 0;
          # $fpkm += 0.000000001 if $fpkm==0;
        $tem_fpkm{$gene} += $fpkm;
#        push @{$hash_fpkm{$gene}},$fpkm;
    }
    foreach my $gene(keys %tem_fpkm){
#        push @{$hash_fpkm{$gene}},log($tem_fpkm{$gene})/log(2);
        push @{$hash_fpkm{$gene}}, $tem_fpkm{$gene};
    }
}
my $tis = join("\t", @tis);
print "gene_id\t@tis\n";
foreach(sort keys %hash_fpkm){
#    next if (!exists $hash_exp_sum{$_} || exists $hash_unexp{$_});
#    next if (!exists $hash_exp_sum{$_} || $hash_exp_sum{$_} == 0);
    my $fpkm = join("\t", @{$hash_fpkm{$_}});
    print "$_\t$fpkm\n";
}

sub usage{
    my $die = <<DIE;
    perl *.pl <cufflinks[rep1,rep2]> <lib>
DIE
}
