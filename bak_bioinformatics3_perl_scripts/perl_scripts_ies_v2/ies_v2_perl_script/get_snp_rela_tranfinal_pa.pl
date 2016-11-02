#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl <SNP><SEQ>" unless @ARGV==2;
#open SNP,$ARGV[0] or die;
open SEQ,$ARGV[1] or die;
print "Transcripts\tChr\tSNP_relative_position\tBM_B\tBM_M\tMB_B\t\tMB_M\tPcalueBM\t\tPvalueMB\tstart\tend\tpat_biasBM\tpat_biasMB\t>2:1\t>5:1\tsnp\n";
my $snp;
my $seqn;
while($seqn=<SEQ>){
     chomp $seqn;
     my ($chr_seq,$up,$down)=(split(/_/,$seqn))[1,2,3];
#     print "$chr_seq\n";
     my $seq=<SEQ>;
     open SNP,$ARGV[0] or die;
     while ($snp=<SNP>){
         chomp $snp;
         my ($chr,$pos,$b73_ma,$b73_mnu,$mo_pa,$mo_pnu,$b73_pa,$b73_pnu,$mo_ma,$mo_mnu,$pvalue1,$pvalue2)=(split(/\s+/,$snp))[0,1,2,3,4,5,6,7,8,9,10,11];
         if($chr ne $chr_seq){
#             print "here\n";
             next;       
         }elsif($pos>=$up && $pos<=$down){
             my $pos_relative=$pos-$up+1;        
             my $bias1=$mo_pnu/($b73_mnu+$mo_pnu);
             my $bias2=$b73_pnu/($mo_mnu+$b73_pnu);
             my @array=(0);
             @array=($seqn,$chr_seq,$pos_relative,$b73_mnu,$mo_pnu,$b73_pnu,$mo_mnu,$pvalue1,$pvalue2,$up,$down,$bias1,$bias2);
             if($b73_mnu/($b73_mnu+$mo_pnu)>=2/3 && $mo_mnu/($b73_pnu+$mo_mnu)>=2/3){
                 push (@array,"mat");
              }elsif($mo_pnu/($b73_mnu+$mo_pnu)>=1/3 && $b73_pnu/($b73_pnu+$mo_mnu)>=1/3){
                 push (@array,"pat");
              }else{
                 push (@array,"NA");
              }
             if($b73_mnu/($b73_mnu+$mo_pnu)>=10/11 && $mo_mnu/($b73_pnu+$mo_mnu)>=10/11){
                 push (@array,"mat");
              }elsif($mo_pnu/($b73_mnu+$mo_pnu)>=5/7 && $b73_pnu/($b73_pnu+$mo_mnu)>=5/7){
                 push (@array,"pat");
              }else{
                 push (@array,"NA");
              }

              push(@array,"$b73_ma\/$mo_pa");
              my $final=join("\t",@array);
              print "$final\n";
 
         }else{
             next;
         }
    }
}
close SEQ;
close SNP;
