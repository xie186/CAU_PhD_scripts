#####################################################
# To find the microRNAs that are in seed and leaf
#####################################################
#!/use/bin/perl -w
use strict;
die "Usage:perl *.pl <leaf><seed><BOTH>" unless @ARGV==3;
my %leaf;
my %seed;
open LEAF,$ARGV[0] or die;
while(my $aa=<LEAF>){
   # print "xxx\n";
    chomp $aa;
    my ($leaf_nm,$leaf_nu)=(split(/\s+/,$aa))[0,1];
    my $leaf_seq=<LEAF>;
    $leaf{$leaf_seq}+=$leaf_nu;
}
close LEAF;

open SEED,$ARGV[1] or die;
while(my $bb=<SEED>){
    chomp $bb;
    my ($seed_nm,$seed_nu)=(split(/\s+/,$bb))[0,1];
    my $seed_seq=<SEED>;
 #   print "$seed_seq\t$seed_nu\n";
    $seed{$seed_seq}+=$seed_nu;
 #   print "$seed{$seed_seq}\n";
}
close SEED;

open BOTH,"+>>$ARGV[2]";
print BOTH "seq\tLeafTotalNumber\tSeedTotalNumber\n";
my $cc;
foreach $cc(keys(%seed)){
 #   print "$cc"; 
    if(exists $leaf{$cc}){
        my $leaf_totnu=$leaf{$cc};
        my $seed_tolnu=$seed{$cc};
        chomp $cc;
        print BOTH "$cc\t$leaf_totnu\t$seed_tolnu\n";
    }
}
close BOTH;
