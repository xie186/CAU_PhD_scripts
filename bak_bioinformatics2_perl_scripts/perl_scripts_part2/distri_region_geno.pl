#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($region, $gff) = @ARGV;
open REG,$region or die "$!";
my %hash;
while(<REG>){
    chomp;
    my ($chr,$stt,$end) = split;
    my $mid= int (($end+$stt)/2);
    $hash{"$chr\t$mid"} = -1;
}

open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    next if /^#/;
    my ($chr,$tool,$feature,$stt,$end,$tem,$strand) = split;
    next if ($feature =~ /chromosome/ || $feature =~ /CDS/ || $feature =~ /mRNA/ || $feature =~ /gene/);
    my $flag=0;
    for(my $i = $stt;$i<=$end;++$i){
         if(exists $hash{"chr$chr\t$i"}){
              my $fea_value = &judge_prior($feature);
              $hash{"chr$chr\t$i"} = $fea_value if $fea_value > $hash{"chr$chr\t$i"};
         }
    }
}

foreach(keys %hash){
    my $ele;
       $ele = "Intergenic" if $hash{$_} == -1;
       $ele = "Downstream" if $hash{$_} == 0;
       $ele = "Upstream" if $hash{$_} == 1;
       $ele = "Intron" if $hash{$_} == 2;
       $ele = "Exon" if $hash{$_} == 3;
    print "$_\t$ele\n";
}

sub judge_prior{
    my ($ele) = shift;
    my $report;
       $report = 3 if ($ele =~ /exon/);
       $report = 2 if ($ele =~ /intron/);
       $report = 1 if ($ele =~ /upstream/);
       $report = 0 if ($ele =~ /downstream/);
#    print "$report\n";
    return $report;
}
sub usage{
    my $die = <<DIE;
    perl *.pl <Region> <GFF>
DIE
}
