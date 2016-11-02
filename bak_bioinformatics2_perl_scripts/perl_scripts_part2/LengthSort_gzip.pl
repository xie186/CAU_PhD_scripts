#!/usr/bin/env perl

# Program: LengthSort.pl v.1.12
# Sorts trimmed Illumina reads based on a user-defined length threshold
# Murray Cox
# Massey University Palmerston North, New Zealand
# Email contact <m.p.cox@massey.ac.nz>
# March 2012

# Version 1.4: Reduced stringency for header line matching

# Version 1.5: Minor modifications

# Version 1.6: Modified for HiSeq-2000 data

# Version 1.7: Modified for OLB 1.9 HiSeq data

# Version 1.8: Modified to accept new Cassava 1.8 FASTQ header lines
#              Illumina output data now in Sanger FASTQ format by default
#              Should also work with Sequence Read Archive files

# Version 1.9: Modified to accept new 48-tile Illumina variants

# Version 1.10: FASTQ header line bug fixed

# Version 1.11: FASTQ header line fixed for MiSeq data

# Version 1.12: Added ability to save files to a specific directory
# Change suggested by Cameron Jack
# John Curtin School of Medical Research, Australian National University
# Email contact <cameron.jack@anu.edu.au>

# Released under GNU General Public License version 3

use strict;
use warnings;
use Getopt::Long;
use File::Spec;

# globals
my $length = 25;
my $paired = 0;
my $directory;

# usage
my $usage = "
$0 one single-end or two paired-end FASTQ files [-l|length 25] [-d|directory path]\n
-l|length       length cutoff [defaults to 25 nucleotides]
-d|directory    path to directory where output files are saved
\n";

# read user options
GetOptions(
	"l|length=i"     => \$length,
	"d|directory=s"  => \$directory
);

# check for single-end or paired-end data
my @files = @ARGV;
if( !$files[0] || length(@files) > 2 ){
	die $usage;
}
if( scalar(@files) == 2 ){
	$paired = 1;
}

# open file(s)
unless( -e $files[0] ){
	die "error: file $files[0] does not exist\n";
}
open( FIRST, "zcat $files[0]|" )
	or die "error: failure opening $files[0] for reading: $!\n";
if( $paired ){
	unless( -e $files[1] ){
		die "error: file $files[1] does not exist\n";
	}
	open( SECOND, "zcat $files[1]|" )
		or die "error: failure opening $files[1] for reading: $!\n";	
}

# check for FASTQ format
my $first_line;
my $second_line;
$first_line = <FIRST>;
if( substr($first_line, 0, 1) ne "@" ){
	die "error: $files[0] does not appear to be in FASTQ format\n";
}
if( $paired ){
	$second_line = <SECOND>;
	if( substr($second_line, 0, 1) ne "@" ){
		die "error: $files[1] does not appear to be in FASTQ format\n";
	}
}

# check for similar header identifiers
my $first_id;
my $second_id;

if( $paired ){
	
	# first of pair
	if( $first_line !~ /\S+\s\S+/ ){
		if( $first_line =~ /(\S*)\/\S*/ ){
			$first_id = $1;
		}else{
			$first_id = $first_line;
		}
	}elsif( $first_line =~ /\S+\s\S+/ ){
		my @first_line_elements = split( /\s+/, $first_line );
		pop @first_line_elements;
		$first_id = join( " ", @first_line_elements );
	}else{
		$first_id = $first_line;
	}
	
	# second of pair
	if( $second_line !~ /\S+\s\S+/ ){
		if( $second_line =~ /(\S*)\/\S*/ ){
			$second_id = $1;
		}else{
			$second_id = $second_line;
		}
	}elsif( $second_line =~ /\S+\s\S+/ ){
		my @second_line_elements = split( /\s+/, $second_line );
		pop @second_line_elements;
		$second_id = join( " ", @second_line_elements );
	}else{
		$second_id = $second_line;
	}
	
	# check that IDs are similar
	if( $first_id ne $second_id ){
		die "error: files $files[0] and $files[1] do not seem to be paired\n";
	}
}

