#!/usr/bin/perl -w
###this script is usd to convert the PLINk generated IBS metrix to phylip format
###$ARGv[0]=plink.mdist $ARGV[1]=the ped file 
die usage() unless @ARGV==2;
my ($ibs_matrix,$name) = @ARGV;
my $num = 0;
my  @inbred_name;
open NAME, $name or die "$!";
while (<NAME>){
    my ($fam,$inbred) = split(/\t/,$_);
    push @inbred_name,$inbred;
    ++$num;
}
close NAME;
print "$num\n";

open T, "$ibs_matrix" or die "$!";
my $i = 0;
while (<T>){
    my @matrix = split(/\s+/,$_);
    for(my $j =0;$j<@matrix;++$j){
        $matrix[$j] = sprintf "%0.6f",$matrix[$j]; 
    }
    my $matrix = join(" ",@matrix);
    print "$inbred_name[$i]        $matrix\n";
    $i++;
}
close T;
sub usage{
    print <<DIE;
    perl .pl <plink IBS metrix> <Name>
    cp  /NAS2/jiaoyp/GWAS/bin/plink2phylip.pl  /NAS1/zeamxie/perl_scripts_GWAS/plink2phylip.pl
DIE
   exit 1;
}
