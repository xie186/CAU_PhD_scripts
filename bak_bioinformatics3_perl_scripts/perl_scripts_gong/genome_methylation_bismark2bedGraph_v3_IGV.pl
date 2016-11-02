#!/usr/bin/perl -w

# Count methylation of cytosine genome-wide from Bismark methylation caller output and generates a BedGraph

# Script origninally created by O. Tam, modified by F. Krueger on 16 Mar 2011.
# Corrected read coordinates to being 0 based, inspired by Timothy Hughes, 08 June 2011
# Bug with 0-based coordinates fixed by Michael A. Bentley, 13 Sep 2011
#  1_based depth modified by xie 20 Oct 2011

use strict;
use warnings;
use Carp;
use Getopt::Long;

my $coverage_threshold = 4; # Minimum number of reads covering before calling methylation status
my $remove;
my $help;

GetOptions("cutoff=i" => \$coverage_threshold,
	   "remove_spaces" => \$remove,
	   "h|help" => \$help,
	  );
if ($help){
  die usage();
}

if(scalar @ARGV < 1){
  warn "Missing input file\n";
  die usage();
}

my $infile = shift @ARGV;

if ($remove){

  warn "\nNow replacing whitespaces in the sequence ID field in the Bismark mapping output prior to BedGraph conversion\n\n";

  open (IN,$infile) or die $!;

  my $removed_spaces_outfile = $infile;
  $removed_spaces_outfile =~ s/$/.spaces_removed.txt/;

  open (REM,'>',$removed_spaces_outfile) or die "Couldn't write to file $removed_spaces_outfile: $!\n";

  $_ = <IN>;
  print REM $_; ### Bismark version header

  while (<IN>){
    chomp;
    my ($id,$strand,$chr,$pos,$context) = (split (/\t/));
    $id =~ s/\s+/_/g;
    print REM join ("\t",$id,$strand,$chr,$pos,$context),"\n";
  }

  close IN or die $!;
  close REM or die $!;

  ### changing the infile name to the new outfile without spaces
  $infile = $removed_spaces_outfile;
}


open my $ifh, "sort -k3,3 -k4,4n $infile |" or die "Input file could not be sorted. $!";

# print "Chromosome\tStart Position\tEnd Position\tMethylation Percentage\n";

my @methylcalls = qw (0 0 0); # [0] = methylated, [1] = unmethylated, [2] = total

############################################# m.a.bentley - moved the variables out of the while loop to hold the current line data {

my $name;
my $meth_state;
my $chr = "";
my $pos = 0;
my $meth_state2;

my $last_pos;
my $last_chr;

#############################################  }

while(my $line = <$ifh>){
  next if $line =~ /^Bismark/;
  chomp $line;

  ########################################### m.a.bentley - (1) set the last_chr and last_pos variables early in the while loop, before the line split (2) removed unnecessary setting of same variables in if statement {

  $last_chr = $chr;
  $last_pos = $pos;
  ($name, $meth_state, $chr, $pos, $meth_state2) = split "\t", $line;

  if(($last_pos ne $pos) || ($last_chr ne $chr)){
    generate_output() if $methylcalls[2] > 0;
    @methylcalls = qw (0 0 0);
  }

  #############################################  }

  my $validated = validate_methylation_call($meth_state, $meth_state2);
  unless($validated){
    warn "Methylation state of sequence ($name) in file ($infile) on line $. is inconsistent (meth_state is $meth_state, meth_state2 = $meth_state2)\n";
    next;
  }
  if($meth_state eq "+"){
    $methylcalls[0] ++;
    $methylcalls[2] ++;
  }
  else{
    $methylcalls[1] ++;
    $methylcalls[2] ++;
  }
}

############################################# m.a.bentley - set the last_chr and last_pos variables for the last line in the file (outside the while loop's scope using the method i've implemented) {

$last_chr = $chr;
$last_pos = $pos;
generate_output() if $methylcalls[2] > 0;

#############################################  }


close $ifh or die $!;


sub generate_output{
  my $methcount = $methylcalls[0];
  my $nonmethcount = $methylcalls[1];
  my $totalcount = $methylcalls[2];
  croak "Should not be generating output if there's no reads to this region" unless $totalcount > 0;
  croak "Total counts ($totalcount) is not the sum of the methylated ($methcount) and unmethylated ($nonmethcount) counts" if $totalcount != ($methcount + $nonmethcount);

  ############################################# m.a.bentley - declare a new variable 'bed_pos' to distinguish from bismark positions (-1) - previous scripts modified the last_pos variable earlier in the script leading to problems in meth % calculation {

  my $bed_pos = $last_pos;  ###  modi xie 1_based
  my $meth_percentage;
  ($totalcount >= $coverage_threshold) ? ($meth_percentage = ($methcount/$totalcount) * 100) : ($meth_percentage = undef);
  #  $meth_percentage =~ s/(\.\d\d).+$/$1/ unless $meth_percentage =~ /^Below/;
  print "$last_chr\t$bed_pos\t$bed_pos\t$meth_percentage\n" if defined $meth_percentage;
  #############################################  }
}

sub validate_methylation_call{
  my $meth_state = shift;
  croak "Missing (+/-) methylation call" unless defined $meth_state;
  my $meth_state2 = shift;
  croak "Missing alphabetical methylation call" unless defined $meth_state2;
  my $is_consistent;
  ($meth_state2 =~ /^z/i) ? ($is_consistent = check_CpG_methylation_call($meth_state, $meth_state2)) 
                          : ($is_consistent = check_nonCpG_methylation_call($meth_state,$meth_state2));
  return 1 if $is_consistent;
  return 0;
}

sub check_CpG_methylation_call{
  my $meth1 = shift;
  my $meth2 = shift;
  return 1 if($meth1 eq "+" && $meth2 eq "Z");
  return 1 if($meth1 eq "-" && $meth2 eq "z");
  return 0;
}

sub check_nonCpG_methylation_call{
  my $meth1 = shift;
  my $meth2 = shift;
  return 1 if($meth1 eq "+" && $meth2 eq "C");
  return 1 if($meth1 eq "+" && $meth2 eq "X");
  return 1 if($meth1 eq "+" && $meth2 eq "H");
  return 1 if($meth1 eq "-" && $meth2 eq "c");
  return 1 if($meth1 eq "-" && $meth2 eq "x");
  return 1 if($meth1 eq "-" && $meth2 eq "h");
  return 0;
}

sub usage{
  print <<EOF

  Usage: genome_methylation_bismark2bedGraph.pl (--cutoff [threshold] ) [Bismark methylation caller output] > [output]

  --cutoff [threshold]  -  The minimum number of times a methylation state was
                           seen for that nucleotide before its methylation 
                           percentage is reported.
                           Default is no threshold

  --remove_spaces       -  Replaces whitespaces in the sequence ID field with underscores to allow sorting.

  The output file is a tab-delimited BedGraph file with the following information:

  <Chromosome> <Start Position> <End Position> <Depth> <Methylation Percentage>

  Bismark methylation caller (v0.2.0 or later) should produce three output files
    (CpG, CHG and CHH) when using the "--comprehensive" option
    (Two files if using the "--merge_non_CpG" option).
    To count both CpG and Non-CpG, combine the output files.

  Bismark methylation caller (v0.1.5 or earlier) should produce two output files
    (CpG and Non-CpG) when using the "--comprehensive" option.
    To count both CpG and Non-CpG, combine the two output files.



                          Script last modified: 13 Sept 2011.

EOF
    ;
  exit 1;
}


