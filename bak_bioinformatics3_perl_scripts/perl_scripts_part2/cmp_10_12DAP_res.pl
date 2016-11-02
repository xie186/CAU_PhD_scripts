#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 7;
my ($dap10, $dap12, $tab, $sam1,$sam2 , $out1, $out2) = @ARGV;

open DAP,$dap10 or die "$!";
my %hash_dap10;
while(<DAP>){
    chomp;
    my ($chr,$pos,@tem) = split;
    my $tem = join("\t",@tem);
    $hash_dap10{"$chr\t$pos"} = $tem;
}
close DAP;

open DAP,$dap12 or die "$!";
my %hash_dap12;
while(<DAP>){
    chomp;
    my ($chr,$pos,@tem) = split;
    my $tem = join("\t",@tem);
    $hash_dap12{"$chr\t$pos"} = $tem;
}
close DAP;

open TAB,$tab or die "$!";
my %imp_tab_dap;
my %imp_tab;
while(<TAB>){
    chomp;
    my ($chr,$pos,$gene,$imp_stat,$dap) = (split)[0,1,2,-2,-1];
    push @{$imp_tab_dap{"$gene\t$dap"}},  $_;
    $imp_tab{$gene} = $imp_stat;
}

open OUT1, "+>$out1" or die "$!";
open OUT2, "+>$out2" or die "$!";
print "gene_id\timp_in_$sam1\timp_in_$sam2\tanalyzable\n";
foreach (keys %imp_tab){
    if (exists $imp_tab_dap{"$_\t$sam1"} && exists $imp_tab_dap{"$_\t$sam2"}){
        print "$_\tY\tY\tNA\t$imp_tab{$_}\n";
    }elsif(exists $imp_tab_dap{"$_\t$sam1"} || !exists $imp_tab_dap{"$_\t$sam2"}){ 
        my ($analyzable) = (0);
        foreach my $lines(@{$imp_tab_dap{"$_\t$sam1"}}){
            my ($chr,$pos) = split(/\t/,$lines);
            if(exists $hash_dap12{"$chr\t$pos"}){
                ++$analyzable;
                print OUT1 "$lines\t$hash_dap12{\"$chr\t$pos\"}\n";
            }else{
                print OUT1 "$lines\t-\t-\t-\t-\t-\t-\n";
            }
        }
        if($analyzable >0){
            ($analyzable) = ("Y");
        }else{
            ($analyzable) = ("N");
        }
        print "$_\tY\tN\t$analyzable\t$imp_tab{$_}\n";
        
    }elsif(!exists $imp_tab_dap{"$_\t$sam1"} || exists $imp_tab_dap{"$_\t$sam2"}){
        my ($analyzable) = (0);
        foreach my $lines(@{$imp_tab_dap{"$_\t$sam2"}}){
            my ($chr,$pos) = split(/\t/,$lines);
            if(exists $hash_dap10{"$chr\t$pos"}){
                ++$analyzable;
                print OUT2 "$lines\t$hash_dap10{\"$chr\t$pos\"}\n";
            }else{
                print OUT2 "$lines\t-\t-\t-\t-\t-\t-\n";
            }
        }
        if($analyzable >0){
            ($analyzable) = ("Y");
        }else{
            ($analyzable) = ("N");
        }
        print "$_\tN\tY\t$analyzable\t$imp_tab{$_}\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <10 DAP> <12 DAP> <tab> <sample1> <sample2> <OUT1 [sam1]> <OUT2 [sam2]>
DIE
}
