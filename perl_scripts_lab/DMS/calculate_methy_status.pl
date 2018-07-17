#!/usr/bin/perl -w
# recalcualte methylation status using Lister et al. 2009 method
use strict;
use Math::CDF qw(:all);
my $FDR = 0.01;
my $print_values = 0;
my $usage = "$0 <meth file> <error rate> <max_pos_id>";
die $usage unless(@ARGV >= 2);
my ($meth_file, $rate) = @ARGV[0..1];
my %meth_max;
my %accu_meth;
my %total_meth;
my %meth_level;
my $max_pos_id = 42859753; #don't want to include chrC, chrM, pUPC19
if(@ARGV > 2){
	$max_pos_id = $ARGV[2];
}
open(MF, $meth_file) or die "Can't open $meth_file: $!";
while(<MF>){
	next if (/SampleID/);
	chomp;
	my ($sample_id, $pos_id, $depth, $num_C, $percent, $type) = split /\t/;
	next if($pos_id > $max_pos_id);
		$meth_level{$type}->[$depth]->[$num_C]++;
		$total_meth{$type}->[$depth]++;
		if(!defined $meth_max{$type}){
			$meth_max{$type} = $depth;
		}elsif($meth_max{$type} < $depth){
			$meth_max{$type} = $depth;
		}
}
close MF;

# calculate accumulated number of positions with <= k unconverted Cs
foreach my $t(keys %meth_max){
	foreach my $i(0..$meth_max{$t}){
		if(!defined $meth_level{$t}->[$i]->[0]){
			$meth_level{$t}->[$i]->[0] = 0;
		}
		$accu_meth{$t}->[$i]->[0] = $meth_level{$t}->[$i]->[0];
		next if($i == 0);
		foreach my $j(1..$i){
			if(!defined $meth_level{$t}->[$i]->[$j]){
				$meth_level{$t}->[$i]->[$j] = 0;
			}
			$accu_meth{$t}->[$i]->[$j] = $accu_meth{$t}->[$i]->[$j-1] +
			     $meth_level{$t}->[$i]->[$j];
		}
	}
}
			
print STDERR "Max depth\n";
foreach my $t(sort keys %meth_max){
	print STDERR $t, " ", $meth_max{$t}, " ";
}
print STDERR "\n";

#my $max_depth = 18;
# calculate at each depth, how many positions have k unconverted C
if($print_values){
    print "Number of positions with k unconverted Cs at each depth\n";
}
foreach my $t(sort keys %meth_max){
	my $max_depth = $meth_max{$t};
	if($print_values){
	print $t;
    foreach my $i(0..$max_depth){
		print "\t", $i;
	}
	print "\n";
	}
	foreach my $i(0..$max_depth){
		if($print_values){
		    print $i;
		}
		foreach my $j(0..$i){
		#	if(!defined $meth_level{$t}->[$i]->[$j]){
		#		$meth_level{$t}->[$i]->[$j] = 0;
		#	}
			if($print_values){
			   print "\t", $meth_level{$t}->[$i]->[$j], "|",
			   $accu_meth{$t}->[$i]->[$j];
			}
		}
		if($print_values){
		    print "\n";
		}
	}
}

undef %meth_level;

# find cutoff at each depth level
my %cutoff;
my %num_pos;
if($print_values){
    print "Lister equation values\n";
}
foreach my $t(sort keys %meth_max){
	my $max_depth = $meth_max{$t};
	if($print_values){
	    print $t;
    foreach my $i(0..$max_depth){
		print "\t", $i;
	}
	print "\n";
	}

	foreach my $i(0..$max_depth){
		next if(!defined $total_meth{$t}->[$i]);
		if($print_values){
		    print $i;
		}
		if($i < 2){
			if($print_values){
			    print "\t0";
			}
			$cutoff{$t}->[$i] = 0;
			#next;
		}else{
			$cutoff{$t}->[$i] = 4;
		foreach my $j(1..$i){
			
			my $prob = pbinom($j, $i, $rate);
			if($j > 0){
				$prob = $prob - pbinom($j-1, $i, $rate);
			}
			my ($num_unC, $num_mC) = (0,0);
			$num_unC = $accu_meth{$t}->[$i]->[$j-1];
			if(!defined $num_unC){
				$num_unC = 0;
			}
			$num_mC = $total_meth{$t}->[$i] - $num_unC;
			my $left = $prob * $num_unC;
			my $right = $FDR * $num_mC;
			if($left < $right){
				$cutoff{$t}->[$i] = $j;
				$num_pos{$t}->[$i] = $num_mC;
				last;
			}
			if($print_values){
			    print "\t", $left, "|", $right;
			}
		}
		if($print_values){
		    print "\n";
		}
	}
	}
}

undef %total_meth;
if($print_values){
    print "Cutoff values and number of mC at each depth\n";
}
#my $max_depth = 100;
print STDERR "Total mC position in ", $meth_file, "\n";
foreach my $t(sort keys %meth_max){
	my $max_depth = $meth_max{$t};
	#if($print_values){
	    #print STDERR $t, "\n";
	#}
    foreach my $i(0..$max_depth){
		if($print_values){
		print $i;
		if($i != $max_depth){
			print "\t";
		}
		}
	}
	if($print_values){
	    print "\n";
	}
	if($print_values){
	foreach my $i(0..$max_depth){
		
		if(defined $cutoff{$t}->[$i]){
			print $cutoff{$t}->[$i];
		}else{
			print "0";
		}
		if($i != $max_depth){
			print "\t";
		}
	}
	print "\n";
	}
	my $total = 0;
    foreach my $i(0..$max_depth){
		if(defined $num_pos{$t}->[$i]){
			if($print_values){
			    print $num_pos{$t}->[$i];
			}
			$total += $num_pos{$t}->[$i];
		}else{
			if($print_values){
			    print "0";
			}
		}
		if($i != $max_depth){
			if($print_values){
			    print "\t";
			}
		}
	}
	if($print_values){
	    print "\n";
	}
	print STDERR "$t: $total\n";

}
undef %meth_max;
undef %num_pos;
open(MF, $meth_file) or die "Can't open $meth_file: $!";
#seek(MF, 0, 0) or die "Can't seek to beginning of file: $!";
while(<MF>){
	chomp;
	if (/SampleID/){
		print;
		print "\tisMeth\n";
		next;
	}
	
	my ($sample_id, $pos_id, $depth, $num_C, $percent, $type) = split /\t/;
	next if($pos_id > $max_pos_id);
	my $isMeth = 0;
		if($depth >= 2 && $num_C >= 1 && $num_C >= $cutoff{$type}->[$depth]){
			$isMeth = 1;
		}
		print join("\t", ($sample_id, $pos_id, $depth, $num_C, $percent, $type, 
		    $isMeth)), "\n";
	
}
close MF;

