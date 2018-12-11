#!/usr/bin/perl -w
open R, "$ARGV[0]";
$ll=join'',<R>;
close R;
@aa=split/Query sequence\:/,$ll;
splice(@aa,0,1);

foreach $tm (@aa)
{@fen=split/\n/,$tm;
 if($fen[7]=~/$ARGV[1]/)
 {@cut=split/\s+/,$fen[7];
 # $fen[0]=~s/s+//g;
  splice(@cut,0,1);
  $pp="@cut";
  print "$fen[0]\n$pp\n";
 }
}

