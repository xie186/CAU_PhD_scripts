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
   $num=length($smRNA_RNAfold);
  my $smRNA_RNAfold_repair=<F>;
    chomp($smRNA_RNAfold_repair);
    $len=length($smRNA_RNAfold_repair);
    for($i=0;$i<=$num-1;$i++) {
       $temp=substr($smRNA_RNAfold,$i,$len);
    if($temp eq $smRNA_RNAfold_repair) {
       $sequence=substr($smRNA_sequence,$i,$len);
       $smRNA_RNAfold_repair=~s/R/\)/g;$smRNA_RNAfold_repair=~s/L/\(/g;
        print O "$smRNA_name\n$sequence\n$smRNA_RNAfold_repair\n";
     }
    }
}
