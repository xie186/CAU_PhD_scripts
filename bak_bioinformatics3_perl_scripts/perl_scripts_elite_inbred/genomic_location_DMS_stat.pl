#!/usr/bin/perl
use strict;
die usage() if @ARGV == 0;

my ($anno, $context) = @ARGV;

my @anno = split(/,/, $anno);
my @context = split(/,/, $context);
print "\tIntergenic\tDownstream\tUpstream\tIntron\tExon\tTransposon\n";
for(my $i = 0; $i < @anno; ++$i){
    my %DMS;
    my %all;
    open NEW,"$anno[$i]" or die;
    while(<NEW>){
	chomp;
        my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$chr1,$stt1,$end1,$ele, $lap_num) = split;
	if($qval < 0.01){
	    my $target = "$chr\t$stt";
	    $DMS{$target}.="$ele\t";
	}else{
            my $target = "$chr\t$stt";
            $all{$target}.="$ele\t";
        }
    }
    close NEW;
    my ($DMS_result_intergenic, $DMS_result_downstream, $DMS_result_upstream, $DMS_result_intro, $DMS_result_exon, $DMS_result_transposon) = &stat(\%DMS);
    my ($all_result_intergenic, $all_result_downstream, $all_result_upstream, $all_result_intro, $all_result_exon, $all_result_transposon) = &stat(\%all);
    print "$context[$i]-all\t$all_result_intergenic\t$all_result_downstream\t$all_result_upstream\t$all_result_intro\t$all_result_exon\t$all_result_transposon\n";
    print "$context[$i]-DMS\t$DMS_result_intergenic\t$DMS_result_downstream\t$DMS_result_upstream\t$DMS_result_intro\t$DMS_result_exon\t$DMS_result_transposon\n";
}

sub stat{
    my ($DMS_ref) = @_;
    my ($DMS_total, $DMS_transposon, $DMS_intergenic, $DMS_downstream, $DMS_upstream, $DMS_intro, $DMS_exon) = (0,0,0,0,0,0,0);
    foreach my $key(keys %$DMS_ref){
        $DMS_total++;
        if($$DMS_ref{$key} =~ /transposon/){
                $DMS_transposon++;
        }elsif($$DMS_ref{$key} =~ /exon/){
                $DMS_exon++;
        }elsif($$DMS_ref{$key} =~ /intro/){
                $DMS_intro++;
        }elsif($$DMS_ref{$key} =~ /upstream/){
                $DMS_upstream++;
        }elsif($$DMS_ref{$key} =~ /downstream/){
                $DMS_downstream++;
        }else{
                $DMS_intergenic++;
        }
    }
#    print "$DMS_total\n";
    my $DMS_result_intergenic = $DMS_intergenic/$DMS_total;
    my $DMS_result_downstream = $DMS_downstream/$DMS_total;
    my $DMS_result_upstream = $DMS_upstream/$DMS_total;
    my $DMS_result_intro = $DMS_intro/$DMS_total;
    my $DMS_result_exon = $DMS_exon/$DMS_total;
    my $DMS_result_transposon = $DMS_transposon/$DMS_total;
    return ($DMS_result_intergenic, $DMS_result_downstream, $DMS_result_upstream, $DMS_result_intro, $DMS_result_exon, $DMS_result_transposon);
}

sub usage{
    my $die =<<DIE;
    usage:perl *.pl <anno file[file1,file2]> <process [file1, fil2]>
DIE
}
