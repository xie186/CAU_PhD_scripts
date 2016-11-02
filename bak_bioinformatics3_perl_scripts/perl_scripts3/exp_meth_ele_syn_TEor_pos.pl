#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV == 12;
my ($gff, $gene_region, $te_pos, $syn, $tissue, $cpg_ot,$cpg_ob,$chg_ot,$chg_ob,$chh_ot,$chh_ob, $out) = @ARGV;

open SYN,$syn or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($zm_gene,$rice_gene) = split;
    $hash_syn{$zm_gene} ++;
    $hash_syn{$rice_gene} ++;
}

my %hash_exclu;
open TE,$te_pos or die "$!";
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$chrom,$te_stt,$te_end) = split;
    $chrom = "chr".$chrom if $chrom !~ /[a-z]/;
    for(my $i = $te_stt; $i <= $te_end; ++ $i){
        $hash_exclu{"$chrom\t$i"} ++;
    }
}

my %meth_cpg;my %meth_chg;my %meth_chh;
foreach($cpg_ot,$cpg_ob){
   open BED,$_ or die "$!";
   while (my $line=<BED>){
       chomp $line;
       my ($chr,$pos1,$pos2,$depth,$lev)=split(/\t/,$line);
       next if $depth<3;
       $meth_cpg{"$chr\t$pos1"} = "$depth\t$lev";
   }
   close BED;
}

foreach($chg_ot,$chg_ob){
   open BED,$_ or die "$!";
   while (my $line=<BED>){
       chomp $line;
       my ($chr,$pos1,$pos2,$depth,$lev)=split(/\t/,$line);
       next if $depth<3;
       $meth_chg{"$chr\t$pos1"} = "$depth\t$lev";
   }
   close BED;
}

foreach($chh_ot,$chh_ob){
   open BED,$_ or die "$!";
   while (my $line=<BED>){
       chomp $line;
       my ($chr,$pos1,$pos2,$depth,$lev)=split(/\t/,$line);
       next if $depth<3;
       $meth_chh{"$chr\t$pos1"} = "$depth\t$lev";
   }
   close BED;
}

open OUT,"+>$out" or die "$!";
my %hash_pos;
open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$tool,$ele,$stt,$end,$flag1,$strand,$flag2,$name) = split;
    next if $chr !~ /\d/;
    $chr = "chr".$chr if $chr !~ /[a-z]/;
    if($ele =~ /$gene_region/){
        my ($gene_name) = &get_gene_name($name, $tissue);
        next if (!exists $hash_syn{$gene_name} && ($tissue =~ /BSR/ || $tissue =~ /rice/)) ; 
        for(my $i = $stt;$i <= $end; ++$i){
            if(exists $hash_exclu{"$chr\t$i"}){
                $hash_pos{"$chr\t$i"}  .= "TE\t";
            }else{
                $hash_pos{"$chr\t$i"}  .= "gene\t";
            }
        }
    }
}
foreach(keys %hash_pos){
   if($hash_pos{$_} =~ /TE/){ 
       if(exists $meth_cpg{$_}){
           print OUT "intron_TE\tCpG\t$_\t$meth_cpg{$_}\n";
       }elsif(exists $meth_chg{$_}){
           print OUT "intron_TE\tCHG\t$_\t$meth_chg{$_}\n";
       }elsif(exists $meth_chh{$_}){
           print OUT "intron_TE\tCHH\t$_\t$meth_chh{$_}\n";
       }
   }else{
       if(exists $meth_cpg{$_}){
           print OUT "intron_NT\tCpG\t$_\t$meth_cpg{$_}\n";
       }elsif(exists $meth_chg{$_}){
           print OUT "intron_NT\tCHG\t$_\t$meth_chg{$_}\n";
       }elsif(exists $meth_chh{$_}){
           print OUT "intron_NT\tCHH\t$_\t$meth_chh{$_}\n";
       }
   }
}
close OUT;
sub get_gene_name{
    my ($name, $tem_spec) = @_;
    my $gene_name;
    if($tem_spec =~ "ara" || $tem_spec =~ "rice"){
        ($gene_name) = $name =~ /(.*)\.\d+/;
    }else{
        ($gene_name) = $name =~ /Parent=(.*);Name=/;
        ($gene_name) = split(/_/,$gene_name) if $gene_name =~ /^GRMZM/;
    }
    return $gene_name;
}

sub usage{
    print <<DIE;
    perl *.pl <FGS GFF file> <Gene element> <TE_asso gene> <syn> <tissue> <cpg_ot> <cpg_ob> <chg_ot> <chg_ob> <chh_ot> <chh_ob>  <OUT>
DIE
    exit 1;
}
