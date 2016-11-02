#!/usr/bin/perl -w

die usage() unless @ARGV==5;
my ($snp_vcf,$del_name,$mis_cut,$maf_cut,$out) = @ARGV;
open T, $del_name or die "$!";
my %name;
while (<T>){
    chomp;
    $name{$_}='';
}
close T;

open R,$snp_vcf or die "$!";
open OUT,"+>$out" or die "$!";
my $i = 0;  #  judge the first line or not
my $row_nu = 0;
my $total_line = 0;
my $wrong_line = 0;
while (<R>){
    chomp;
    if($i==0){
        my @fen=split/\s+/,$_;
        my $nn=@fen;
	$row_nu = $nn;
        for(my $j=0;$j<$nn;$j++){
    	    if(exists $name{$fen[$j]}){
		$site{$j}='';
            }else{
		print OUT "$fen[$j]\t";
            }
        }
        print OUT "\n";
    }else{
	++ $total_line;
        my @fen=split/\s+/,$_;
        my $nn=@fen;
	if($row_nu != $nn){
	    ++ $wrong_line;
	    next;
        }
        my @out;
        for(my $j=0;$j<$nn;$j++){
            if(!exists $site{$j}){
                push @out, $fen[$j];
            }
         }
        my $out = join("\t",@out);

        my ($chr,$pos,$b73_ref,@inbred) = @out; # the third line is B73 reference
        my $snp_infor = join("\t",@inbred);
        my $tot_1 = $snp_infor =~ s/[ATGC]\/[ATGC]/0/g;
        my $tot_2 = $snp_infor =~ tr/ACGTx/12340/;
        my $tot = $tot_1 + $tot_2;
        my $mis = $snp_infor =~ tr/0/0/ || 0;
        my %base_nu;
           $base_nu{"A"} = $snp_infor =~ s/1/1/g || 0;
           $base_nu{"C"} = $snp_infor =~ s/2/2/g || 0;
           $base_nu{"G"} = $snp_infor =~ s/3/3/g || 0;
           $base_nu{"T"} = $snp_infor =~ s/4/4/g || 0;
       my @base_sort = sort{$base_nu{$b}<=>$base_nu{$a}} keys %base_nu;
       print "@base_sort\n";
           $out =~ s/[ATGC]\/[ATGC]/0/g;
           $out =~ s/$base_sort[2]/x/g;
           $out =~ s/$base_sort[3]/x/g;
        my $mis_rate = $mis / $tot;
        my $maf = 0;
           $maf = $base_nu{$base_sort[1]} / ($tot -  $mis) if $tot -  $mis != 0;
        next if ($mis_rate >= $mis_cut || $maf < $maf_cut);
        print OUT "$out\n";
   }
   $i++;
}

sub maf{
    my ($line) = @_;
    my ($chr,$pos,$b73_ref,@inbred) = split(/\s+/,$line); # the third line is B73 reference  
    my $snp_infor = join("\t",@inbred);
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

    perl *.pl <SNP data> <delete name> <miss rate cut> <MAF cut> <OUT> 
    we use this to delete some inred lines in the snp data [/datastore/workspace/caulai/jiao/GWAS_2012_June/3_cat-snp/delete-inbred.pl]

DIE
    exit 1;
}
