#!usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
open GENOME,$ARGV[0] or die;
my @aa = <GENOME>;
my $seq = join('',@aa);
@aa = split />/,$seq;
shift @aa;
my %hash_chrseq;
foreach(@aa){
   my @ss = split /\n/,$_;
   my $chr = shift @ss;
   my $chrseq = join('',@ss);
   $hash_chrseq{$chr} = $chrseq;
}
open BED,$ARGV[1] or die "$!";
my ($hcg,$gcg,$cgh)=(0,0,0);
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev) =split;
    my $result = substr($hash_chrseq{$chr},$stt-1,3);
    print "$result\n";
    ++$hcg if $result =~/[A|T|C]CG/;
    ++$gcg if $result =~/GCG/;
    ++$cgh if $result =~/GC[A|T|C]/;
}
print "$hcg\t$gcg\t$cgh\n";
sub usage{
   my $die = <<DIE;
   usage:perl *.pl <GENOME> <BED>
DIE
}
