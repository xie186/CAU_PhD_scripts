#!/usr/bin/perl -w

die usage() unless @ARGV==4;
my ($header,$real_278,$inbred_alias,$out) = @ARGV;
open REAL,$real_278 or die "$!";
<REAL>;
my %hash_inbred278;
while(<REAL>){
     chomp;
     my ($group,$inbred,$depth) = split(/\t/);
     $hash_inbred278{$inbred} = $_;
}
open T, $inbred_alias or die "$!";
my %name;
while (<T>){
    chomp;
    my ($alias,$real_name) = (split);
        $alias =~ s/CAU0/CAU/g;
    $name{$alias} = $hash_inbred278{$real_name} if exists $hash_inbred278{$real_name};
    delete $hash_inbred278{$real_name};
}
close T;

foreach(keys %hash_inbred278){
    print "xx$_\n";
}

open R,$header or die "$!";
open OUT,"+>$out" or die "$!";
my $i = 0;  #  judge the first line or not
my $row_nu = 0;
my $total_line = 0;
my $wrong_line = 0;
my %inbred_index;
while (<R>){
    chomp;
    if($i==0){
        chomp;
        my ($chr,$pos,$ref,@inbred) = split;
	$row_nu = @inbred;
        for(my $j=0;$j< @inbred;$j++){
            $tem_inbred = $inbred[$j];
            $tem_inbred =~ s/CAU0/CAU/g;
    	    if(exists $name{$tem_inbred}){
                my ($group,$inbred,$depth) = split(/\t/,$name{$tem_inbred});
                print OUT "$group\t$inbred[$j]\t$inbred\t$depth\n";
                delete $name{$tem_inbred};
            }
        }
        last;
    }
}

foreach (keys %name){
    print "$_\n";
}
print <<REPORT;
Total line: $total_line;
Wrong line: $wrong_line;
Percentage: $wrong_line/$total_line;
REPORT

sub usage{
    print <<DIE;

    perl *.pl <header> <real_278> <inbred_alias> <OUT>
    we use this to delete some inred lines in the snp data [/datastore/workspace/caulai/jiao/GWAS_2012_June/3_cat-snp/delete-inbred.pl]

DIE
    exit 1;
}
