#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($gwas_dir,$out) = @ARGV;
my @gi = glob "$gwas_dir/GAPIT.TMP.GI.*.txt";
open E, "|sort -k1,1n -k2,2n >$out" or die "$!";
#open E, "+>$out" or die "$!";
#print E "chr\tposition\tmaf\tlog10(p_value)\n";

foreach my $gi (@gi){
   my $maf=$gi;
      $maf=~s/GI/maf/g;

   my $ps=$gi;
      $ps=~s/GI/ps/g;

   open MAF, "$maf" or die "$!";
   my  @maf=<MAF>;
   close MAF;

   open PS, "$ps";
   my @ps = <PS>;
     chomp @ps;
   close PS;

   open GI, "$gi";
   my $n=-1;  ## read the header

   while (<GI>){
       if($n>=0){
          my ($snp_id,$chr,$pos)=split(/\s+/,$_);
             $chr =~ s/chr//;
          chomp($maf[$n]);
          print "$gi\t$_" if $ps[$n] == 0;
          my $log = abs(log($ps[$n])/log(10));
             $log = sprintf "%0.2f",$log;
          print E  "$chr\t$pos\t$maf[$n]\t$log\n";
       }
       $n++;
   }
   close GI;
}

sub usage{
    print <<DIE;
    perl *.pl <GWAS res dir>  <OUT file p_log>
    cp /NAS2/jiaoyp/LD_block/tag_snp.GWAS/result/cat-result.pl /NAS1/zeamxie/perl_scripts_GWAS/cat_GWAS_result.pl
DIE
    exit 1;
}

