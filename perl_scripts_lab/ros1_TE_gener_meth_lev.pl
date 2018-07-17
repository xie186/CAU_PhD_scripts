#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($target_reg, $meth_dir, $out) = @ARGV;

sub usage{
   my $die =<<DIE;
perl $0 <target region> <meth_dir> <out>        >> ecotype list
DIE
}

open REG, $target_reg or die "$!";
my %tar_reg;
while(<REG>){
    chomp;
    my ($chr,$stt,$end) = split;
    for(my $i = $stt; $i <= $end; ++$i){
        $tar_reg{"$chr\t$i"} ++;
    }
}
close REG;

open OUT, "+>$out" or die "$!";
my @meth_file = <$meth_dir/*.tsv.gz>;
#GSM1085334_mC_calls_Westkar_4_bud.tsv.gz
foreach(@meth_file){
    chomp;
    open METH, "zcat $_|" or die "$!";
    print "$_\n";
    my ($eco) = $_ =~ /GSM\d+_mC_calls_(.*).tsv.gz/;
    $eco =~ s/_bud//g; 
    while( my $line = <METH>){
        #chrom   pos     strand  mc_class        methylated_bases        total_bases     methylation_call
	next if $line =~ /chrom/;
	my ($chr, $pos, $strand, $mc_class, $num_c, $tot) = split(/\s+/, $line);
        my $class = &judge_class($mc_class);
        $chr = "chr".$chr;
        $pos += 1;
        print OUT "$chr\t$pos\t$pos\t$eco\t$class\t$num_c\t$tot\n" if exists $tar_reg{"$chr\t$pos"};
    }
} 

close OUT;
sub judge_class{
    my ($mc_class) = @_;
    if($mc_class =~ /^CG/){
        return "CpG";
    }elsif($mc_class =~ /^C[A|T|C]G/){
        return "CHG";
    }else{
        return "CHH";
    }
}
