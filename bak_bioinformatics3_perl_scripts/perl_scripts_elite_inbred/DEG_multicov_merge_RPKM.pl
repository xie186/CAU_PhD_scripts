#!/usr/bin/perl -w
use strict;
my ($htseq_file,$sam_name) = @ARGV;
die usage() unless @ARGV ==2;
$sam_name =~ s/,/\t/g;
print "gene_id\t$sam_name\n";

my @htseq_file = split(/,/,$htseq_file);
my %hash_count;
my %hash_totol_read;
my %hash_gene_len;
my %hash_count_sum;

for(my $i = 0;$i < @htseq_file; ++$i){
    open HT,$htseq_file[$i] or die "$!";
    while(my $line = <HT>){
        chomp $line;
        next if $line !~ /^chr\d+/;
        my ($chr,$stt,$end,$gene,$strand,$num) = split(/\t/,$line);
        push (@{$hash_count{$gene}} , $num);
        $hash_totol_read{$i} += $num;
        $hash_gene_len{$gene} = $end - $stt + 1;
        $hash_count_sum{$gene} ++ if $num > 0;
    }
    close HT;
}

foreach(sort keys %hash_count){
    next if !exists $hash_count_sum{$_};
    for(my $i = 0; $i < @{$hash_count{$_}}; ++$i){
        $hash_count{$_}[$i] = $hash_count{$_}[$i] * 1000000000 / ($hash_gene_len{$_} * $hash_totol_read{$i});
    }
    my $count = join("\t",@{$hash_count{$_}});
    print "$_\t$count\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <mulCov_file[file1,file2]> <sample name[file1,file2]>
DIE
}
