#!/usr/bin/perl -w
open F,$ARGV[0];
my %hash;
while(<F>) {
chomp;
@ss=split;
$one=">".$ss[1];
  $hash{$one}=$_;
 }
open I,$ARGV[1]; 
open O,"+>$ARGV[2]";
  while(<I>) {
  my $smRNA_name=$_;
  chomp($smRNA_name);
  my $smRNA_sequence=<I>;
  chomp($smRNA_sequence);
  if(exists($hash{$smRNA_name})) {
    print  "$smRNA_name\n$smRNA_sequence\n";
}else{print O "$smRNA_name\n$smRNA_sequence\n";}
}

