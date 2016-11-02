#!/usr/bin/perl -w
use strict;
my ($htseq_file,$sam_name) = @ARGV;
die usage() unless @ARGV ==2;
$sam_name =~ s/,/\t/g;
print "gene_id\t$sam_name\n";

my @htseq_file = split(/,/,$htseq_file);
my %hash_count;
my %hash_count_sum;
foreach my $htseq(@htseq_file){
    open HT,$htseq or die "$!";
    while(my $line = <HT>){
        next if $line =~ /[no_feature|ambiguous|too_low_aQual|not_aligned|alignment_not_unique]/;
        my ($gene,$num) = split(/\t/,$line);
        push (@{$hash_count{$gene}} , $num + 1);
        $hash_count_sum{$gene} ++ if $num > 0;
    }
    close HT;
}

foreach(sort keys %hash_count){
    next if !exists $hash_count_sum{$_};
    my $count = join("\t",@{$hash_count{$_}});
    print "$_\t$count\n";
}


sub usage{
    my $die =<<DIE;
    perl *.pl <htseq_file[file1,file2]> <sample name[file1,file2]> 
DIE
}
