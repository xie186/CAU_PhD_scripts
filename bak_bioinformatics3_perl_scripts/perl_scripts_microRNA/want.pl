#!/usr/bin/perl -w
open F,"$ARGV[0]";
while(<F>) {
chomp;
 @ss=split;
 $hash{$ss[0]}=$_;
}
open I,"$ARGV[1]";
while(<I>) {
  chomp;
  @dd=split;
     if(exists($hash{$dd[0]})) {
     @ll=split/\s+/,$hash{$dd[0]};
 open O,"+>>$ll[0]_want";
       print O "$_\n";
}
}
open P,"+>>$ARGV[0]_sum";
open F,"$ARGV[0]";
  while(<F>) {
  chomp;
  my $fir=$_;
  @ss=split;
  my $sum=0;$max_sum=0;
  open K,"$ss[0]_want";
  while(<K>) {
   chomp;
   my $sed=$_;
   @kk=split/\s+/,$sed;
   @hh=split/;/,$kk[1];
   $sum+=$hh[1];
   if($kk[6]>=$ss[7]-4&&$kk[7]<=$ss[8]+4) {
    $max_sum+=$hh[1];
    }
}
    print P "$fir\t$max_sum\t$sum\n";
}

