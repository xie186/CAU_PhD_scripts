#!/usr/bin/perl -w
use strict;
use Graph;
use Graph::Undirected;
use GraphViz;
die usage() unless @ARGV == 6;

my ($hapmap,$pheno_list, $res_pwd, $p_cut, $r2_cut, $out) = @ARGV;
open PHENO,$pheno_list or die "$!";
my %hash_peak;
my %snp_peak;
while(my $pheno = <PHENO>){
    chomp $pheno;
    open PEAK,"$res_pwd/GAPIT.$pheno.photype.GWAS.ps.p2log" or die "$!";
    while( my $line = <PEAK>){
        chomp $line;
        my ($chr,$pos,$maf,$p_log) = split(/\t/,$line);
        $hash_peak{$pheno} -> {"chr$chr\_$pos"} = "$maf\t$p_log" if $p_log >= $p_cut;
        $snp_peak{"chr$chr\_$pos"} ++;
    }
}
close PHENO;

print "Reading the hapmap file!!!\n";
open HAP,$hapmap or die "$!";
#<HAP>;
my %hash_snp;
my %snp_geno;
while(<HAP>){
    chomp;
    my ($rs,$geno,$chr,$pos,$strand) = split;
    if (exists $snp_peak{"$chr\_$pos"}){
        $hash_snp{$chr}->{$pos} = $_;
    }
    $snp_geno{"$chr\t$pos"} = $geno;
}

open OUT, "+>$out" or die "$!";
open PHENO,$pheno_list or die "$!";
while(my $pheno = <PHENO>){
    chomp $pheno;
    print OUT "###$pheno\n";
    print "$pheno\n";
    my %hash_hap;
    foreach my $coor (keys %{$hash_peak{$pheno}}){
        my ($chr, $pos) = split(/_/,$coor);
        $hash_hap{$chr} -> {$pos} = $hash_snp{$chr}->{$pos};
    }

    my @res_r2;
    foreach my $tem_chr(keys %hash_hap){
        my @pos = keys %{$hash_hap{$tem_chr}};
        for(my $i = 0;$i<=$#pos;++$i){
            for(my $j = $i+1;$j<=$#pos;++$j){
                my ($r2) = &r2($hash_hap{$tem_chr}->{$pos[$i]},$hash_hap{$tem_chr}->{$pos[$j]});
        #        print OUT "$tem_chr\_$pos[$i]\t$tem_chr\_$pos[$j]\t$r2\n";
                push @res_r2, "$tem_chr\_$pos[$i]\t$tem_chr\_$pos[$j]\t$r2";
            }
        }
    }
    my $group=Graph::Undirected->new;
    my %hash_unLD;
    foreach(sort @res_r2){
        my ($snp1,$snp2,$tem_r2)=split(/\t/);
        next if $tem_r2 <= $r2_cut;
        $group->add_edge($snp1,$snp2);
    }    
    my @aa = $group -> connected_components(); 
    for(my $i =0; $i<=$#aa;++$i){
        my $tem_pos = join("\t",@{$aa[$i]});
        my ($tem_chr) = $tem_pos=~ /(chr\d+)_/;
           $tem_pos =~ s/chr\d+_//g;
        my @tem_pos = sort {$a<=>$b} split(/\t/,$tem_pos);
        my $group_nu = $i + 1;
        print OUT "peak_group_$group_nu\t$tem_chr\t$tem_pos[0]\t$tem_pos[-1]\n";
        foreach(@{$aa[$i]}){
            my $chr_pos = $_;
               $chr_pos =~ s/_/\t/g;
            print OUT "$chr_pos\t$snp_geno{$chr_pos}\t$hash_peak{$pheno}->{$_}\n";
            print "xx$_\n" if !exists $hash_peak{$pheno}->{$_};
            delete $hash_peak{$pheno}->{$_};
        }
    }
    my $ungroup_nu = $#aa + 1 + 1 ;
    foreach(keys %{$hash_peak{$pheno}}){
        print OUT "peak_ungroup_$ungroup_nu\n";
        my $chr_pos = $_;
           $chr_pos =~ s/_/\t/g;
        print OUT "$chr_pos\t$snp_geno{$chr_pos}\t$hash_peak{$pheno}->{$_}\n";
        print "xx$_\n" if !exists $hash_peak{$pheno}->{$_};
        ++ $ungroup_nu;
    }
}

sub r2{
    my ($geno1,$geno2)  = @_;
    chomp $geno1;
    chomp $geno2;
    my ($rs1,$alle1,$chr1,$pos1,$strand1,$assembly1,$center1,$protLSID1,$assayLSID1,$panel1,$QCcode1,@geno1) = split(/\t/,$geno1);
    my ($rs2,$alle2,$chr2,$pos2,$strand2,$assembly2,$center2,$protLSID2,$assayLSID2,$panel2,$QCcode2,@geno2) = split(/\t/,$geno2);
    my %hap_freq;
    my ($a1,$a2) = $alle1 =~ /(\w+)\/(\w+)/;
    my ($b1,$b2) = $alle2 =~ /(\w+)\/(\w+)/;
       $hap_freq{"$a1"."$a1\t$b1"."$b1"} =0;
       $hap_freq{"$a1"."$a1\t$b2"."$b2"} =0;
       $hap_freq{"$a2"."$a2\t$b1"."$b1"} =0;
       $hap_freq{"$a2"."$a2\t$b2"."$b2"} =0;
    my %alle_freq1;
    my %alle_freq2;
    my $sum = 0;
    for(my $i = 0;$i<=$#geno1;++$i){
        next if ($geno1[$i] =~ /N/ || $geno2[$i] =~ /N/);
        $alle_freq1{$geno1[$i]} ++;
        $alle_freq2{$geno2[$i]} ++;
        $hap_freq{"$geno1[$i]\t$geno2[$i]"} ++;
        ++ $sum;
    }
    my ($alle_freq1_high,$alle_freq1_low) = sort {$alle_freq1{$b}<=>$alle_freq1{$a}} keys %alle_freq1;
    my ($alle_freq2_high,$alle_freq2_low) = sort {$alle_freq2{$b}<=>$alle_freq2{$a}} keys %alle_freq2;
#    print "$a1,$a2,$b1,$b2,$alle_freq1_high,$alle_freq1_low, xx$alle_freq2_high,$alle_freq2_low\n";
#    print "$alle_freq1_high\t$alle_freq2_high\n"; 
    my $hap_freq_hh = $hap_freq{"$alle_freq1_high\t$alle_freq2_high"} / $sum;
    my $alle_freq1_h = $alle_freq1{$alle_freq1_high} / $sum;
    my $alle_freq1_l = $alle_freq1{$alle_freq1_low} / $sum;
    my $alle_freq2_h = $alle_freq2{$alle_freq2_high} / $sum;
    my $alle_freq2_l = $alle_freq2{$alle_freq2_low} / $sum;
#    print "($hap_freq_hh - $alle_freq1_h * $alle_freq2_h )**2 / ($alle_freq1_h*$alle_freq1_l*$alle_freq2_h*$alle_freq2_l)\n";
    my $r2 = ($hap_freq_hh - $alle_freq1_h * $alle_freq2_h )**2 / ($alle_freq1_h*$alle_freq1_l*$alle_freq2_h*$alle_freq2_l);
    return $r2;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <hapmap> <pheno list> <GWAS pwd> <p_cut> <r2_cut> <out>
DIE
}
