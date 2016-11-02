#!/usr/bin/perl -w
###this script is usd to convert the PLINk generated IBS metrix to phylip format
###$ARGv[0]=plink.mdist $ARGV[1]=the ped file
die usage() unless @ARGV==2;
my ($ibs_matrix,$ped) = @ARGV;

my $num = 0;
my  @inbred_name;
open ALIAS, $ped or die "$!";
while (<ALIAS>){
    my ($fam,$tem_alias) = split(/\t/,$_);
    ++$num;
}
close ALIAS;
print "$num\n";

my $i = 1000;
open T, "$ibs_matrix" or die "$!";
while (<T>){
    my @matrix = split(/\s+/,$_);
    for(my $j =0;$j<@matrix;++$j){
        $matrix[$j] = sprintf "%0.6f",$matrix[$j];
    }
    my $matrix = join(" ",@matrix);
    print "xie$i        $matrix\n";
#    print "$inbred_name[$i]        $_";   
    $i++;
}
close T;
sub usage{
    print <<DIE;
    perl .pl <plink IBS metrix> <Inbred line pedgree file>
    cp  /NAS2/jiaoyp/GWAS/bin/plink2phylip.pl  /NAS1/zeamxie/perl_scripts_GWAS/plink2phylip.pl
DIE
   exit 1;
}