# check for same file lengths
if( $paired ){
	
	my $first_line_counter = 0;
	my $second_line_counter = 0;
	
	$first_line_counter++ while <FIRST>;
	$second_line_counter++ while <SECOND>;
	
	if( $first_line_counter != $second_line_counter ){
		die "error: files $files[0] and $files[1] appear to be different lengths\n";
	}
}

# reset file pointers
seek(FIRST, 0, 0);
if( $paired ){
	seek(SECOND, 0, 0);
}

# make output file(s)
my $single_file;
if ( $directory ){
	# remove any trailing '/'
	$directory =~ s/\/\z//;
	my @file_ending_elements = split(/\//, $files[0]);
	my $item = scalar @file_ending_elements - 1;
	my $file_name = $file_ending_elements[$item] . ".single";
	$single_file = File::Spec->catpath( undef, $directory, $file_name );
}else{
	$single_file = $files[0] . ".single";
}
if( -e $single_file ){
	die "error: file $single_file already exists\n";
}
open( SINGLE, ">$single_file" )
	or die "error: failure opening $single_file for writing: $!\n";

my $discard_file;
if ( $directory ){
	# remove any trailing '/'
	$directory =~ s/\/\z//;
	my @file_ending_elements = split(/\//, $files[0]);
	my $item = scalar @file_ending_elements - 1;
	my $file_name = $file_ending_elements[$item] . ".discard";
	$discard_file = File::Spec->catpath( undef, $directory, $file_name );
}else{
	$discard_file = $files[0] . ".discard";
}
if( -e $discard_file ){
	die "error: file $discard_file already exists\n";
}
open( DISCARD, ">$discard_file" )
	or die "error: failure opening $discard_file for writing: $!\n";

my $paired_file1;
my $paired_file2;
if( $paired ){
	
	if ( $directory ){
		# remove any trailing '/'
		$directory =~ s/\/\z//;
		my @file_ending_elements = split(/\//, $files[0]);
		my $item = scalar @file_ending_elements - 1;
		my $file_name = $file_ending_elements[$item] . ".paired1";
		$paired_file1 = File::Spec->catpath( undef, $directory, $file_name );
	}else{
		$paired_file1 = $files[0] . ".paired1";
	}
	if( -e $paired_file1 ){
		die "error: file $paired_file1 already exists\n";
	}
	open( PAIRED1, ">$paired_file1" )
		or die "error: failure opening $paired_file1 for writing: $!\n";
	
	if ( $directory ){
		# remove any trailing '/'
		$directory =~ s/\/\z//;
		my @file_ending_elements = split(/\//, $files[0]);
		my $item = scalar @file_ending_elements - 1;
		my $file_name = $file_ending_elements[$item] . ".paired2";
		$paired_file2 = File::Spec->catpath( undef, $directory, $file_name );
	}else{
		$paired_file2 = $files[0] . ".paired2";
	}
	if( -e $paired_file2 ){
		die "error: file $paired_file2 already exists\n";
	}
	open( PAIRED2, ">$paired_file2" )
		or die "error: failure opening $paired_file2 for writing: $!\n";
}

# read in sequences 
until( eof(FIRST) ){
	
	# read sequences
	chomp( my $first_header_line1 = <FIRST> );
	chomp( my $first_sequence_line = <FIRST> );
	chomp( my $first_header_line2 = <FIRST> );
	chomp( my $first_quality_line = <FIRST> );
	
	my $second_header_line1;
	my $second_sequence_line;
	my $second_header_line2;
	my $second_quality_line;
	if( $paired ){
		chomp( $second_header_line1 = <SECOND> );
		chomp( $second_sequence_line = <SECOND> );
		chomp( $second_header_line2 = <SECOND> );
		chomp( $second_quality_line = <SECOND> );
	}
		
	# check header lines
	if( $paired ){
	
		my $first_header_id;
		my $second_header_id;

		# first of pair
		if( $first_header_line1 !~ /\S+\s\S+/ ){
			if( $first_header_line1 =~ /(\S*)\/\S*/ ){
				$first_header_id = $1;
			}else{
				$first_header_id = $first_header_line1;
			}
		}elsif( $first_header_line1 =~ /\S+\s\S+/ ){
			my @first_header_line_elements = split( /\s+/, $first_header_line1 );
			pop @first_header_line_elements;
			$first_header_id = join( " ", @first_header_line_elements );
		}else{
			$first_header_id = $first_header_line1;
		}
		
		# second of pair
		if( $second_header_line1 !~ /\S+\s\S+/ ){
			if( $second_header_line1 =~ /(\S*)\/\S*/ ){
				$second_header_id = $1;
			}else{
				$second_header_id = $second_header_line1;
			}
		}elsif( $second_header_line1 =~ /\S+\s\S+/ ){
			my @second_header_line_elements = split( /\s+/, $second_header_line1 );
			pop @second_header_line_elements;
			$second_header_id = join( " ", @second_header_line_elements );
		}else{
			$second_header_id = $second_header_line1;
		}
		
		# check that IDs are similar
		if( $first_header_id ne $second_header_id ){
			die "error: header lines in $files[0] and $files[1] do not seem to be paired\n";
		}
	}
	
	# print to file
	if( $paired ){
		
		if( length($first_sequence_line) >= $length && length($second_sequence_line) >= $length ){	
			print PAIRED1 $first_header_line1, "\n", $first_sequence_line, "\n", $first_header_line2, "\n", $first_quality_line, "\n";
			print PAIRED2 $second_header_line1, "\n", $second_sequence_line, "\n", $second_header_line2, "\n", $second_quality_line, "\n";
		}
		elsif( length($first_sequence_line) < $length && length($second_sequence_line) < $length ){	
			print DISCARD $first_header_line1, "\n", $first_sequence_line, "\n", $first_header_line2, "\n", $first_quality_line, "\n";
			print DISCARD $second_header_line1, "\n", $second_sequence_line, "\n", $second_header_line2, "\n", $second_quality_line, "\n";
		}
		elsif( length($first_sequence_line) < $length && length($second_sequence_line) >= $length ){	
			print DISCARD $first_header_line1, "\n", $first_sequence_line, "\n", $first_header_line2, "\n", $first_quality_line, "\n";
			print SINGLE $second_header_line1, "\n", $second_sequence_line, "\n", $second_header_line2, "\n", $second_quality_line, "\n";
		}
		elsif( length($first_sequence_line) >= $length && length($second_sequence_line) < $length ){	
			print SINGLE $first_header_line1, "\n", $first_sequence_line, "\n", $first_header_line2, "\n", $first_quality_line, "\n";
			print DISCARD $second_header_line1, "\n", $second_sequence_line, "\n", $second_header_line2, "\n", $second_quality_line, "\n";
		}		
	}
	else{
		
		if( length($first_sequence_line) >= $length ){
			print SINGLE $first_header_line1, "\n", $first_sequence_line, "\n", $first_header_line2, "\n", $first_quality_line, "\n";
		}else{
			print DISCARD $first_header_line1, "\n", $first_sequence_line, "\n", $first_header_line2, "\n", $first_quality_line, "\n";
		}
	}
}

# close input files
close FIRST or die "error: failure closing $files[0]: $!\n";
if( $paired ){
	close SECOND or die "error: failure closing $files[1]: $!\n";
}

# close output files
close SINGLE or die "error: failure closing $single_file: $!\n";
close DISCARD or die "error: failure closing $discard_file: $!\n";
if( $paired ){
	close PAIRED1 or die "error: failure closing $paired_file1: $!\n";
	close PAIRED2 or die "error: failure closing $paired_file2: $!\n";
}

# terminate
exit 0 or die "error: $0 ended abnormally: $!\n";
