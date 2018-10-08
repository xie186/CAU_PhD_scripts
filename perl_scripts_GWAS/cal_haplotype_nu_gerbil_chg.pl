#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($block,$gene) = @ARGV;

open BLOCK,$block or die "$!";
my @block = <BLOCK>; 
my $block_join = join('',@block);
   @block = split(/Multiallelic/,$block_join);
my $block_nu = 0;
my %hash_block_freq;
my %hash_block_haplo;
my %gene_haplo;
foreach(@block){
#    next if $_ !~ /\|/;
    my @line = split(/\n/,$_);
    shift @line if $block_nu >= 1;
    shift @line;
    foreach my $hap_line(@line){
        my ($haplo,$freq,$freq_both) = $hap_line =~ /(\d+)\s+\((.*)\)\s+\|(.*)\|/;
        if($_ =~ /\|/){
            my ($haplo,$freq,$freq_both) = $hap_line =~ /(\d+)\s+\((.*)\)\s+\|(.*)\|/;
            $hash_block_freq{$block_nu} -> {$haplo} = $freq_both;
            push @{$hash_block_haplo{$block_nu}} , $haplo;
        }else{
            my ($haplo,$freq) = $hap_line =~ /(\d+)\s+\((.*)\)/;
            push @{$hash_block_haplo{$block_nu}} , $haplo;
        }
        if($block_nu == 0){
            my ($haplo,$freq) = $hap_line =~ /(\d+)\s+\((.*)\)/;
            $gene_haplo{$block_nu-1} -> {$haplo} = $freq;
        }
    }
    ++$block_nu;
}

my @block_key = sort {$a<=>$b} keys %hash_block_haplo;
my $report = 0;
for(my $i = 0; $i < @block_key - 1;++$i){
    foreach my $haplo (@{$hash_block_haplo{$i}}){
        if($i == 0){
            my @freq = split(/\s+/,$hash_block_freq{$i} -> {$haplo});
            my @haplo_next = @{$hash_block_haplo{$i+1}};
            my $base_freq = $gene_haplo{$i-1} -> {$haplo};
          
            for(my $j = 0;$j<@freq;++$j){
                 $gene_haplo{$i} ->{"$haplo\t$haplo_next[$j]"} = $base_freq*$freq[$j];
            }
        }else{
            my @freq = split(/\s+/,$hash_block_freq{$i} -> {$haplo});
            my @haplo_pre = keys  %{$gene_haplo{$i-2}};
            my @haplo_next = @{$hash_block_haplo{$i+1}};
            for(my $j = 0;$j<@freq;++$j){
                next if $freq[$j] <= 0.02;
                foreach my $keys_hap(@haplo_pre){
                    my $freq_pre = $gene_haplo{$i-1} ->{"$keys_hap\t$haplo"};
                    print "$keys_hap\txxx$haplo\txx $freq_pre*$freq[$j]\n";
#                    $gene_haplo{$i} -> {"$keys_hap\t$haplo\t$haplo_next[$j]"} = $freq_pre*$freq[$j];
                }
            }
        }
    }
}

my @keys_gene_haplo = sort{$b<=>$a} keys %gene_haplo;
foreach(keys %{$gene_haplo{$keys_gene_haplo[0]}}){
    my $tem_freq = $gene_haplo{$keys_gene_haplo[0]}->{$_};
    print "$gene\t$_\t$tem_freq\n";
}

sub usage{
    my $die= <<DIE;
    perl *.pl <block> <Gene>
DIE
}
