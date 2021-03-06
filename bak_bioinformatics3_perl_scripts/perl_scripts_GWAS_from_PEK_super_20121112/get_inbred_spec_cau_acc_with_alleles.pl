#!/usr/bin/perl -w
die usage() unless @ARGV==5;
my ($snp_vcf,$inbred_alias,$mis_cut,$maf_cut,$out) = @ARGV;

open T, $inbred_alias or die "$!";
my %name;
while (<T>){
    chomp;
    my ($fam,$alias,$real_name) = (split);
    $name{$alias}=$real_name;
}
close T;

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
        my ($mis_rate,$maf,$alt_alle) = &maf($snp_infor,$ref);
        next if ($mis_rate >= $mis_cut || $maf <= $maf_cut);
        print OUT "$chr\t$pos\t$ref/$alt_alle\t$snp_infor\n" if $alt_alle ne "Wrong";
   }
   $i++;
}

foreach(keys %name){
    print "xx\t$_\n";
}
sub maf{
    my ($snp_infor,$ref) = @_;
    my $tot_1 = $snp_infor =~ s/[ATGC]\/[ATGC]/0/g;
    my $tot_2 = $snp_infor =~ tr/ACGTx/12340/;
    my $tot = $tot_1 + $tot_2;
    my $mis = $snp_infor =~ tr/0/0/ || 0;
    my %base_nu;
       $base_nu{"A"} = $snp_infor =~ s/1/1/g || 0;
       $base_nu{"C"} = $snp_infor =~ s/2/2/g || 0;
       $base_nu{"G"} = $snp_infor =~ s/3/3/g || 0;
       $base_nu{"T"} = $snp_infor =~ s/4/4/g || 0;
    my ($max,$min) = sort{$b<=>$a} values %base_nu;
    my ($allele1,$allele2) = sort{$base_nu{$b}<=>$base_nu{$a}} keys %base_nu;
    my $alt_allele;
    if($allele1 eq $ref){
        $alt_allele = $allele2;
    }elsif($allele2 eq $ref){
        $alt_allele = $allele1;
    }else{
        $alt_allele = "Wrong";
    }
    my $mis_rate = $mis / $tot;
    my $maf = 0;
       $maf = $min / ($tot -  $mis) if $tot -  $mis != 0;
#    print "$line\t$mis_rate, $maf\t$max,$min\n";
    return ($mis_rate,$maf,$alt_allele); 
}

print <<REPORT;
Total line: $total_line;
Wrong line: $wrong_line;
Percentage: $wrong_line/$total_line;
REPORT

sub usage{
    print <<DIE;
    perl *.pl <SNP data> <inbred_alias> <miss rate cut> <MAF cut> <OUT> 
    we use this to delete some inred lines in the snp data [/datastore/workspace/caulai/jiao/GWAS_2012_June/3_cat-snp/delete-inbred.pl]
DIE
    exit 1;
}
