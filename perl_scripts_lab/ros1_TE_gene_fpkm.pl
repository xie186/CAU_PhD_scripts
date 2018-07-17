#   mkdir bam_stat 
#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($exp, $candi, $eco_meth) = @ARGV;

open EXP, $exp or die "$!";
my $header = <EXP>;
chomp $header;
my ($tem1, $tem2, @acc) = split(/\t/, $header);
my @gene;
my %rec_exp;
while(<EXP>){
    chomp;
    my ($gene, $coor, @fpkm) = split;
    next if $gene ne $candi;
    push @gene, $gene;
    for(my $i =0; $i < @acc; ++$i){
        $rec_exp{$acc[$i]} = $fpkm[$i];
    }
}
print "\tCG\tCHG\tCHH\tCXX\tFPKM\n";
open ECO, $eco_meth or die "$!";
while(<ECO>){
    chomp;
    my ($eco) = split;
    print "$_\t$rec_exp{$eco}\n";
}
sub usage{
    my $die =<<DIE;
perl $0 <gene> <candidate gene> <ecotype methlation> 
DIE
}
