#!/usr/bin/perl
use Bio::Perl;

$seq_object=get_sequence('swissprot',"ROA1_HUMAN");

$blast_report=blast_sequence($seq_object);

write_blast(">roa1.blast",$blast_report); 
