#!/usr/bin/perl -w
die("usage:perl allele.pl <snp> <BM_B> <BM_M> <MB_B> <MB_M> <output> \n") unless @ARGV==6;

($snp,$cros1_b,$cros1_m,$cros2_b,$cros2_m,$output)=@ARGV;
print "reading SNP\n";
open F, $snp or die;
while(<F>){
        my @array=split;
        $hash{$array[0]}{$array[1]}=[$array[2],$array[3]];
}
close F;


open F,$cros1_b or die;
#open G,$cros_m or die;
print "doing 1 BM_B\n";
my $date=`date`;
print "time is \t$date";

while(<F>){
        my @tem=split;
        next if !exists $hash{$tem[0]}{$tem[1]};
#	my $aa=0;
	$bad{$tem[0]}{$tem[1]}++ if $tem[4]=~/\*/;
#	if($hash{$tem[0]}{$tem[1]}->[0] eq $tem[2]){
	        my $aa=$tem[4]=~tr/\,\./\,\./ || 0;
	        $snp_freq{$tem[0]}{$tem[1]}->[0]=$aa;# if $tem[3]>=5 and $aa/$tem[3]>=0.7;
#	}
#	else{
#		my $ref=$hash{$tem[0]}{$tem[1]}->[0];
#		my $aa=$tem[4]=~s/$ref
#	}
}
close F;

print "doing 2 BM_M\n";
$date=`date`;
print "time is \t$date";

open G,$cros1_m or die;
while(<G>){
        my @tem=split;
        next if !$hash{$tem[0]}{$tem[1]};
#	my $aa=0;
        my $aa=$tem[4]=~tr/\,\./\,\./ || 0;
	$snp_freq{$tem[0]}{$tem[1]}->[1]=$aa;
	$bad{$tem[0]}{$tem[1]}++ if $tem[4]=~/\*/;

#	print "$tem[0]\t$tem[1]\t",$snp_freq{"$tem[0]\t$tem[1]"}->[0],"\t$aa\n";
}
close G;

print "doing 3 MB_B\n";
$date=`date`;
print "time is \t$date";

open F,$cros2_b or die;
while(<F>){
        my @tem=split;
        next if !$hash{$tem[0]}{$tem[1]};
#	print "yes1 $tem[0]\n";
#        my $aa=0;
        my $aa=$tem[4]=~tr/\,\./\,\./ || 0;
	$bad{$tem[0]}{$tem[1]}++ if $tem[4]=~/\*/;

        $snp_freq{$tem[0]}{$tem[1]}->[2]=$aa;# if $tem[3]>=5 and $aa/$tem[3]>=0.7;
}
close F;

print "doing 4 MB_M\n";
$date=`date`;
print "time is \t$date";

open G,$cros2_m or die;
while(<G>){
        my @tem=split;
        next if !$hash{$tem[0]}{$tem[1]};
	
#        my $aa=0;
        my $aa=$tem[4]=~tr/\,\./\,\./ || 0;
	$bad{$tem[0]}{$tem[1]}++ if $tem[4]=~/\*/;

#	$aa=
        $snp_freq{$tem[0]}{$tem[1]}->[3]=$aa;
#       print "$tem[0]\t$tem[1]\t",$snp_freq{"$tem[0]\t$tem[1]"}->[0],"\t$aa\n";
}

print "all task done!recording the results\n";
my $gene;
open OUT,"+>$output" or die;
foreach $gene(keys %snp_freq){
	my @pos=keys %{$snp_freq{$gene}};
	foreach $op(sort {$a<=>$b} @pos){
		my @num;
		next if $bad{$gene}{$op};
		$num[0]=$snp_freq{$gene}{$op}->[0] || 0;
		$num[1]=$snp_freq{$gene}{$op}->[1] || 0;
		$num[2]=$snp_freq{$gene}{$op}->[2] || 0;
		$num[3]=$snp_freq{$gene}{$op}->[3] || 0;

		print OUT "$gene\t$op\t";
		print OUT join "\t",@num;
		print OUT "\n";
	}
}


