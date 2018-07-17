#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($rep_base, $gff, $out_dir) = @ARGV;

mkdir $out_dir if -d $out_dir;

$/ = "\n>";
open REP, $rep_base or die "$!";
my %class_sup;
my %supclass_flag;
while(<REP>){
    chomp; 
    $_ =~ s/>//;
    my ($id, @seq) = split(/\n/, $_);
    #>ATLINE1_1      L1      Arabidopsis thaliana
    my ($class, $sup_class) = split(/\s+/, $id);
    $sup_class =~ s/\//_/g;
    $class_sup{$class} = $sup_class;

    my $seq = join("", @seq);
    $supclass_flag{$sup_class} ++;
    if($supclass_flag{$sup_class} == 1){
        open FA, "+>$out_dir/$sup_class.fasta" or die "$!";
    }else{
        open FA, ">>$out_dir/$sup_class.fasta" or die "$!";
    }
    $seq =~ s/x/n/g;
    print FA ">$id\n$seq\n";
}

open OUT, "+>$out_dir/ara_TE.eref" or die "$!"; 
foreach(keys %supclass_flag){
    print OUT "$_\t$out_dir/$_.fasta\n";
}
close OUT;

$/ = "\n";
my %out_flag;
open GFF, $gff or die "$!";
while(<GFF>){
    chomp;
    #chr1    RepeatMasker    similarity      1       107     13.2    -       .       Target "Motif:ATREP18" 1347 1445
    next if /^#/; 
    my ($chr,$tool, $ele, $stt,$end, $dot1, $strand, $dot2, $info) = split(/\t/);
    my ($class) = $info =~ /Target\s+"Motif:(.*)"/;
    next if !exists $class_sup{$class};
    my $sup_class = $class_sup{$class};
    $out_flag{$sup_class} ++;
    if($out_flag{$sup_class} == 1){
        open BED, "+>$out_dir/$sup_class.bed" or die "$!";
    }else{
        open BED, ">>$out_dir/$sup_class.bed" or die "$!";
    }
    print BED "$chr\t$stt\t$end\t$class\n";
}
open OUT, "+>$out_dir/ara_TE.tab" or die "$!";
foreach(keys %out_flag){
    print OUT "$_\t$out_dir/$_.bed\n";
}
close OUT;

sub usage{
    my $die =<<DIE;
perl $0 <rep_base> <gff> <out_dir>
DIE
}
