#!/usr/bin/env perl

# Program: SolexaQA v.1.6
# Calculates quality statistics on Solexa fastq sequencing data files
# and creates visual representations of run quality
# Daniel Peterson and Murray Cox
# Massey University Palmerston North, New Zealand
# Email contact <m.p.cox@massey.ac.nz>
# March 2011

# Version 1.3: Automatic FASTQ format detection

# Version 1.4: Fixed automatic FASTQ format detection bug (user-defined formats)
#              Added BWA-style read trimming

# Version 1.5: Minor modifications

# Version 1.6: Modified for HiSeq-2000 data

# Released under GNU General Public License version 3

use strict;
use warnings;
use Getopt::Long;

my $usage = "
$0 input_files [-p|probcutoff 0.05] [-h|phredcutoff 13] [-v|variance] [-m|minmax] [-s|sample 10000] [-b|bwa] [-sanger -solexa -illumina]\n
-p|probcutoff	probability value (between 0 and 1) at which base-calling error is considered too high (default; p = 0.05) *or*
-h|phredcutoff	Phred score (between 0 and 40) at which base-calling error is considered too high
-v|variance     calculate variance statistics
-m|minmax	calculate minimum and maximum error probabilities for each read position of each tile
-s|sample	number of sequences to be sampled per tile for statistics estimates (default; s = 10000)
-b|bwa          use BWA trimming algorithm
-sanger         Sanger format (bypasses automatic format detection)
-solexa         Solexa format (bypasses automatic format detection)
-illumina       Illumina format (bypasses automatic format detection)
\n";

# global values
my $prob_cutoff;
my $phrd_cutoff;

my $variance = 0;
my $minmax   = 0;
my $sample   = 10000;

my $automatic_detection_lines = 10000;
my $sanger = 0;
my $solexa = 0;
my $illumina = 0;
my $format;
my $user_defined;

my $bwa;

my $is_hiseq;
my %hiseq_tile = (
	1 => 1,
	2 => 2,
	3 => 3,
	4 => 4,
	5 => 5,
	6 => 6,
	7 => 7,
	8 => 8,
	21 => 9,
	22 => 10,
	23 => 11,
	24 => 12,
	25 => 13,
	26 => 14,
	27 => 15,
	28 => 16,
	41 => 17,
	42 => 18,
	43 => 19,
	44 => 20,
	45 => 21,
	46 => 22,
	47 => 23,
	48 => 24,
	61 => 25,
	62 => 26,
	63 => 27,
	64 => 28,
	65 => 29,
	66 => 30,
	67 => 31,
	68 => 32
);
my @hiseq_keys = keys %hiseq_tile;

# read user options
GetOptions(
	"v|variance"      => \$variance,
	"m|minmax"        => \$minmax,
	"s|sample=i"      => \$sample,
	"p|probcutoff=f"  => \$prob_cutoff,
	"h|phredcutoff=f" => \$phrd_cutoff,
	"b|bwa"           => \$bwa,
	"sanger"          => \$sanger,
	"solexa"          => \$solexa,
	"illumina"        => \$illumina
);

# get user format (if supplied)
if( ($sanger && $solexa) || ($sanger && $illumina) || ($solexa && $illumina) ){
	die "Error: Please select only one of -sanger, -solexa or -illumina\n";
}

if( $sanger || $solexa || $illumina ){
	$user_defined = 1;
}

if( $sanger ){
	$format = "sanger";
}elsif( $solexa ){
	$format = "solexa";
}elsif( $illumina ){
	$format = "illumina";
}

# get files
my @files = @ARGV;

# check for presence of at least one input file
if( !$files[0] ){ die "$usage"; }

# check for appropriate sample size
if( $sample < 10000 ){
	print STDERR "Warning: Sample sizes less than 10,000 may lead to inaccurate estimates\n";
}

if( ( $sample > 10000 ) && $variance ){
	print STDERR "Warning: Running variance method with sample sizes greater than 10,000 may take a long time\n";
}

