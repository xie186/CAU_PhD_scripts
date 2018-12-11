# GET the cret5 seq 
#######################
#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl <CRET5FROM1<CRET1seq>\n" unless @ARGV==2;
open SNP,$ARGV[0] or die;
my %hash;
while(my $aa=<SNP>){
    my ($ies)=(split(/\s+/,$aa))[0];
    $hash{$ies}++;
}
close SNP;
#my $nu=keys(%hash);
#print "$nu\n";
open SEQ,$ARGV[1] or die;
while(my $bb=<SEQ>){
    my $seq=<SEQ>;
    chomp $bb;
    if(exists $hash{$bb}){
        print "$bb\n$seq";
    }
}
close SEQ;
