#   mkdir bam_stat 
#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($exp, $candi) = @ARGV;

open CAND, $candi or die "$!";
my %cand;
while(<CAND>){
    chomp;
    my ($gene) = split;
    $cand{$gene} ++;    
}
open EXP, $exp or die "$!";
my $header = <EXP>;
chomp $header;
my ($tem1, $tem2, @acc) = split(/\t/, $header);
my @gene;
my %rec_exp;
while(<EXP>){
    chomp;
    my ($gene, $coor, @fpkm) = split;
    next if !exists $cand{$gene};
    push @gene, $gene;
    for(my $i =0; $i < @acc; ++$i){
        push @{$rec_exp{$acc[$i]}}, $fpkm[$i];
    }
}

my $gene = join(",", @gene);
print "ecotype_name,$gene\n";
foreach my $acc(keys %rec_exp){
    my $fpkm = join(",", @{$rec_exp{$acc}});
    print "$acc,$fpkm\n";
}
sub usage{
    my $die =<<DIE;
perl $0 <directory> <gene> 
DIE
}
