#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 1;
open F,$ARGV[0] or die;
while(<F>){
	next if !/^chr/;
	my @tem=split;
        next if $tem[4] =~ /\,/;
	#my ($gt58,$dp58)=$tem[-4]=~/(\d\/\d)\:\d+\,\d+\:(\d+)\:/;
        my ($gt58,$dp58) = (split(/:/, $tem[-4]))[0,2];
	if($tem[-4] eq "./."){
            $gt58="0/0";
            $dp58=0;
        }
        #my ($gt5003,$dp5003) = $tem[-3] =~ /(\d\/\d)\:\d+\,\d+\:(\d+)\:/;
        my ($gt5003,$dp5003) = (split(/:/, $tem[-3]))[0,2];
        if($tem[-3] eq "./."){
            $gt5003="0/0";
            $dp5003=0;
        }
        #my ($gt478,$dp478) = $tem[-2] =~ /(\d\/\d)\:\d+\,\d+\:(\d+)\:/;
        my ($gt478,$dp478) = (split(/:/, $tem[-2]))[0,2];
        if($tem[-2] eq "./."){
            $gt478="0/0";
            $dp478=0;
        }
        #my ($gt8112,$dp8112)=$tem[-1]=~/(\d\/\d)\:\d+\,\d+\:(\d+)\:/;
        my ($gt8112,$dp8112) = (split(/:/, $tem[-1]))[0,2];
        if($tem[-1] eq "./."){
            $gt8112="0/0";
            $dp8112=0;
        }

	next if ($dp5003 < 5 || $dp8112 < 5 || $dp478 < 5);
	next if ($gt5003 eq $gt8112);
	next if ($gt478 eq "0/1" || $gt5003 eq "0/1" || $gt8112 eq "0/1");# || $gt58 eq "0/1";
	print;
}
close F;

sub usage{
    my $die = <<DIE;
    perl *.pl <vcf> vcf file are generated by gatk 2.7.0
    vcf file: z58,5003,478,8112
DIE
}