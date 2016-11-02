#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;

my ($sites,$gff) = @ARGV;
open SIT,$sites or die "$!";
my $header = <SIT>;
my %meth_pos;
while(<SIT>){
    chomp;
    my ($chr,$pos) = split;
    $meth_pos{"$chr\t$pos"} = 0;
}
close SIT;

open POS,$gff or die;
while(my $line=<POS>){
    chomp $line;
    next if /^#/;
    my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
    next if $chr =~ /UNKNOWN/;
    $chr="chr".$chr;
    for(my $i = $stt;$i <= $end;++$i){
        if(exists $meth_pos{"$chr\t$i"}){
            $meth_pos{"$chr\t$i"} ++;
        }
    }
}

open SIT,$sites or die "$!";
    $header = <SIT>;
chomp $header;
print "$header\tTE_status\n";
while(<SIT>){
    chomp;
    my ($chr,$pos) = split;
    if($meth_pos{"$chr\t$pos"} > 0){
        print "$_\tTE\n";
    }else{
        print "$_\tNT\n";
    }
}
close SIT;

sub usage{
    my $die=<<DIE;
    perl *.pl <sites> <gene position GFF>
    This is to get the methylation distribution throughth gene
DIE
}
