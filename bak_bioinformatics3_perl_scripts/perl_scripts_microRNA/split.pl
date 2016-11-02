#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
while(<F>) {
$n=0;
$m=0;
$p=0;
$q=0;
  chomp;
  my $smRNA_name=$_;
  my $smRNA_sequence=<F>;
  chomp($smRNA_sequence);
  my $smRNA_RNAfold=<F>;
  chomp($smRNA_RNAfold);
  my $smRNA_RNAfold_repair=<F>;
  $smRNA_RNAfold_repair=~s/RL/R\tL/g;
  $smRNA_RNAfold_repair=~s/R\.+L/R\tL/g;
  @ss=split/\s+/,$smRNA_RNAfold_repair;
  $n=@ss;
  foreach $tm(@ss) {
   chomp($tm);
   $m++;
   $p=0;$q=0;
   $smRNA_name.="_$m";
   $len=length($tm);
    if($len>=40) {
      for($i=0;$i<=$len-1;$i++) {
        if(substr($tm,$i,1)=~/L/) {$p++;}
        if(substr($tm,$i,1)=~/R/) {$q++;}
          }
          if($p==$q) {
   print O "$smRNA_name\n$smRNA_sequence\n$smRNA_RNAfold\n$tm\n";    
          }
}
}  

}
