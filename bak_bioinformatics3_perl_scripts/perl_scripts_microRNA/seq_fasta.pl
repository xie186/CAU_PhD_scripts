open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
while(<F>) {
  chomp;
  my $smRNA_name=$_;
  my $smRNA_sequence=<F>;
  chomp($smRNA_sequence);
  my $smRNA_RNAfold=<F>;
  chomp($smRNA_RNAfold);
   print O "$smRNA_name\n$smRNA_sequence\n";

}

