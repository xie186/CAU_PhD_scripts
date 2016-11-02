#!/usr/bin/perl -w
use strict;
  die ("perl calculate_Z-score_of_every_gene_expression.pl <inf_of_rpkm_of_23_tissue> <out_of_gene-name_of_tissue-specific> <Z-score_cutoff>") unless @ARGV==3; 
  open(FHIN,"<$ARGV[0]");
  open(FHOU1,"+>$ARGV[1]");
 # open(FHOU2,"+>$ARGV[2]");
  my %hash;
  while(my $string=<FHIN>)
    {
      chomp $string;
    #  print "$string\n";
    #  sleep(2);iiii
      my @array=split(/\t/,$string);
    #  print "$array[1]\n";
    #  sleep(2);
      my $name_gene=shift @array;
    #  print "$name_gene\n";
    #  sleep(2);
      my $sum=0;
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
              $array[$num]=log($array[$num]+1)/(log(2));
              #  print "$array[$num]\n";
              #  sleep(2);
            }
          for(my $num=0;$num<@array;$num++)
            {
              $sum=$sum+$array[$num];
            }
          my $mean=$sum/(@array);
  #        print "mean is $mean\tsum is $sum\n";
  #        sleep(2);
          my $sum_R=0;
          for(my $num=0;$num<@array;$num++)
            {
              $sum_R=$sum_R+($array[$num]-$mean)*($array[$num]-$mean);
            }
          my $sd=sqrt($sum_R/(@array-1));
          for(my $num=0;$num<@array;$num++)
            {
              my $n=($array[$num]-$mean)/$sd;
              if($n>=$ARGV[2])
                {
              #    print FHOU2 "$string\n";
                  if(exists($hash{$num}))
                    {
                   #   print "$string\n";
                      $hash{$num}=$hash{$num}."\n".$string;
       #               print "$num => $hash{$num}\n";
       #               sleep(2);
                    }
                  else
                    {
                      $hash{$num}=$string;
                  #    print "$hash{$num}\n";
                  #    sleep(2);
                    }
                }
            }
         }
       }
       
      foreach my $key (sort {$a<=>$b} keys %hash)
        {
         my $key_1=$key+1;
          print FHOU1 "$key_1\n";
          my @array=split(/\n/,$hash{$key});
          foreach (@array)
            {
              print FHOU1 "\t$_\n";
            }
        }
     close FHIN;
     close FHOU1;
   #  close FHOU2;
