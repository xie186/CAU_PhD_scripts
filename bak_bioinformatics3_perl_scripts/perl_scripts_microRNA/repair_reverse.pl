#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
  while(<F>) {
  chomp;
  my $smRNA_name=$_;
  my $smRNA_sequence=<F>;
  chomp($smRNA_sequence);
  my $smRNA_RNAfold=<F>;
  chomp($smRNA_RNAfold);
  
  @ss=split/\s+/,$smRNA_RNAfold;
  $ss[0]=~s/\.+$//g;
  $ss[0]=~s/^\.+//g;
  $len=length($ss[0]);
  if($len>=60) {
  print O "$smRNA_name\n$smRNA_sequence\n$smRNA_RNAfold\n$ss[0]\t$ss[1]\t$ss[2]\n";
}
}


