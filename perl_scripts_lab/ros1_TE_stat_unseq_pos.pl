#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($te_reg, $lap_reg, $eco_list) = @ARGV;

my %unseq_pos;
open LAP, $lap_reg or die "$!";
while(<LAP>){
    chomp;
    my ($chr,$stt,$end,$eco) = split;
    for(my $i = $stt; $i <= $end; ++$i){
        $unseq_pos{"$eco\t$i"}  ++;
        #print "$eco\t$i\n";
    }
}
close LAP;

open TE, $te_reg or die "$!";
while(<TE>){
    chomp;
    next if /^#/;
    my ($chr, $stt,$end) = split;
    for(my $i = $stt; $i <= $end; ++$i){
        &print_pos($i);    
    }
}
close TE;

sub print_pos{
    my ($pos) = @_;
    open ECO, $eco_list or die "$!";
    my @stat_seq;
    while(my $eco = <ECO>){
        chomp $eco;
        next if $eco=~/#/;
        #print "$eco\t$pos\n";
        #`:print "$eco\t$pos\n" if exists $unseq_pos{"$eco\t$pos"};
        my $stat = (exists $unseq_pos{"$eco\t$pos"})?0:1;
        push @stat_seq, $stat; 
    }
    my $stat_seq = join("\t", @stat_seq);
    print "$pos\t$stat_seq\n";
    my $num0 = $stat_seq =~s/0/0/g;
    #print "$pos\t$num0\n";
}

sub usage{
    my $die =<<DIE;
perl $0  <te_reg> <lap_reg> <eco list>
DIE
}
