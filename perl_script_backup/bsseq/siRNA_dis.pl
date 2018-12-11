#!/usr/bin/perl -w
die("usage: perl count_reads_all.pl <mapping file> < gene position>  <output coverage> \n") unless @ARGV==3;
open R,"$ARGV[0]" or die;
print "reads mapping file\n";
while(<R>){
	my ($chr,$po)=(split)[7,8];
	$hash{$chr}{$po}++;
#	$chr eq "chr1" ? $chr1{$po}++ :
#	$chr eq "chr2" ? $chr2{$po}++ :
#	$chr eq "chr3" ? $chr3{$po}++ :
#	$chr eq "chr4" ? $chr4{$po}++ :
#	$chr eq "chr5" ? $chr5{$po}++ :
#	$chr eq "chr6" ? $chr6{$po}++ :
#	$chr eq "chr7" ? $chr7{$po}++ :
#	$chr eq "chr8" ? $chr8{$po}++ :
#	$chr eq "chr9" ? $chr9{$po}++ :
#	$chr eq "chr10" ? $chr10{$po}++:
#			$chr0{$po}++;
}
close R;

#$hash{"chr1"}=\%chr1;
#$hash{"chr2"}=\%chr2;
#$hash{"chr3"}=\%chr3;
#$hash{"chr4"}=\%chr4;
#$hash{"chr5"}=\%chr5;
#$hash{"chr6"}=\%chr6;
#$hash{"chr7"}=\%chr7;
#$hash{"chr8"}=\%chr8;
#$hash{"chr9"}=\%chr9;
#$hash{"chr10"}=\%chr10;
#$hash{"chr0"}=\%chr0;


print "culculat!\n";
open F,"$ARGV[1]" or die;
open OUT,"+>$ARGV[2]" or die;
while(<F>){
	chomp;
#	my @el=split;
	my ($chr,$st,$ed,$gene,$or)=split;
	$chr="chr$chr";


#	$bb=0;
	my %cov;
	my %up;
	my %down;


        for($x=$st-5000;$x<$st;$x++){
                $up{$x-$st+5000+1}=$hash{$chr}{$x};
        }

        for($x=$ed;$x<$ed+5000;$x++){
                $down{$x-$ed+1}=$hash{$chr}{$x};
        }

	my $up_ref=\%up;
	my $down_ref=\%down;
	
	my @up_dis=count($up_ref,$chr,$gene);
	my @down_dis=count($down_ref,$chr,$gene);
	my $bb=0;
	for($x=$st;$x<=$ed;$x++){
		$bb++;
		$cov{$bb}=$hash{$chr}{$x};
#		print "it is $gene $hash{$chr}{$x} and hahah $bb $cov{$bb}\n";
	}
	my $cov_ref=\%cov;
	
	my @gene_dis=divide($bb,$cov_ref,$chr,$gene);
	print OUT "$chr\t$gene\t";
	if($or eq "+"){
		print OUT @up_dis;
		print OUT @gene_dis;
		print OUT @down_dis;
	}
	else{
		@up_dis=reverse @up_dis;
		@down_dis=reverse @down_dis;
		@gene_dis=reverse @gene_dis;
		print OUT @down_dis;
		print OUT @gene_dis;
		print OUT @up_dis;
	}
	print OUT "\n";
}
###################3
sub count{
        my ($ref,$chr,$gene)=@_;
        my $unit=100;
        %cov=%{$ref};
        my @array;
        $perc=0;
        my $x;
        for($x=1;$x<=5000;$x++){
                $perc+=$cov{$x} if $cov{$x};
                if(!($x%$unit)){
                        push @array,"$perc\t";
                        $perc=0;
                }
        }
	my $aa=@array;
        return @array;



}
#######################3

sub divide{
	my ($bb,$ref,$chr,$gene)=@_;
	my $unit=int($bb/10+0.5);
	%cov=%{$ref};
	my @array;
	$perc=0;
	my $x;
#	print "doint $bb,$chr,$gene,unit is $unit\n";
	for($x=1;$x<=$bb;$x++){
		$perc+=$cov{$x} if $cov{$x};
#		print "now is $x $cov{$x}\n";
		if(!($x%$unit)){
			$perc=int(100*$perc/$unit);
			push @array,"$perc\t";
#			print "$chr\t$gene\t$perc\tgene\n";
			$perc=0;
		}
	}
	if($unit*10>$bb){
		$perc=int(100*$perc/$unit);
		push @array,"$perc\t";
	}
	return @array;
	
	

}
