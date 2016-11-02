#!/usr/bin/perl 
  open(FHIN,"<$ARGV[0]");
  open(FHOU,"+>$ARGV[1]");
  while(my $string=<FHIN>)
    {
      chomp $string;
      my @array=split(/\s+/,$string);
      my $name=shift @array;
      my $sum=0;
      my $shannon=0;
      my $stat=0;
      for(my $num=0;$num<@array;$num++)
        {
          if($array[$num]>=1)
            {
              $stat=1;
              last;
            }
        }
      if($stat==1)
        {   
          for(my $num=0;$num<@array;$num++)
        {
          $sum+=$array[$num];
        }
      if($sum!=0)
        {
         # print "sum is $sum\n";
          for(my $num=0;$num<@array;$num++)
            {
              if($array[$num]==0)
                {
                  $shannon+=0;
                }
              else
                {
                   my $p=$array[$num]/$sum;
                   my $my_shannon=-((log($p))*$p/(log 2));
                   $shannon+=$my_shannon;
                }
            }
          my $whole=$string."	".$shannon;
          print FHOU "$whole\n";
        }
     }
     }
   close FHIN;
   close FHOU;   
