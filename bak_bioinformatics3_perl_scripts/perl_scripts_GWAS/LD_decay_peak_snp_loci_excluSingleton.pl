#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 7;
my ($hap, $sin_snp,$res_pwd,$pheno,$ld_decay,$p_cut, $out) = @ARGV;

open HAP,$hap or die "$!";
my %hash_geno;
while(<HAP>){
    chomp;
    my ($rs,$alt,$chr,$pos) = split;
    $hash_geno{"$chr\t$pos"} = $alt;
}

open SIN,$sin_snp or die "$!";
my %sin_snp;
while(<SIN>){
    chomp;
    my ($chr,$pos) = split;
    $chr = "chr".$chr if $chr !~ /chr/;
    $sin_snp{"$chr\t$pos"} ++;
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
        if(exists $sin_snp{"$chr\t$pos"}){
            print "$tem_pheno\t$chr\t$pos\tSingleton\n";
            next;
        }
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

open OUT,"+>$out" or die "$!";
foreach my $tem_pheno(keys %hash_region_mer){
    print OUT "###$tem_pheno\n";
    foreach my $region(@{$hash_region_mer{$tem_pheno}}){
        print OUT "region\t$region\n";
        my ($chr,$stt,$end) = split(/\t/,$region);
        for(my $i = $stt;$i <= $end; ++$i){
            if(exists $hash_peak_snp{$tem_pheno}->{"$chr\t$i"}){
                print OUT "$hash_peak_snp{$tem_pheno}->{\"$chr\t$i\"}\n";
            }
        }
    }
}
close OUT;

sub usage{
    my $die = <<DIE;
    perl *.pl <hapmap> <Singleton SNP> <GWAS results pwd> <pheno> <ld_decay_peak_snp> <p value cut> <OUT> >> <report>
DIE
}
