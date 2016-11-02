#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($gff,$spec,$gene_ele) = @ARGV;
my %hash_gene;
my %hash_gene_len;
my %hash_gene_pos;
my %hash_gene_chr;
my %hash_gene_str;
open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$tool,$ele,$stt,$end,$flag1,$strand,$flag2,$name) = split;
    next if $chr !~ /\d/;
    $chr = "chr".$chr if $chr !~ /chr/; 
    if($ele =~ /$gene_ele/){
        my ($gene_name) = &get_gene_name($name, $spec);
        print "$name\n" if !$gene_name;
        for(my $i = $stt;$i <= $end; ++$i){
            $hash_gene{$gene_name}->{"$chr\t$i"} = 0;
        }
        push @{$hash_gene_pos{$gene_name}}, ($stt,$end);
        $hash_gene_chr{$gene_name} = $chr;
        $hash_gene_str{$gene_name} = $strand;
    }
}


foreach(keys %hash_gene){
    my $gene_len = keys %{$hash_gene{$_}};
    print "$_\t$gene_len\n";
}

sub get_gene_name{
    my ($name, $tem_spec) = @_;
    my $gene_name;
    if($tem_spec eq "ara" || $tem_spec eq "rice"){
        ($gene_name) = $name =~ /(.*)\.\d+/;
    }else{
        ($gene_name) = $name =~ /Parent=(.*);Name=/;
        ($gene_name) = split(/_/,$gene_name) if $gene_name =~ /^GRMZM/;
    }
    return $gene_name;
}

sub usage{
    print <<DIE;
    perl *.pl <FGS GFF file> <Spcies> <Element>
DIE
    exit 1;
}
