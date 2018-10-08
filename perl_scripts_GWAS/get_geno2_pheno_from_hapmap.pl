#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($pheno,$hapmap) = @ARGV;
open PHE,$pheno or die "$!";
<PHE>;
my %hash_phe;
while(<PHE>){
    chomp;
    my ($inbred, $phe) = split;
    $hash_phe{$inbred} = $phe;
}
open HAP,$hapmap or die "$!";
my $head = <HAP>;
chomp $head;
my @head = split(/\s+/,$head);
foreach(1..11){
    shift @head;
}

my $inbred_nu = @head;
while(<HAP>){
    chomp;
    my ($rs,$allel,$chr,$pos,$strand,$assembly,$center,$protLSID,$assayLSID,$panel,$QCcode,@inbred) = split;
    my ($alle1,$alle2) = $allel =~ /(.*)\/(.*)/;
    my ($phe1_1,$phe1_2,$phe2_1,$phe2_2)  = (0,0,0,0);
    my %hash;
    for(my $i = 0;$i< $inbred_nu; ++$i){
        my $geno = $inbred[$i];
        if($geno =~ /$alle1/){
            if($hash_phe{$head[$i]} ne "NaN"){
                $hash{$alle1} -> {$hash_phe{$head[$i]}} ++;
            }
        }else{
            if($hash_phe{$head[$i]} ne "NaN"){
                $hash{$alle2} -> {$hash_phe{$head[$i]}} ++;
            }
        }
    }
#    my @keys1 = sort {$hash{$alle1}->{$a}<=>$hash{$alle1}->{$b}} keys %{$hash{$alle1}};
#    my @keys2 = sort {$hash{$alle2}->{$a}<=>$hash{$alle2}->{$b}} keys %{$hash{$alle2}};
#    my @val1 = sort {$a<=>$b} values %{$hash{$alle1}};
#    my @val2 = sort {$a<=>$b} values %{$hash{$alle2}};
    my @keys1 = keys %{$hash{$alle1}};
    my @keys2 = keys %{$hash{$alle2}};
    my @val1 = values %{$hash{$alle1}};
    my @val2 = values %{$hash{$alle2}};
    print "$chr\t$pos\t@keys1\t@val1\t@keys2\t@val2\n";
}
sub usage{
    my $die =<<DIE;
    perl *.pl <pheno> <hapmap> 
DIE
}
