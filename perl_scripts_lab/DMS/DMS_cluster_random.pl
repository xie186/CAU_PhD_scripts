#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5; 
my ($dms_pair, $dir, $context, $cut, $rand_num) = @ARGV;
sub usage{
    my $die =<<DIE;
perl $0 <dms_pair> <dir> <context> <cut> <rand_num> 
DIE
}
my %rec_all;
my %rec_dms;
my %rec_tis;
open PAIR, $dms_pair or die "$!";
while(<PAIR>){
    chomp;
    my ($wt, $mut) = split;
    $rec_tis{$wt} ++;
    $rec_tis{$mut} ++;
    my $file = "$dir/bed_$wt\_$mut\_OTOB_$context.fisherBH";
    open FILE, $file or die "$!";
    while (my $line = <FILE>){
       next if $line =~ /adj.pval/;
       chomp $line;
       my ($chr, $stt, $end, $c1,$t1,$c2, $t2, $lev1, $lev2, $diff, $p_val, $adj_pval) = split(/\t/, $line);
       $rec_all{"$chr\_$stt"} -> {$wt} = $lev1;
       $rec_all{"$chr\_$stt"} -> {$mut} = $lev2;
       if($adj_pval < $cut){
           $rec_dms{"$chr\_$stt"} ++;
       }
    }
}
close PAIR;

my $tis_num = keys %rec_tis; # record tissue number
my $dms_num = 0; #record the sits that were analyszed in all tissues;
foreach(keys %rec_dms){
    my $tis = keys %{$rec_all{"$_"}};
    if ($tis != $tis_num){
        delete $rec_dms{$_};
    }else{
        $dms_num ++;
    }
}

my @dms_pos = keys %rec_dms;
my $tis_name = join("\t", keys %rec_tis);
my %rec_rand_num;
print "\t$tis_name\n";
if($dms_num < $rand_num){
    foreach(keys %rec_dms){
        my @lev;
        foreach my $tis(keys %rec_tis){
            push @lev, $rec_all{$_} -> {$tis};
        }
        my $lev = join("\t", @lev);
        print "$_\t$lev\n";
    }
}else{
    srand(1);
    for(my $i = 1; $i < $rand_num; ++$i){
        my $rand = int (rand($rand_num));
        $rec_rand_num{$rand} ++;
        if($rec_rand_num{$rand} == 1){
            my $coor = $dms_pos[$rand];
            my @lev;
            foreach my $tis(keys %rec_tis){
                push @lev, $rec_all{$coor}->{$tis};
            }
            my $lev = join("\t", @lev);
            print "$coor\t$lev\n";
         }else{
            --$i;
         }
    }
}