# check for user input values and convert Phred cutoff value to probability
if( defined( $prob_cutoff ) && defined( $phrd_cutoff ) ){
	die "Error: Please select p OR h cutoff, not both.\n";

}elsif( !defined( $prob_cutoff ) && !defined( $phrd_cutoff ) ){
	$prob_cutoff = 0.05;

}elsif( defined( $phrd_cutoff ) && $phrd_cutoff < 0 ){
	die "Error: Q cutoff must be greater than or equal to 0";

}elsif( defined( $prob_cutoff ) && ( $prob_cutoff < 0 || $prob_cutoff > 1 ) ){
	die "Error: P cutoff must be between 0 and 1";

}

# check for presence of R and matrix2png
if( !`which R 2> err.log` ){
	print STDERR "Warning: Subsidiary program R not found. Line graph and histogram will not be produced.\n";
}
`rm err.log`;

if( !`which matrix2png 2> err.log` ){
	print STDERR "Warning: Subsidiary program matrix2png not found. Heat map will not be produced.\n";
}
`rm err.log`;

# loop through input files
FILE_LOOP: foreach my $input_file ( @files ){
	
	# initialize variables to store number of tiles and number of bases per read
	my $number_of_tiles;
	my $read_length;
	
	# just get filename, not full path (as returned by @ARGV)
	my @filepath = split( /\//, $input_file );
	my $filename = $filepath[$#filepath];

	# open input file for reading	
	open( INPUT, "<$input_file" )
		or die "Error: Failure opening $input_file for reading: $!\n";
	
	# count number of lines in file
	my $line_counter = 0;
	while( <INPUT> ){
		$line_counter++;
	}
	
	# number of sequences
	my $number_of_sequences = $line_counter / 4;
	
	my $last_line = $line_counter;
	
	if( $last_line <= 1 ){
		print STDERR "Warning: File $input_file is empty\n";
		next FILE_LOOP;
	}
	
	# reset file pointer and line counter
	seek (INPUT, 0, 0);
	$line_counter = 0;
	
	# determine format
	if( !$user_defined ){
		$format = "";
	}
	if( !$format ){
		
		my $number_of_lines = $automatic_detection_lines;
		if( $automatic_detection_lines > $number_of_sequences ){
			$number_of_lines = $number_of_sequences;
		}
	
		$format = &get_format(*INPUT, $number_of_lines);
		if( !$format ){
			die "Error: File format cannot be determined\n";
		}
	}
	
	# print format information
	if( $format eq "sanger" ){
		if( $user_defined ){
			print STDOUT "User defined format: Sanger FASTQ format\n";
		}else{
			print STDOUT "Automatic format detection: Sanger FASTQ format\n";
		}
	}elsif( $format eq "solexa" ){
		if( $user_defined ){
			print STDOUT "User defined format: Solexa FASTQ format, Illumina pipeline 1.2 or less\n";
		}else{ 
			print STDOUT "Automatic format detection: Solexa FASTQ format, Illumina pipeline 1.2 or less\n";
		}
	}elsif( $format eq "illumina" ){
		if( $user_defined ){
			print STDOUT "User defined format: Illumina FASTQ format, Illumina pipeline 1.3+\n";
		}else{
			print STDOUT "Automatic format detection: Illumina FASTQ format, Illumina pipeline 1.3+\n";
		}
	}
	
	# check for phred cutoff value
	if( defined( $phrd_cutoff ) ){
		$prob_cutoff = sprintf( "%.5f", &Q_to_p( $phrd_cutoff ) );
		print STDOUT "Info: Phred value of $phrd_cutoff converted to a probability value of $prob_cutoff\n";
	}

	# determine bwa trimming threshold
	my $threshold = 0;
	if( $bwa ){
		
		if( defined( $phrd_cutoff ) ){
			$threshold = $phrd_cutoff;
		}else{
			$threshold = &p_to_Q( $prob_cutoff );
		}
	}

	# go to fourth to last header line in file (last sequence ID line)
	my $line;
	while ( $line_counter < ( $last_line-3 ) ){
		$line = <INPUT>;
		$line_counter++;
	}

	# find tile number of last file entry (largest tile number)
	if( $line =~ /^@[\d\w\-\._]*:+\d*:(\d*):[\.\d]+:[\.\d]+/ ){
		$number_of_tiles = $1 + 1;
	}else{
		print STDERR "Error: File $input_file does not match Solexa ID format (note: this may be caused by an incomplete final entry/empty terminal lines)\n";
		next FILE_LOOP;
	}
	
	# check if HiSeq data
	if( $number_of_tiles == 69 ){
		$is_hiseq = 1;
		$number_of_tiles = 33;
	}
		
	# go to last sequence line in file and find read length 
	chomp( $line = <INPUT> );
	$read_length = length ($line);

	# set percentage of sequences to be used in stats calculations based on input sample size
	my $percentage = ( $sample * ($number_of_tiles - 1) * 4 ) / $line_counter;
	if( $percentage > 1 ){
		print STDERR "Warning: Desired sample size ($sample) greater than number of sequences per tile\n";
		$percentage = 1;
	}

	# open output quality file
	my $quality_file = $filename . ".quality";
	if( -e $quality_file ){
		die "Error: Quality file $quality_file already exists: $!\n";
	}
	open( QUALITY, ">$quality_file" )
		or die "Error: Failure opening $quality_file for writing: $!\n";	
	
	# open output matrix file
	my $matrix_file = $filename . ".matrix";
	if( -e $matrix_file ){
		die "error: matrix file $matrix_file already exists: $!\n";
	}
	open( MATRIX, ">$matrix_file" )
		or die "Error: Failure opening $matrix_file for writing: $!\n";

	# open segment table output file
	my $segment_output_file = $filename . ".segments";

	if( -e $segment_output_file ){
		die "Error: Segment output file $segment_output_file already exists: $!\n";
	}
	open( SEGMENT_OUTPUT, ">$segment_output_file" )
		or die "Error: Failure opening $segment_output_file for writing: $!\n";

	# ---------------------------------------------------

	# create hashes to store statistics
	my %mean_bytiles       = ();
	my %mean_count_bytiles = ();
	my %min_bytiles        = ();
	my %max_bytiles        = ();
	my %var_sum_bytiles    = ();
	my %var_count_bytiles  = ();
	my %trim_histogram     = ();
		
	# initialize hashes to store arrays of probabilities
	for( my $i = 0; $i < $number_of_tiles; $i++ ){

		my @new_array1;
		my @new_array2;
		my @new_array3;
		my @new_array4;
		my @new_array5;
		my @new_array6;

		for( my $j = 0; $j < $read_length; $j++ ){
		
			push( @new_array1, 0 );
			push( @new_array2, 0 );
			push( @new_array3, 1 );
			push( @new_array4, 0 );
			push( @new_array5, 0 );
			push( @new_array6, 0 );
		}

		$mean_bytiles{$i}        =  \@new_array1;
		$mean_count_bytiles{$i}  =  \@new_array2;
		$min_bytiles{$i}         =  \@new_array3;
		$max_bytiles{$i}         =  \@new_array4;
		$var_sum_bytiles{$i}     =  \@new_array5;
		$var_count_bytiles{$i}   =  \@new_array6;
	}

	for( my $j = 0; $j <= $read_length; $j++ ){
		$trim_histogram{$j} = 0;
	}

	# ---------------------------------------------------

	# reset file pointer on input
	seek (INPUT, 0, 0);
	$line_counter = 0;

	# step through sequences in input fastq file
	while( $line = <INPUT> ){

		$line_counter++;

		# find quality score sequence ID lines
		next if ( ( $line_counter % 4 ) != 1 );

		# roll simulated dice to determine which sequences will be recorded for stat estimates
		if( rand() < $percentage ){
		
			# retrieve sequence information
			my @qual;
			my $tile_number;
			
			# regular expression to find tile number from Solexa fastq file sequence IDs
			if( $line =~ /^@[\d\w\-\._]*:+\d*:(\d*):[\.\d]+:[\.\d]+/ ){
				$tile_number = $1;
			}else{
				die "Error: Lane ID at line number $line_counter not in correct Illumina format";
			}
			
			# change tile number if hiseq
			if( $is_hiseq ){
				$tile_number = $hiseq_tile{$tile_number};
			}
			
			# go to quality scores line
			$line = <INPUT>;
			$line_counter++;
			
			$line = <INPUT>;
			$line_counter++;
			
			chomp( $line = <INPUT> );
			$line_counter++;

			# store quality scores as an array
			@qual = split(//, $line);
			
			# transform quality values from ASCII into Solexa format
			for( my $i = 0; $i < scalar @qual; $i++ ){
			
				$qual[$i] = &q_to_Q($qual[$i]);
			}
			
			# calculate probability values
			my @prob;

			for( my $i = 0; $i < scalar @qual; $i++ ){
			
				$prob[$i] = &Q_to_p( $qual[$i] );
			}
			
			# assign all probabilities to holders
			for( my $i = 0; $i < scalar @prob; $i++ ){

				$mean_bytiles{$tile_number}->[$i] += $prob[$i];
				$mean_count_bytiles{$tile_number}->[$i]++;
			
				# evaluate each probability against current min and max, store if better 
				if( $minmax && ( $prob[$i] < $min_bytiles{$tile_number}->[$i] ) ){
					$min_bytiles{$tile_number}->[$i] = $prob[$i];
				}
				if( $minmax && ( $prob[$i] > $max_bytiles{$tile_number}->[$i] ) ){
					$max_bytiles{$tile_number}->[$i] = $prob[$i];
				}
			
				# tile 0 represents global probability
				$mean_bytiles{0}->[$i] += $prob[$i];
				$mean_count_bytiles{0}->[$i]++;
				
				# find global min and max
				if( $minmax && ( $prob[$i] < $min_bytiles{0}->[$i] ) ){
					$min_bytiles{0}->[$i] = $prob[$i];
				}
				if( $minmax && ( $prob[$i] > $max_bytiles{0}->[$i] ) ){
					$max_bytiles{0}->[$i] = $prob[$i];
				}
			}
			
			# calculate longest fragment
			my $longest_segment = 0;
			my $current_start   = 0;
			my $cutoff_hit      = 0;
			
			if( $bwa ){
				$longest_segment = &bwa_trim( $threshold, \@qual );
				
			}else{
				for( my $i = 0; $i < scalar @prob; $i++ ){

					if( $prob[$i] >= $prob_cutoff ){

						$cutoff_hit = 1;

						my $current_segment_length = $i - $current_start;
						$current_start = $i + 1;

						if( $current_segment_length > $longest_segment ){
							$longest_segment = $current_segment_length;
						}
					}
				}
				if( !$cutoff_hit ){ $longest_segment = $read_length; }
			}

			# add to counter
			$trim_histogram{$longest_segment}++;
		}
	}

	# calculate means and store in hashes
        for( my $j = 0; $j < $read_length; $j++ ){
                for( my $i = 0; $i < $number_of_tiles; $i++){
                        if( $mean_bytiles{$i}->[0] ){
	                        
				my $mean_pertile = $mean_bytiles{$i}->[$j] / $mean_count_bytiles{$i}->[$j];
	                
	 			$mean_bytiles{$i}->[$j] = $mean_pertile;
			}
		}
	}

	if( $variance ){ # if calculating variance, loop through file again to find differences from mean

		# reset file pointer on input
		seek (INPUT, 0, 0);
		$line_counter = 0;
	
		# step through sequences in input fastq file
		while( $line = <INPUT> ){
	
			$line_counter++;
	
			# find quality score sequence ID lines
			next if ( ( $line_counter % 4 ) != 1 );
	
			# roll simulated dice to determine which sequences will be recorded for stat estimates
			if( rand() < $percentage ){
			
				# retrieve sequence information
				my @qual;
				my $tile_number;
				
				# regular expression to find tile number from Solexa fastq file sequence IDs
				if( $line =~ /^@[\d\w\-\._]*:+\d*:(\d*):[\.\d]+:[\.\d]+/ ){
					$tile_number = $1;
				}else{
					die "Error: Lane ID at line number $line_counter not in correct Solexa format";
				}
				
				# change tile number if hiseq
				if( $is_hiseq ){
					$tile_number = $hiseq_tile{$tile_number};
				}
				
				# go to quality scores lines
				$line = <INPUT>;
				$line_counter++;
				
				$line = <INPUT>;
				$line_counter++;
				
				chomp( $line = <INPUT> );
				$line_counter++;
		
				# store quality scores as an array
				@qual = split(//, $line);
				
				# transform quality values from ASCII into Solexa Q format
				for( my $i = 0; $i < scalar @qual; $i++ ){
				
					$qual[$i] = &q_to_Q($qual[$i]);
				}
				
				# calculate probability values
				my @prob;

				for( my $i = 0; $i < scalar @qual; $i++ ){
			
					$prob[$i] = &Q_to_p( $qual[$i] );
				}

				# calculate sum of squared differences from the mean	
				for( my $i = 0; $i < scalar @prob; $i++ ){

					my $diff_from_mean = $mean_bytiles{$tile_number}->[$i] - $prob[$i];

					$var_sum_bytiles{$tile_number}->[$i] += $diff_from_mean ** 2;
					$var_count_bytiles{$tile_number}->[$i]++;

					# tile 0 represents global probability
					$var_sum_bytiles{0}->[$i] += $diff_from_mean ** 2;
					$var_count_bytiles{0}->[$i]++;
				}
			}
		}
	}

	# ---------------------------------------------------
	# print output to quality file
	
	# print header line of quality file
	for( my $i = 0; $i < $number_of_tiles; $i++ ){

		if( $mean_count_bytiles{$i}->[0] ){
		
			# assign column ID (G if global, otherwise tile #)
			my $col_id;

			if( $i == 0 ){
				$col_id = "global";
			}else{
				$col_id = "tile_$i";
			}
			
			print QUALITY "mean_$col_id\t";

			if( $variance ){ print QUALITY "var_$col_id\t"; }

			if( $minmax ){ print QUALITY "min_$col_id\tmax_$col_id\t" };

		}
	}
	print QUALITY "\n";

	# print stats for each read position for each tile to quality file
	for( my $j = 0; $j < $read_length; $j++ ){

		for( my $i = 0; $i < $number_of_tiles; $i++){
			
			if( $mean_count_bytiles{$i}->[0] > 0 ){
				
				# print mean, variance, minimum, and maximum
				print QUALITY sprintf( "%.5f", $mean_bytiles{$i}->[$j] ), "\t";

				if( $variance ){
					my $var_pertile = $var_sum_bytiles{$i}->[$j] / $var_count_bytiles{$i}->[$j];
					print QUALITY sprintf( "%.5f", $var_pertile ), "\t";
				}

				if( $minmax ){

					my $min = sprintf( "%.5f", $min_bytiles{$i}->[$j] );
					my $max = sprintf( "%.5f", $max_bytiles{$i}->[$j] );

					print QUALITY $min, "\t", $max, "\t";
				}
			}
		}
		print QUALITY "\n";
	}
	
	# ---------------------------------------------------
	# create matrix files for heat maps

	# print header line with the column headers "Tile" and each read position
	print MATRIX ".\t";

	for( my $i = 1; $i < ( $read_length + 1 ); $i++){

		print MATRIX $i, "\t";
	}
	print MATRIX "\n";

	# print stored mean probability values for each read position of each tile
	for( my $i = 1; $i < $number_of_tiles; $i++ ){
		
		# change tile names if hiseq
		if( $is_hiseq ){
			my $real_tile;
			foreach my $entry ( @hiseq_keys ){
				if( $hiseq_tile{$entry} == $i ){
					$real_tile = $entry;
				}
			}
			print MATRIX "tile_", $real_tile, "\t";
		}else{
			# print tile # at the beginning of each line
			print MATRIX "tile_", $i, "\t";
		}
		
		for( my $j = 0; $j < $read_length; $j++ ){

			if( $mean_count_bytiles{$i}->[$j] > 0 ){ 
				
				print MATRIX sprintf( "%.5f", $mean_bytiles{$i}->[$j] ), "\t";

			}else{
				print MATRIX "\t";
			}
		}

		print MATRIX "\n";
	}
	
	# ---------------------------------------------------
	# create table of read segments passing cutoff

	my $segment_sum = 0;

	for( my $j = 0; $j <= $read_length; $j++ ){
		$segment_sum += $trim_histogram{$j};
	}

	print SEGMENT_OUTPUT "read_length\tproportion_of_reads\n";

	for( my $j = 0; $j <= $read_length; $j++ ){

		my $proportion = sprintf( "%.4f", ( $trim_histogram{$j} / $segment_sum ) );

		print SEGMENT_OUTPUT $j, "\t", $proportion, "\n";
	}

	# ---------------------------------------------------
	# close files

	close QUALITY
		or die "Error: Cannot close quality file $quality_file: $!";
	
	close MATRIX
		or die "Error: Cannot close matrix file $matrix_file: $!";

	close INPUT
		or die "Error: Cannot clost input file $input_file: $!";

	close SEGMENT_OUTPUT
		or die "Error: Cannot close segment table file $segment_output_file: $!";
	
	# ---------------------------------------------------	
	# call matrix2png to create heat map from matrix file
	
	`matrix2png -data $filename.matrix -map -1 -missingcolor 100:100:100 -rcsd -title $filename -range 0:0.75 -size 10:10 > $filename.png`;
	
	# ----------------------------------------------------	
	# print line graph of mean probabilities for each tile at each read position from quality file
	
	# calculate number of columns in quality file that do not contain mean probability data
	my $extra_columns = 0;

	if( $variance ){
		$extra_columns += 1;
	}
	if( $minmax ){
		$extra_columns += 2;
	}

	# define R script to graph quality file data
	my $line_graph_R_script = "args <- commandArgs(trailingOnly = TRUE)

	filename <- args[1]

	extra_columns <- as.numeric(args[2])

	d <- read.table(filename, header=T)

	pdf( paste(filename,'.pdf', sep = '') )

	plot(1:length(d[,1]), d[,1], type='p', col='red', ylim=c(0,0.631), xlab='position along read\n[global average in red, individual tile averages in black]', ylab='mean probability of error')

	title(paste(filename))

	for(i in c(1:length(d[1,]))){

	        if( ( i + extra_columns ) %% ( 1 + extra_columns ) == 0 ){

			lines(1:length(d[,i]), d[,i], lty=3)
		}	
	}
	
	lines(1:length(d[,1]), d[,1], type='b', col='red')
	";

	# call R to perform plotting of quality data	
	`echo "$line_graph_R_script" | R --slave --args $filename.quality $extra_columns`;

	# ----------------------------------------------------
	# print histogram of read segments passing cutoff

	# define R script to graph segment table
	my $histogram_R_script = "args <- commandArgs(trailingOnly = TRUE)

	filename <- args[1]

	cutoff <- args[2]

	d <- read.table(filename, header=T)

	pdf( paste(filename,'.hist.pdf', sep = ''), width = 11 )

	barplot(d[,2], names.arg = d[,1], space = 0, col='blue', xlab='length of longest contiguous read segment passing cutoff', ylab='proportion of reads', axis.lty = 1, cex.names = 0.9 )

	title(paste(filename, '        p cutoff = ', cutoff ) )

	";

	# call R to produce bar plot of read segment data
	`echo "$histogram_R_script" | R --slave --args $filename.segments $prob_cutoff`;

	# print "{file} completed"
	print STDOUT $input_file, " QA completed\n";

}	

# terminate
exit 0 or die "Error: Program $0 ended abnormally: $!\n";

# ----------------------------------------------------	

# Change ASCII character to Phred/Solexa quality score
sub q_to_Q($){

        my $q = shift;
        if( $format eq "sanger" ){
        	return ord($q) - 33;
        }else{
        	return ord($q) - 64;
        }
}

# Change Phred/Solexa quality score to ASCII character
sub Q_to_q($){

        my $Q = shift;
        if( $format eq "sanger" ){
        	return chr($Q + 33);
        }else{
        	return chr($Q + 64);
        }
}

# Change Phred/Solexa quality score to probability
sub Q_to_p($){

	my $Q = shift;

	if( $format eq "solexa" ){
		return (10**(-$Q/10)) / ((10**(-$Q/10))+1);
	}else{
		return (10**(-$Q/10));
	}
}

# Change probability to Phred/Solexa quality score
sub p_to_Q($){

	my $p = shift;

        if( $format && $format eq "solexa" ){
			return -10 * &log10($p/(1-$p));
        }else{
			return -10 * &log10($p);
        }
}

# log10 function
sub log10($){

	my $number = shift;
	return log($number)/log(10);
}

# print summary of Q, q and p values
sub print_lookup_table(){
	
	print STDOUT "Char\tQPhred\tProb\n";
	for( my $i = -5; $i <= 40; $i++ ){
		
		my $q = &Q_to_q($i);
		my $p = &Q_to_p($i);
		
		print STDOUT $q, "\t";
		print STDOUT $i, "\t";
		print STDOUT sprintf("%.8f", $p), "\n";
	}
}

# automatic format detection
sub get_format(*$){
	
	# set function variables
	local *FILEHANDLE = shift;
	my $number_of_sequences = shift;
	my $format = "";
	
	# set regular expressions
	my $sanger_regexp = qr/[!"#$%&'()*+,-.\/0123456789:]/;
	my $solexa_regexp = qr/[\;<=>\?]/;
	my $solill_regexp = qr/[JKLMNOPQRSTUVWXYZ\[\]\^\_\`abcdefgh]/;
	my $all_regexp = qr/[\@ABCDEFGHI]/;
	
	# set counters
	my $sanger_counter = 0;
	my $solexa_counter = 0;
	my $solill_counter = 0;
	
	# go to file start
	seek(FILEHANDLE, 0, 0);
	
	# step through quality scores
	for( my $i = 0; $i < $number_of_sequences; $i++ ){
		
		# retrieve qualities
		<FILEHANDLE>;
		<FILEHANDLE>;
		<FILEHANDLE>;
		my $qualities = <FILEHANDLE>;
		chomp($qualities);
		
		# check qualities
		if( $qualities =~ m/$sanger_regexp/ ){
			$sanger_counter = 1;
			last;
		}
		if( $qualities =~ m/$solexa_regexp/ ){
			$solexa_counter = 1;
		}
		if( $qualities =~ m/$solill_regexp/ ){
			$solill_counter = 1;
		}
	}
	
	# determine format
	if( $sanger_counter ){
		$format = "sanger";
	}elsif( !$sanger_counter && $solexa_counter ){
		$format = "solexa";
	}elsif( !$sanger_counter && !$solexa_counter && $solill_counter ){
		$format = "illumina";
	}
	
	# go to file start
	seek(FILEHANDLE, 0, 0);
	
	# return file format
	return( $format );
}

# trim sequences using the BWA algorithm
sub bwa_trim($$){
	
	my $threshold = shift;
	my $array_ref = shift;
	
	my @array  = @{$array_ref};
	my $length = scalar @array;
	
	# only calculate if quality fails near end
	if( $array[$#array] >= $threshold ){
		return $length;
	}
	
	# run bwa equation
	my @arg;
	for( my $i = 0; $i < $length - 1; $i++ ){
		
		my $x = $i + 1;
		for( my $j = $x; $j < $length; $j++ ){	
			$arg[$x] += $threshold - $array[$j];
		}
	}
	
	# find number of 5' bases to retain
	my $index = 0;
	my $maxval = 0;
	for ( 1 .. $#arg ){
		if ( $maxval < $arg[$_] ){
        	$index = $_;
        	$maxval = $arg[$_];
    	}
	}
	
	# number of bases to retain
	return $index;
}
