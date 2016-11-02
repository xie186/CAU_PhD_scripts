#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[0]_75_percent";
while(<F>) {
chomp;
 my $fir=$_;
 @ss=split/\s+/,$fir;
open I,"$ARGV[1]";
while(<I>) {
  chomp;
  my $sed=$_;
  @dd=split/\s+/,$sed;
   if($dd[0] eq $ss[0]) {
     @kk=split/;/,$dd[1];
     $sum+=$kk[1];
      if($dd[7]>=$ss[7]-4&&$dd[8]<=$ss[8]+4) {
        $max_sum+=$kk[1];
        }
     }
 }
   print O "$fir\t$sum\t$max_sum\n";
}

