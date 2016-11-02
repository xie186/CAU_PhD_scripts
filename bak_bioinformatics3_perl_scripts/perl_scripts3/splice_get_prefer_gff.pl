#!/usr/bin/perl -w
use strict;
die "perl *.pl  <Prefer genes> <GFF>\n" unless @ARGV==2;
my ($prefer,$gff) =@ARGV;

open PREFER,$prefer or die "$!";
my %hash_prefer;
while(<PREFER>){
    chomp;
    $hash_prefer{$_} ++;
}

open GFF,$gff or die "$!";
while(my $line=<GFF>){
    chomp $line;
    next if $line !~ /^\d/;
    
    my ($chr,$tools,$ele,$stt,$end,$dot1,$strand,$dot2,$id_info)=split(/\t/,$line);
#    print "$chr,$tools,$ele,$stt,$end,$dot1,$strand,$dot2,$id_info\n";
    next if ($ele !~ /exon/ && $ele !~ /intron/);
    my ($gene) = $id_info =~/Parent=(.*);Name=/;
       ($gene) = (split(/_/,$gene)) if $gene =~/^GRMZM/;
    print "$line\n" if exists $hash_prefer{$gene};
    
}
