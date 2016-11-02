#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($input, $context) = @ARGV;
my @input = split(/,/, $input);
my @context = split(/,/, $context);

my $num_input = @input;
my $num_context = @context;

my @ele = ("Intergenic", "Downstream", "Upstream", "Intron", "Exon", "Transposon");
my $ele = join("\t", @ele);
print "\t$ele\n";
for(my $i = 0;$i < $num_input; ++ $i){
   open IN, $input[$i] or die "$!";
   my %hash_pro;
   while(<IN>){
       chomp;
       my ($ele, $num, $pro) = split(/\t/, $_);
       $hash_pro{$ele} = $pro;
   }
   my $join_pro = join("\t", @hash_pro{@ele});
   print "$context[$i]\t$join_pro\n";

}

sub usage{
    my $die =<<DIE;
    perl *.pl <input> <context> 
DIE
}
