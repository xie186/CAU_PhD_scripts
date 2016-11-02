#!/usr/bin/perl -w

# calculate piT and piS
# piT = sum(w_i*w_i*pi_ii+2*sum(w_i*w_j*pi_ij)
# piS = sum(w_i*w_i*pi_ii)/sum(w_i*w_i)

die("<hapmap> <number of ind> <group file1> <group file2> ... \n") unless @ARGV>0;
#compare old_us1,china_old,china_us,china_am
#each site in a compare should be covered by at least 50% inbreds
use strict;
my $hapmap=shift @ARGV;
my $num_all_ind=shift @ARGV;
my @group=@ARGV;
my $ng=@group;
my %group_size;
my $w_i_sq=(1/$ng)*(1/$ng); # un weighted
my %sample;
for(my $x=0;$x<$ng;$x++){
	open F,"$group[$x]" or die;
	my $tt;
	while(<F>){
		$tt++;
		my @tem=split;
#		print "$tem[0]\n";
		$sample{$tem[2]}=$x+1;
#		print "it is $x\n";
	}
	close F;
	$group_size{$x+1}=$tt;
}
#my $w=(1/$ng)*(1/$ng);
my %wi;
while(my ($aa,$bb)=each %group_size){
	$wi{$aa}=$bb/$num_all_ind;
#	print "group $aa have $bb lines\n";
}

#exit;

my %gp_member;
open F,$hapmap or die;
while(<F>){
	my @tem=split;
	splice(@tem,0,11);
	#get member of each group
	for(my $x=0;$x<@tem;$x++){
		if($sample{$tem[$x]}){
#			print "yes,$tem[$x]\n";
			my $gn=$sample{$tem[$x]};
#			print "$gn\n";
			push @{$gp_member{$gn}},$x;
		}
	}
#	print "@{$gp_member{1}}\n";
#exit;a
	my %pi_ii;
	my %pi_ij;
	my $count=0;
	my %num_ind;
	my $w_ii_sq;
	my $beg;
	my $end;
	while(<F>){
		$count++;
		my @new=split;
		my $chr=$new[2];
		my $pos=$new[3];
		$beg=$pos if $count==1;
		$end=$pos;
		my ($ref)=$new[1]=~/(\w)\//;
		splice(@new,0,11);
		# calculate pi_ii in each group
		for(my $y=1;$y<=$ng;$y++){
			my @sites=@new[@{$gp_member{$y}}];
#			push @all_sites,@sites;
#			my $pi=Wdenom($ref,@sites);
			$pi_ii{$y}+=cal_pi($ref,@sites);
#			$w_ii_sq+=(1/$group_size{$y})*(1/$group_size{$y});
#			print "$pi\n";
#			$pi_ii+=$pi;
		}
#		$pi_ii=$pi_ii
		# calculate pi_ij betwen each group;
		for(my $m=1;$m<=$ng-1;$m++){
			my @sites1=@new[@{$gp_member{$m}}];
			for(my $n=$m+1;$n<=$ng;$n++){
				my @sites2=@new[@{$gp_member{$n}}];
				$pi_ij{"$m $n"}+=cal_pi2($ref,\@sites1,\@sites2);
			}
		}
		if($count==200){
#			print "out\n";
#			my %wi;
			for(my $hh=1;$hh<=$ng;$hh++){
				$w_ii_sq+=$wi{$hh}*$wi{$hh};
			}
#			print "wi is $w_ii_sq\n";
			my $sum_pii=0;
			my $sum_pij=0;
			foreach my $ngp(keys %pi_ii){
#				print "ii is $pi_ii{$ngp}\n";
				$sum_pii+=$wi{$ngp}*$wi{$ngp}*$pi_ii{$ngp};
			}
			foreach my $npp(keys %pi_ij){
				my ($mm,$nn)=split /\s+/,$npp;
#				print "pair is $pi_ij{$npp}\n";
				$sum_pij+=$wi{$mm}*$wi{$nn}*$pi_ij{$npp};
			}
			my $pi_T=$sum_pii+2*$sum_pij;
			my $pi_S=$sum_pii/$w_ii_sq;
			my $fst=($pi_T-$pi_S)/$pi_T;
			print "$chr\t$beg\t$end\t",$end-$beg,"\t$pi_T\t$pi_S\t$fst\n";
			$count=0;
			undef(%pi_ii);
		        undef(%pi_ij);
        		$count=0;
       			undef(%num_ind);
		        $w_ii_sq=0;

		}
	}
}
#####################################

sub cal_pi2{
        my $ref=shift @_;
	my @gp1=@{shift @_};
	my @gp2=@{shift @_};
#	print "it is $ref\n@gp2";#allele is @gp1\n and @gp2\n";

	my $n1_ref=0;
	my $n2_ref=0;
	my $n1_alt=0;
	my $n2_alt=0;
	
	for(my $x=0;$x<@gp1;$x++){
		if($gp1[$x]=~/N/){
			next;
		}
		elsif($gp1[$x]=~/$ref/){
			$n1_ref++;
		}
		else{
			$n1_alt++;
		}
	}
	for(my $x=0;$x<@gp2;$x++){
		if($gp2[$x]=~/N/){
			next;
		}
		elsif($gp2[$x]=~/$ref/){
			$n2_ref++;
		}
		else{
			$n2_alt++;
		}
	}
#	print "they are $n1_ref,$n1_alt,$n2_ref,$n2_alt\n";
#exit;
        my $n1_sam=$n1_ref+$n1_alt;
	my $n2_sam=$n2_ref+$n2_alt;
	my $ff;
	my $gg;
	if($n1_sam==0){
		$ff=0;
	}
	else{
		$ff=($n1_ref/$n1_sam)*($n2_ref/$n2_sam);
	}
	if($n2_sam==0){
		$gg=0;
	}
	else{
		$gg=($n1_alt/$n1_sam)*($n2_alt/$n2_sam);
	}
	my $pi=($n1_ref/$n1_sam)*($n2_alt/$n2_sam)+($n1_alt/$n1_sam)*($n2_ref/$n2_sam);
#        my $homo=($nref*($nref-1)+$nalt*($nalt-1))/($nsam*($nsam-1));
#        my $pi=1-$homo;
        return $pi;
}


#####################################

sub cal_pi{
        my $ref=shift @_;
	my @arr=@_;
#        my $line=shift @_;
 #       my @arr=split /\s+/,$line;
        my $nref=0;
        my $nalt=0;
        my $nsam=0;
        for(my $x=0;$x<@arr;$x++){
                if($arr[$x]=~/N/){
                        next;
                }
                elsif($arr[$x]=~/$ref/){
                        $nref++;
                }
                else{
                        $nalt++;
                }
        }
        $nsam=$nref+$nalt;
	return 0 if $nsam<=1;
        my $homo=($nref*($nref-1)+$nalt*($nalt-1))/($nsam*($nsam-1));
        my $pi=1-$homo;
        return $pi;
}

