#!usr/bin/perl -w
die usage() unless @ARGV == 3;
open BM,$ARGV[0] or die;
my %hash;
<BM>;
while(<BM>){
   my ($chr,$position,$B73numberC,$B73numberT,$Mo17numberC,$Mo17numberT) = split;
      $chr =~ s/Chr/chr/g;
   $hash{"$chr\t$position"} = "$B73numberC\t$B73numberT\t$Mo17numberC\t$Mo17numberT";
}

open MB,$ARGV[1] or die;
open SAMESITES,"+>$ARGV[2]" or die;
#print SAMESITES "chromosome\tposition\tBM-B73numberC\tBM-B73numberT\tBM-Mo17numberC\tBM-Mo17numberT\tMB-B73numberC\tMB-B73numberT\tMB-Mo17numberC\tMB-Mo17numberT\n";
#<MB>;
while(<MB>){
   my ($chr,$position,$B73numberC2,$B73numberT2,$Mo17numberC2,$Mo17numberT2) = split;
      $chr =~ s/Chr/chr/g;
   if(exists $hash{"$chr\t$position"}){
      my ($B73numberC1,$B73numberT1,$Mo17numberC1,$Mo17numberT1) = split /\s+/,$hash{"$chr\t$position"};
      print SAMESITES "$chr\t$position\t$B73numberC1\t$B73numberT1\t$Mo17numberC1\t$Mo17numberT1\t$B73numberC2\t$B73numberT2\t$Mo17numberC2\t$Mo17numberT2\n";
   }
}

sub usage{
   my $die = <<DIE;
   usage:perl *pl <BM> <MB> <SAMESITES>
DIE
}
