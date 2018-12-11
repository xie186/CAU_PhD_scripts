#####################################################
# To find the microRNAs that are only in seed or leaf
#####################################################
#!/use/bin/perl -w
use strict;
die "Usage:perl *.pl <leaf><seed><Onlyseed><Onlyleaf>" unless @ARGV==4;
my %leaf;
my %seed;
my $leafID_nu=0;
my $seedID_nu=0;
open LEAF,$ARGV[0] or die;
while(my $aa=<LEAF>){
    chomp $aa;
    my ($leaf_nm,$leaf_nu)=(split(/\s+/,$aa))[0,1];
    my $leaf_seq=<LEAF>;
    $leaf{$leaf_seq}+=$leaf_nu;
    $leafID_nu++;
}
close LEAF;

open SEED,$ARGV[1] or die;
while(my $bb=<SEED>){
    chomp $bb;
    my ($seed_nm,$seed_nu)=(split(/\s+/,$bb))[0,1];
    my $seed_seq=<SEED>;
    $seed{$seed_seq}+=$seed_nu;
    $seedID_nu++;
}
close SEED;
my $leafseq_nu=keys(%leaf);
my $seedseq_nu=keys(%seed);
print "leafID_nu\tseedID_nu\n$leafID_nu\t$seedID_nu\nleafseq_nu\tseedseq_nu\n$leafseq_nu\t$seedseq_nu\n";

open ONLYSEED,"+>>$ARGV[2]";
print ONLYSEED "seq\tSeedTotalNumber\n";
my $cc;
foreach $cc(keys(%seed)){
    if(exists $leaf{$cc}){
        next;
    }else{
        my $seed_tolnu=$seed{$cc};
        chomp $cc;
        print ONLYSEED "$cc\t$seed_tolnu\n";
    }
}
close ONLYSEED;

open ONLYLEAF,"+>>$ARGV[3]" or die;
print ONLYLEAF "seq\tLeafTotalNumber\n";
my $dd;
foreach $dd(keys(%leaf)){
    if(exists $seed{$dd}){
        next;
    }else{
        my $leaf_tolnu=$leaf{$dd};
        chomp $dd;
        print ONLYLEAF "$dd\t$leaf_tolnu\n";
    }
}
close ONLYLEAF;
