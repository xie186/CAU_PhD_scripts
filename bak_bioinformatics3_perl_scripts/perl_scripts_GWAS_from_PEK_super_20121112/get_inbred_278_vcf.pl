#!/usr/bin/perl -w
die usage() unless @ARGV==6;
my ($snp_vcf,$real_278,$inbred_alias,$mis_cut,$maf_cut,$out) = @ARGV;
open REAL,$real_278 or die "$!";
<REAL>;
my %hash_inbred278;
while(<REAL>){
     chomp;
     my ($group,$inbred,$depth) = split(/\t/);
     $hash_inbred278{$inbred} ++;
}
open T, $inbred_alias or die "$!";
my %name;
while (<T>){
    chomp;
    my ($alias,$real_name) = (split);
        $alias =~ s/CAU0/CAU/g;
    $name{$alias}=$real_name if exists $hash_inbred278{$real_name};
    delete $hash_inbred278{$real_name};
}
close T;
foreach(keys %hash_inbred278){
    print "$_\n";
}

open R,$snp_vcf or die "$!";
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
        print OUT "$chr\t$pos\t$ref";
        for(my $j=0;$j< @inbred;$j++){
            $tem_inbred = $inbred[$j];
            $tem_inbred =~ s/CAU0/CAU/g;
    	    if(exists $name{$tem_inbred}){
		$inbred_index{$j}++;
                print OUT "\t$inbred[$j]";
                delete $name{$tem_inbred};
            }
        }
        print OUT "\n";
    }else{
	++ $total_line;
        my ($chr,$pos,$ref,@geno) = split; # the third line is B73 reference
        my $nn = @geno;
	if($row_nu != $nn){
	    ++ $wrong_line;
	    next;
        }
        my @out;
        for(my $j=0;$j < $nn;$j++){
            if(exists $inbred_index{$j}){
                push @out, $geno[$j];
            }
        }

        my $snp_infor = join("\t",@out);
        my ($mis_rate,$maf) = &maf($snp_infor);
        next if ($mis_rate >= $mis_cut || $maf < $maf_cut);
        print OUT "$chr\t$pos\t$ref\t$snp_infor\n";
   }
   $i++;
}

foreach(keys %name){
    print "xx\t$_\n";
}
sub maf{
    my ($snp_infor) = @_;
    my $tot_1 = $snp_infor =~ s/[ATGC]\/[ATGC]/0/g;
    my $tot_2 = $snp_infor =~ tr/ACGTx/12340/;
    my $tot = $tot_1 + $tot_2;
    my $mis = $snp_infor =~ tr/0/0/ || 0;
    my @base_nu;
       $base_nu[0] = $snp_infor =~ s/1/1/g || 0;
       $base_nu[1] = $snp_infor =~ s/2/2/g || 0;
       $base_nu[2] = $snp_infor =~ s/3/3/g || 0;
       $base_nu[3] = $snp_infor =~ s/4/4/g || 0;
    my ($max,$min) = sort{$b<=>$a} @base_nu;
    my $mis_rate = $mis / $tot;
    my $maf = 0;
       $maf = $min / ($tot -  $mis) if $tot -  $mis != 0;
#    print "$line\t$mis_rate, $maf\t$max,$min\n";
    return ($mis_rate,$maf); 
}
print <<REPORT;
Total line: $total_line;
Wrong line: $wrong_line;
Percentage: $wrong_line/$total_line;
REPORT

sub usage{
    print <<DIE;
    perl *.pl <SNP data> <real_278> <inbred_alias> <miss rate cut> <MAF cut> <OUT> 
    we use this to delete some inred lines in the snp data [/datastore/workspace/caulai/jiao/GWAS_2012_June/3_cat-snp/delete-inbred.pl]
DIE
    exit 1;
}
