#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($peak_snp,$win) = @ARGV;

open PEAK,$peak_snp or die "$!";
my @snp = <PEAK>;
my $snp = join("",@snp);
   @snp = split(/####/,$snp);
foreach(@snp){
    chomp;
    my ($pheno,$na1,@tem_snp) = split(/\n/,$_);
    print "####$pheno\n";
    my $group_nu = 1;
    my %hash_group;
    for(my $i = 0;$i < @tem_snp;++$i){
        my ($chr1,$pos1,$maf1,$p_log1) = split(/\s+/, $tem_snp[$i]);
            $hash_group{$group_nu} -> {"$chr1\t$pos1"} = $p_log1;
        PATH:{    
            if(!exists $tem_snp[$i+1]){
                last;
            }else{
                    my ($chr2,$pos2,$maf2,$p_log2) = split(/\s+/, $tem_snp[$i+1]);
                    if($chr2 == $chr1 && $pos2 - $pos1 < $win){
                        $hash_group{$group_nu} -> {"$chr2\t$pos2"} = $p_log2;
                        ($chr1,$pos1,$maf1,$p_log1) = ($chr2,$pos2,$maf2,$p_log2);
                        ++$i;
                    }else{
                        $group_nu ++;
                        $hash_group{$group_nu} -> {"$chr2\t$pos2"} = $p_log2;
                        ($chr1,$pos1,$maf1,$p_log1) = ($chr2,$pos2,$maf2,$p_log2);
                        ++$i;
			redo PATH;
                    } 
            }
        }
    }
    foreach my $tem_nu(sort {$a<=>$b} keys %hash_group){
        my $nu = 0;
        my %tem_hash = %{$hash_group{$tem_nu}};
        foreach my $coor(sort {$tem_hash{$b} <=> $tem_hash{$a}} keys %tem_hash){
#            print "xx\t$tem_hash{$coor}\n";
#        foreach my $coor(sort { $hash_group{$tem_nu}->{$b} <=> $hash_group{$tem_nu}->{$b} } keys %{$hash_group{$tem_nu}}){
            if($nu ==0){
                print "$coor\t$tem_nu\t$hash_group{$tem_nu}->{$coor}\tmax_peak\n";
            }else{
                print "$coor\t$tem_nu\t$hash_group{$tem_nu}->{$coor}\tnon_max\n";
            }
            ++$nu;
        }
    }
}	


sub usage{
    my $die=<<DIE;
    perl *.pl <Peak SNPs> <windows> 
DIE
}		
