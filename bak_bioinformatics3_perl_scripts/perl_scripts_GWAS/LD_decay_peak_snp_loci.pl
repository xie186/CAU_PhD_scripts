#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($hap,$res_pwd,$pheno,$ld_decay,$p_cut) = @ARGV;

open HAP,$hap or die "$!";
my %hash_geno;
while(<HAP>){
    chomp;
    my ($rs,$alt,$chr,$pos) = split;
    $hash_geno{"$chr\t$pos"} = $alt;
}

open LD, $ld_decay or die "$!";
my %ld_decay;
while(<LD>){
    chomp;
    #chr10   109950604       0.0008616821    378     8771
    my ($chr,$pos,$coef,$snp_nu,$ld_decay_size) = split;
    $ld_decay_size = int $ld_decay_size;
    $ld_decay{"$chr\t$pos"} = $ld_decay_size;
}

open PHE,$pheno or die "$!";
my %hash_region;
my %hash_peak_snp;
while(my $tem_pheno = <PHE>){
    chomp $tem_pheno;
    open PEAK,"$res_pwd/$tem_pheno" or die "$!";
    while( my $line = <PEAK>){
        chomp $line;
        my ($chr,$pos,$maf,$p_log) = split(/\t/,$line);
        $chr = "chr".$chr if $chr !~ /chr/;
        if ($p_log >= $p_cut){
            my ($stt, $end) = ($pos - $ld_decay{"$chr\t$pos"}, $pos + $ld_decay{"$chr\t$pos"});
            $hash_peak_snp{$tem_pheno}->{"$chr\t$pos"} = "$chr\t$pos\t$hash_geno{\"$chr\t$pos\"}\t$maf\t$p_log";
            push @{$hash_region{$tem_pheno}} , "$chr\t$stt\t$end";
        }
    }
}
close PHE;

my %hash_region_mer;
foreach my $tem_pheno(keys %hash_region){
    my $nu = @{$hash_region{$tem_pheno}};
    for(my $i = 0; $i < $nu; ++$i){
        my $line1 = shift @{$hash_region{$tem_pheno}};
        my ($chr1,$stt1,$end1) = split(/\t/,$line1);
        PATH:{    
            my $line2 =  shift @{$hash_region{$tem_pheno}};
            ++ $i;
            if(!$line2){
                push @{$hash_region_mer{$tem_pheno}},"$chr1\t$stt1\t$end1";
                last;
            }else{
                my ($chr2,$stt2,$end2) = split(/\t/,$line2);
                if(($chr1 ne $chr2) || ($chr1 eq $chr2 && $end1 < $stt2 - 20000 )){    ###  20 k merge
                    push @{$hash_region_mer{$tem_pheno}} , "$chr1\t$stt1\t$end1";
                    my $dis = $stt2 - $end1;
#                    print "xx\t$dis\n";
                    ($chr1,$stt1,$end1) = ($chr2,$stt2,$end2);
                }else{
                    ($stt1,my $dot1, my $dot2,$end1) = sort {$a<=>$b} ($stt1,$end1,$stt2,$end2);
                }
                redo PATH;
            }
        }
    }
}

foreach my $tem_pheno(keys %hash_region_mer){
    print "###$tem_pheno\n";
    foreach my $region(@{$hash_region_mer{$tem_pheno}}){
        print "region\t$region\n";
        my ($chr,$stt,$end) = split(/\t/,$region);
        for(my $i = $stt;$i <= $end; ++$i){
            if(exists $hash_peak_snp{$tem_pheno}->{"$chr\t$i"}){
                print "$hash_peak_snp{$tem_pheno}->{\"$chr\t$i\"}\n";
            }
        }
    }
}

sub usage{
    my $die = <<DIE;
    perl *.pl <hapmap> <GWAS results pwd> <pheno> <ld_decay_peak_snp> <p value cut>
DIE
}
