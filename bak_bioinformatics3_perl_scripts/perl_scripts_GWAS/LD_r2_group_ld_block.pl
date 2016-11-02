#!/usr/bin/perl -w
use strict;
use Graph;
use Graph::Undirected;

die usage() unless @ARGV == 4;
my $REGION = "region";
my $PEAK_SNP = "peak_snp";
my $PEAK_SIN = "singleton_snp_or_not";
my ($plink_in, $group,$win,$out) = @ARGV;
open GROUP,$group or die "$!";
my ($pheno,$r2_cut) = $group =~ /GAPIT.(.*).photype.peak_group.(.*).res/;
print "$pheno,$r2_cut\n";
my @group = <GROUP>;
my $tem_group = join('',@group);
   @group = split(/###/,$tem_group);
shift @group;
my %group_region;
foreach(@group){
    my ($group_head,@peak_snp) = split(/\n/);
    if(/_ungroup_/){
        for(my $i = 0;$i<= $#peak_snp;++$i){
            my ($chr,$pos) = $peak_snp[$i] =~ /(chr\d+)\_(\d+)/;
            my ($stt,$end) = ($pos - $win/2,$pos + $win/2);
            $group_region{"ungrp\_$i"} ->{$REGION} = "$chr\t$stt\t$end";
            push @{$group_region{"ungrp\_$i"} ->{$PEAK_SNP}} , $peak_snp[$i];
        }
    }else{
        my ($grp_id,$chr,$stt,$end) = split(/\t/,$group_head);
           ($stt,$end) = ($stt - $win/2, $end + $win/2);
        $group_region{$grp_id} -> {$REGION} = "$chr\t$stt\t$end";
        push @{$group_region{$grp_id} ->{$PEAK_SNP}} , @peak_snp;
    }
}

foreach(keys %group_region){
    print "###$_\n";
    foreach my $snp (@{$group_region{$_} ->{$PEAK_SNP}}){
         my ($tem_snp,$tem_plog) = split(/\t/,$snp);
         $group_region{$_} ->{$PEAK_SIN}->{$tem_snp} = 0;
    }
}

open OUT,"+>$out" or die "$!";
foreach my $group(keys %group_region){
    print "process : $group \n";
    my ($chr,$stt,$end) =split(/\t/,$group_region{$group} -> {$REGION});
        $chr =~ s/chr//g if $chr =~ /chr/;
    my  $tem_plink_file = $plink_in.$chr;
    `mkdir ld_cal` if !-e "./ld_cal/";
    if(!-e "./ld_cal/GAPIT.$pheno.$chr.$stt.$end.$r2_cut.ld"){
        `/NAS2/jiaoyp/software/plink-1.07-x86_64/plink --bfile $tem_plink_file --noweb --r2 --ld-window 100000 --ld-window-kb 200 --ld-window-r2 0 --maf 0.05 --chr $chr --from-bp $stt --to-bp $end --out ./ld_cal/GAPIT.$pheno.$chr.$stt.$end.$r2_cut`;
    }
    print "cal ld done!!\n";
    my $gra = Graph::Undirected->new;
    print "./ld_cal/$pheno.$chr.$stt.$end.$r2_cut\n";
    open LD,"./ld_cal/GAPIT.$pheno.$chr.$stt.$end.$r2_cut.ld" or die "$!";
    <LD>;
    while(<LD>){
        chomp;
        my ($chr1,$pos1,$index1,$chr2,$pos2,$index2,$r2)  = split;
            $chr1 = "chr".$chr1;
            $chr2 = "chr".$chr2;
        if($r2 > $r2_cut){
#            print "$chr1\_$pos1\t$chr2\_$pos2\n";
            $gra -> add_edge("$chr1\_$pos1","$chr2\_$pos2");
        }
     }
     my @aa = $gra -> connected_components();
     print "LD group done!!\n";
     for(my $i =0; $i<=$#aa;++$i){
        my $tem_pos = join("\t",@{$aa[$i]});
#        print "$tem_pos\n";
        my @tem_peak_snp;
        foreach my $peak_snp(@{$group_region{$group} ->{$PEAK_SNP}}){
            my ($tem_snp,$tem_plog) = split(/\t/,$peak_snp);
            if($tem_pos =~ /$tem_snp/){
                $group_region{$group} ->{$PEAK_SIN}->{$tem_snp} ++;
                push @tem_peak_snp, $peak_snp;
                $tem_pos =~ s/$tem_snp/peak_$tem_snp/;
            }
        }

        my $tem_nu = @tem_peak_snp || 0;
        if($tem_nu > 0){
            my ($tem_chr) = $tem_pos=~ /(chr\d+)_/;
            my  $tem_pos_no_chr = join("\t",@{$aa[$i]});
                $tem_pos_no_chr =~ s/chr\d+_//g;
            my @tem_pos = sort {$a<=>$b} split(/\t/,$tem_pos_no_chr);
            my $snp_nu = @tem_pos;
            print "xx\n";
            print OUT "$group\tLD_block\t$tem_chr\t$tem_pos[0]\t$tem_pos[-1]\t$snp_nu\t$tem_pos\n";
            print "$group\tLD_block\t$tem_chr\t$tem_pos[0]\t$tem_pos[-1]\t$snp_nu\t$tem_pos\n";
        }
    }
}

foreach(keys %group_region){
    foreach my $snp (@{$group_region{$_} ->{$PEAK_SNP}}){
         my ($tem_snp,$tem_plog) = split(/\t/,$snp);
         print "$group\tLD_block\t$tem_snp\tsingleton_SNP\n" if $group_region{$_} ->{$PEAK_SIN}->{$tem_snp} == 0;
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <plink input prefix> <group> <window size> <OUT> 
DIE
}
