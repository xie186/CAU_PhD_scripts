#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;

my ($sites,$gff) = @ARGV;
open SIT,$sites or die "$!";
my $header = <SIT>;
my %meth_pos;
while(<SIT>){
    chomp;
    my ($chr,$pos,$status) = (split(/\t/,$_))[0,1,-1];
    next if $status eq "TE";
    $meth_pos{"$chr\t$pos"} = 0;
}
close SIT;

open POS,$gff or die;
while(my $line=<POS>){
    chomp $line;
    next if $line !~ /^\d/;
    my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
    $chr="chr".$chr;
    next if $ele ne "gene";
    for(my $i = $stt -2000;$i <= $end + 2000;++$i){
        if(exists $meth_pos{"$chr\t$i"}){
            $meth_pos{"$chr\t$i"} ++;
        }
    }
}

open SIT,$sites or die "$!";
    $header = <SIT>;
chomp $header;
print "$header\tGene_status\n";
while(<SIT>){
    chomp;
    my ($chr,$pos,$status) = (split(/\t/,$_))[0,1,-1];
    next if $status eq "TE"; 
    if($meth_pos{"$chr\t$pos"} > 0){
        print "$_\tGENE\n";
    }else{
        print "$_\tNO\n";
    }
}
close SIT;

sub usage{
    my $die=<<DIE;
    perl *.pl <sites> <gene position GFF>
    This is to get the methylation distribution throughth gene
DIE
}
