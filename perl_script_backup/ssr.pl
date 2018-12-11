#!/usr/bin/perl
#ssr.pl
#S.Cartinhour. 5/2000

#Search for simple sequence repeats in 
#FASTA-formatted DNA sequences. Each FASTA record
#looks like this (the record delimiter is ">"):


#    >SequenceID with optional text on same line
#    sequence data on one or more lines

#for example,

#    >12345xyz this is a nice sequence of the Foo gene
#    atgccatgataggactatttattttttctcact
#    gaccatcacccncacttaaagcatgggcggatttacta
#    etc.

$/ = ">";
$| = 1;
my $seqcount;

#motif-repeat parameters:
#specify motif length, minimum number of repeats.
#modify according to researcher's preferences
my @specs = ([2,9],  #dinucl. with >= 9 repeats
	     [3,6],  #trinucl. with >= 6 repeats
	     [4,5]); #tetranucl. with >= 5 repeats


while(<>){ #FASTA formatted sequences as input
    chomp;
    my ($titleline, $sequence) = split(/\n/,$_,2);
    next unless ($sequence && $titleline);
    $seqcount++;
    my ($id) = $titleline =~ /^(\S+)/; #the ID is the first whitespace-
                                       #delimited item on titleline
    $sequence =~ s/\s//g; #concatenate multi-line sequence
    study($sequence);     #is this necessary?
    my $seqlength = length($sequence);
    my $ssr_number = 1;   #track multiple ssrs within a single sequence
    my %locations;        #track location of SSRs as detected
     my $i;
    for($i=0; $i<scalar(@specs); $i++){ #test each spec against sequence
	my $motiflength = $specs[$i]->[0];
	my $minreps = $specs[$i]->[1] - 1;
	my $regexp = "(([gatc]{$motiflength})\\2{$minreps,})";
	while ($sequence =~ /$regexp/ig){
	    my $motif = lc($2); my $ssr = $1;
	    #reject "aaaaaaaaa", "ggggggggggg", etc.
	    next if &homopolymer($motif,$motiflength); #comment out this line to report monomers
	    my $ssrlength = length($ssr);          #overall SSR length
	    my $repeats = $ssrlength/$motiflength; #number of rep units
	    my $end = pos($sequence);              #where SSR ends
	    pos($sequence) = $end - $motiflength;  #see docs
	    my $start = $end - $ssrlength + 1;     #where SSR starts
	    print STDOUT join("\t", $id, $ssr_number++,
			      $motiflength, $motif, $repeats, 
			      $start, $end, $seqlength), "\n"
		if (&novel($start, \%locations));  #count SSR only once
	}
    }
}

sub homopolymer {
    #return true if motif is repeat of single nucleotide
    my ($motif,$motiflength) = @_;
    my ($reps) = $motiflength - 1;
    return 1 if ($motif =~ /([gatc])\1{$reps}/);
    return 0;
}

sub novel {
    my($position, $locationsref) = @_;
    if(defined $locationsref->{$position}) {
       return undef;
   } else {
       $locationsref->{$position} = 1;
       return 1;
   }
}

       
