#!/usr/bin/perl -w
die("<allele freq> <hapmap> \n") unless @ARGV==2;
#cp ../cau_freq2.pl /NAS1/zeamxie/perl_scripts_NG_jiao/cau_freq_rare_alle_breed.pl
open F,$ARGV[0] or die;
while(<F>){
	my @tem=split;
#	next if $tem[0] ne $chr;
	$hash{$tem[0]}{$tem[1]}=$tem[3] if $tem[-1]<0.05;
#	$tar{$tem[0]}{$tem[1]}++;
}
close F;


open G,$ARGV[1] or die;
while(<G>){
	my @tem=split;
	next if !$hash{$tem[2]}{$tem[3]};
	if($tem[11]!~/N/i){
		$z58++;# if $tar{$tem[1]};
		$z58_r++ if $hash{$tem[2]}{$tem[3]} && $hash{$tem[2]}{$tem[3]} eq $tem[11];
	}
        if($tem[23]!~/N/i){
                $c478++;# if $tar{$tem[1]};
	        $c478_r++ if $hash{$tem[2]}{$tem[3]} && $hash{$tem[2]}{$tem[3]} eq $tem[23];
        }
        if($tem[108]!~/N/i){
                $c8112++;#if $tar{$tem[1]};
                $c8112_r++ if $hash{$tem[2]}{$tem[3]} && $hash{$tem[2]}{$tem[3]} eq $tem[108];
        }

        if($tem[281]!~/N/i){
                $b73++;#if $tar{$tem[1]};
                $b73_r++ if $hash{$tem[2]}{$tem[3]} && $hash{$tem[2]}{$tem[3]} eq $tem[281];
        }
}
close G;

print "z58: $z58 $z58_r ",$z58_r/$z58,", c478; $c478 $c478_r ",$c478_r/$c478,", c8112: $c8112 $c8112_r ",$c8112_r/$c8112,", B73: $b73 $b73_r ",$b73_r/$b73,"\n";


