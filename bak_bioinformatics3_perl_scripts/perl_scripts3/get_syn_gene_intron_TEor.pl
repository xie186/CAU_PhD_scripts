#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($syn,$gff,$spec) = @ARGV;

open SYN,$syn or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($zm_gene,$rice_gene) = split;
    $hash_syn{$zm_gene} ++;
    $hash_syn{$rice_gene} ++;
}

open GFF,$gff or die "$!";
my %hash_pos;
while(<GFF>){
    chomp;
    my ($chr,$tool,$ele,$stt,$end,$flag1,$strand,$flag2,$name) = split;
    next if $chr !~ /\d/;
    next if ($ele !~ /intron/ || $end-$stt+1 < 100);
    my ($gene_name) = &get_gene_name($name, $spec);
    next if(!exists $hash_syn{$gene_name} && $spec !~ /ara/);
    ($ele) = $ele =~ /_(.*)/ if $ele =~/_/;
    $chr="chr".$chr if $chr !~/[a-z]/;
#    print "$chr\t$stt\t$end\t$ele\t$gene_name\n";
    $hash_pos{"$chr\t$stt\t$end\t$ele\t$strand"} ++;
}

foreach(keys %hash_pos){
    print "$_\t$hash_pos{$_}\n";
}

sub get_gene_name{
    my ($name, $tem_spec) = @_;
    my $gene_name;
    if($tem_spec =~ /ara/ || $tem_spec =~ /rice/){
        ($gene_name) = $name =~ /(.*)\.\d+/;
    }else{
        ($gene_name) = $name =~ /Parent=(.*);Name=/;
        ($gene_name) = split(/_/,$gene_name) if $gene_name =~ /^GRMZM/;
    }
    return $gene_name;
}

sub usage{
    print <<DIE;
    perl *.pl <Syntenic genes> <GFF> <species>
DIE
    exit 1;
}
