#/usr/bin/perl -w
#$ARGV[0]=the vcf file without imputation  $ARGV[1]=the beagle imputation file
open T , "$ARGV[0]";
open H, "+>$ARGV[0].imputed.vcf";
$n=0;
while (<T>)
{if($n==0)
 {print H "$_";}
 else
 {@ff=split/\s+/,$_;
  $hh="$ff[0]"."\t"."$ff[1]"."\t"."$ff[2]";
  $header{$n}=$hh;
 }
$n++;
}

open R, "zcat $ARGV[1]|";
$n=0;
while (<R>)
{if($n>0)
 {print H "$header{$n}";
  @fen=split/\s+/,$_;
  $nn=@fen;
  for($j=2;$j<$nn;$j+=2)
  {print H "\t$fen[$j]";}
 print H "\n";
 }
 $n++;
}
