#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
while(<F>) {
 chomp;
 my $fir=$_;
 $fir=~s/_/\t/g;
 @ss=split/\s+/,$fir;
 $sed=<F>;
 chomp($sed);
 $thr=<F>;
 chomp($thr);
 $thr=~s/_/\t/g;
 @dd=split/\s+/,$thr;
 $fou=<F>;
 chomp($fou);

 print O "$ss[0]_$ss[1]\t$ss[2]\t$ss[3]\t$dd[2]\t$dd[3]\n";
}
close F;
close O;
open I,"$ARGV[2]";
while(<I>) {
chomp;
$fir=$_;
$sed=<I>;
$hash{$fir}=$sed;
}
close I;
open O,"$ARGV[1]";
open P,"+>$ARGV[3]";

while(<O>) {
chomp;
 @mm=split;
 if(exists($hash{$mm[0]})) {
 chomp($hash{$mm[0]});
 $n=$mm[4]-$mm[1]+1+40;
 $seq=substr($hash{$mm[0]},$mm[1]+19,$n);
  print P "$mm[0]_$mm[1]_$mm[4]\n$seq\n";
}
}

