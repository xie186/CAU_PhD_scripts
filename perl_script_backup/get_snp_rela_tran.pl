#!/usr/bin/perl -w
use strict;

die "Usage:perl *.pl <SNP><SEQ><RAWSNP>" unless @ARGV==3;

#open SNP,$ARGV[0] or die;
open SEQ,$ARGV[1] or die;
print "Transcripts\tChromo\tSNP_relative_position\tSNP\tBM_B\t\tBM_M\t\tMB_B\t\tMB_M\t\tIM_or_NOT\n";

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
         my ($chr,$pos,$b73_ma,$b73_mnu,$mo_pa,$mo_pnu,$b73_pa,$b73_pnu,$mo_ma,$mo_mnu)=(split(/\s+/,$snp))[0,1,2,3,4,5,6,7,8,9];
         if($chr ne $chr_seq){
#             print "here\n";
             next;       
         }elsif($pos>=$up && $pos<=$down){
             my $pos_relative=$pos-$up+1;        
             open RAWSNP,$ARGV[2] or die;
             my $refbase;
             while(my $raw=<RAWSNP>){
                 chomp $raw;
                 my ($refchr,$refpos,$base)=(split(/\s+/,$raw))[0,1,2];
                 if($refchr eq $chr && $refpos == $pos){
                     $refbase=$base; 
                 }else{
                     next;
                 }
             } 
             my @array=($seqn,$chr_seq,$pos_relative,"$refbase\/$b73_ma\/$mo_pa",$b73_ma,$b73_mnu,$mo_pa,$mo_pnu,$b73_pa,$b73_pnu,$mo_ma,$mo_mnu);
             if($b73_mnu/($b73_mnu+$mo_pnu)>=10/11 && $mo_mnu/($b73_pnu+$mo_mnu)>=10/11){
                 push (@array,"Maternal");
              }elsif($mo_pnu/($b73_mnu+$mo_pnu)>=5/7 && $b73_pnu/($b73_pnu+$mo_mnu)>=5/7){
                 push (@array,"Paternal");
              }else{
                 push (@array,"Noimprinting");
              }
              my $final=join("\t",@array);
              print "$final\n";
             next;
         }else{
             next;
         }
 
    }
}

close SEQ;
close SNP;
