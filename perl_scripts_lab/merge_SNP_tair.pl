#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dir, $out) = @ARGV;

my @fil = <$dir/quality_variant_filtered_*.txt>;

my @acc;
my %var_fil;
my %var_raw;
foreach(@fil){
    my ($acc) = $_ =~ /$dir\/quality_variant_filtered_(.*).txt/;
    push @acc, $acc;
    open FIL, $_ or die "$!";
    while(my $fil = <FIL>){
        chomp $fil;
        my ($tem_acc, $chr,$pos, $ref, $alt) = split(/\t/, $fil);
        next if $ref !~ /A|T|G|C/;
        #next if $alt !~ /A|T|G|C/;
        $var_fil{"$chr\t$pos"} -> {$acc} = $alt;
        $var_fil{"$chr\t$pos"} -> {"ref"} = $ref;
    }
    close FIL;

    my $raw_var_file = "$dir/quality_variant_filtered_$acc.txt";
    my $unseq = "$dir/unsequenced_$acc.txt"; 
    if(!-e $raw_var_file){
         die "$acc\tquality_variant_filtered_$acc.txt doesn't exist!\n";
    }
    if(!-e $unseq){
         die "$acc\tunsequenced_$acc.txt doesn't exist!\n";
    }
    open RAW,  $raw_var_file or die "$!";
    while(my $raw = <RAW>){
        chomp $raw;
        my ($tem_acc,$chr,$pos, $ref, $alt) = split(/\t/, $raw);
        $var_raw{"$chr\t$pos"} -> {$acc} = $alt if !exists $var_fil{"$chr\t$pos"}->{$acc} ;
    }
    close RAW;
}

foreach my $acc(@acc){
    my $unseq = "$dir/unsequenced_$acc.txt";
    open UNSEQ, $unseq or die "$!";
    while(my $un = <UNSEQ>){
        chomp $un;
        my ($tem_acc, $chr,$stt, $end) = split(/\t/, $un);
        for(my $i = $stt; $i <= $end; $i ++){
            if(exists $var_fil{"$chr\t$i"} && !exists $var_fil{"$chr\t$i"} -> {$acc}){
                $var_fil{"$chr\t$i"} -> {$acc} = "x";
            }elsif(exists $var_fil{"$chr\t$i"} && exists $var_fil{"$chr\t$i"} -> {$acc}){
                print "Warning: $chr\t$i\t$acc: impossable";
            }
        }
    }
    close RAW;
}

open OUT, "+>$out" or die "$!";
my $tem_acc = join("\t", @acc);
print OUT "chr\tpos\tgeno\t$tem_acc\tCol_0\n";
foreach my $coor(keys %var_fil){
    my @base;
    my %geno;
    foreach my $acc(@acc){
        if(!exists $var_fil{$coor} -> {$acc}){
            if(exists $var_raw{$coor} -> {$acc}){
                $var_fil{$coor} -> {$acc} = "x";
            }else{
                $var_fil{$coor} -> {$acc} = $var_fil{$coor} -> {"ref"} ;
            }
        }
        my $base = $var_fil{$coor} -> {$acc};
        if($base ne "x" && $base ne $var_fil{$coor} -> {"ref"}){
            $geno{$base} ++;
        }
        push @base, $var_fil{$coor} -> {$acc};
    }
    my @geno = ($var_fil{$coor} -> {"ref"}, keys %geno);
    my $geno = join("/", @geno);
    my $ref = $geno[0];
    my $geno_num = @geno;
    if($geno_num == 2){
        my $alt = $geno[1];
        next if $alt eq "-";
        my $acc_geno = join("\t", @base);
        print OUT "$coor\t$geno\t$acc_geno\t$ref\n";
    }
}

sub usage{
    my $die =<<DIE;
perl $0 <dir> <OUT>
DIE
}
=pod
<Chromosome>
<Position>
<Reference base>
<Substitution base>
<Quality>
<# of nonrepetitive reads supporting substituion>
<concordance>
<Avg. # alignments of overlapping reads>
=end
