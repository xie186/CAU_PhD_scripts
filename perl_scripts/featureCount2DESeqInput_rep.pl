#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($feature, $tis) = @ARGV;

my @feaure = split(/,/, $feature);
my $tis_header = $tis;
$tis_header=~s/,/\t/g;
print "gene_id\t$tis_header\n";

my %rec_count;
foreach my $tem_fea(@feaure){
    open FEA, $tem_fea or die "$!";
    while(<FEA>){
        chomp;
        next if (/#/ || /Geneid/);
        #Geneid	Chr	Start	End	Strand	Length
        my ($id, $chr,$stt,$end,$strand, $len, @count) = split;
        my $sum = 0;
        for(my $i = 0; $i < @count; ++$i){
            $sum += $count[$i];
        }
        push @{$rec_count{$id}}, @count;
        
    }
    close FEA;
}

foreach my $id (keys %rec_count){
    my @count = @{$rec_count{$id}};
    my $sum = 0;
    foreach my $count(@count){
        $sum+=$count;
    }
    next if $sum ==0;
    my $count = join("\t", @count);
    print "$id\t$count\n";
}

sub usage{
    my $die=<<DIE;
perl $0 <count> <tis>
DIE
}
