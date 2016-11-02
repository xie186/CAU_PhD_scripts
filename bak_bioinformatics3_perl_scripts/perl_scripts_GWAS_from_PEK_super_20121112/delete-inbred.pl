#!/usr/bin/perl -w
#perl delete-inbred.pl [the file of vcf] [the file of the name to delete]
open T, "$ARGV[1]";
while (<T>)
{chomp($_);
 $name{$_}='';
}
close T;

open R, "$ARGV[0]";
$i=0;
while (<R>)
{if($i==0)
 {@fen=split/\s+/,$_;
  $nn=@fen;
  for($j=0;$j<$nn;$j++)
  {if(exists $name{$fen[$j]})
   {$site{$j}='';}
   else
   {print "$fen[$j]\t";}
  }
  print "\n";
 }
 else
 {@fen=split/\s+/,$_;
  $nn=@fen;
  for($j=0;$j<$nn;$j++)
  {if(exists $site{$j})
   {}
  else
  {print "$fen[$j]\t";}
  }
 print "\n";
}

$i++;
}

