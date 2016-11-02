#!/usr/bin/perl
use strict;
die usage() if @ARGV == 0;

my $annotation = $ARGV[0];
my ($pDMPs_total, $pDMPs_transposon, $pDMPs_intergenic, $pDMPs_downstream, $pDMPs_upstream, $pDMPs_intro, $pDMPs_exon) = (0,0,0,0,0,0,0);
my ($sDMPs_total, $sDMPs_transposon, $sDMPs_intergenic, $sDMPs_downstream, $sDMPs_upstream, $sDMPs_intro, $sDMPs_exon) = (0,0,0,0,0,0,0);
my %pDMPs;
my %sDMPs;

open NEW,"$annotation" or die;
while(<NEW>){
	chomp;
	my @array = split /\s+/;
	if($array[11] < 0.01){
		my $target = "$array[0]"."-"."$array[1]";
		if($array[12] eq "N"){
			$sDMPs{$target}.="$array[16]\t";
		}
		elsif($array[12] eq "Y"){
			$pDMPs{$target}.="$array[16]\t";
		}
	}
}
close NEW;

foreach my $key(keys %pDMPs){
	$pDMPs_total++;
	if($pDMPs{$key} =~ /transposon/){
		$pDMPs_transposon++;
	}
	elsif($pDMPs{$key} =~ /exon/){
		$pDMPs_exon++;
	}
	elsif($pDMPs{$key} =~ /intro/){
		$pDMPs_intro++;
	}
	elsif($pDMPs{$key} =~ /upstream/){
		$pDMPs_upstream++;
	}
	elsif($pDMPs{$key} =~ /downstream/){
		$pDMPs_downstream++;
	}
	else{
		$pDMPs_intergenic++;
	}
}

foreach my $key(keys %sDMPs){
	$sDMPs_total++;
        if($sDMPs{$key} =~ /transposon/){
                $sDMPs_transposon++;
        }
        elsif($sDMPs{$key} =~ /exon/){
                $sDMPs_exon++;
        }
        elsif($sDMPs{$key} =~ /intro/){
                $sDMPs_intro++;
        }
        elsif($sDMPs{$key} =~ /upstream/){
                $sDMPs_upstream++;
        }
        elsif($sDMPs{$key} =~ /downstream/){
                $sDMPs_downstream++;
        }
        else{
                $sDMPs_intergenic++;
        }
}
my $sDMPs_result_intergenic=$sDMPs_intergenic/$sDMPs_total;
my $sDMPs_result_downstream=$sDMPs_downstream/$sDMPs_total;
my $sDMPs_result_upstream=$sDMPs_upstream/$sDMPs_total;
my $sDMPs_result_intro=$sDMPs_intro/$sDMPs_total;
my $sDMPs_result_exon=$sDMPs_exon/$sDMPs_total;
my $sDMPs_result_transposon=$sDMPs_transposon/$sDMPs_total;
my $pDMPs_result_intergenic=$pDMPs_intergenic/$pDMPs_total;
my $pDMPs_result_downstream=$pDMPs_downstream/$pDMPs_total;
my $pDMPs_result_upstream=$pDMPs_upstream/$pDMPs_total;
my $pDMPs_result_intro=$pDMPs_intro/$pDMPs_total;
my $pDMPs_result_exon=$pDMPs_exon/$pDMPs_total;
my $pDMPs_result_transposon=$pDMPs_transposon/$pDMPs_total;
print "Intergenic\tDownstream\tUpstream\tIntron\tExon\tTransposon\n$sDMPs_result_intergenic\t$sDMPs_result_downstream\t$sDMPs_result_upstream\t$sDMPs_result_intro\t$sDMPs_result_exon\t$sDMPs_result_transposon\n$pDMPs_result_intergenic\t$pDMPs_result_downstream\t$pDMPs_result_upstream\t$pDMPs_result_intro\t$pDMPs_result_exon\t$pDMPs_result_transposon\n";

sub usage{
	my $die =<<DIE;
	usage:perl *.pl annotation_file
DIE
}
