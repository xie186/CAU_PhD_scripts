#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($mfa, $species1, $species2, $out_dir) = @ARGV;

open MFA,$mfa or die "$!";
`mkdir $out_dir` if !-e "$out_dir";
my @align = <MFA>;
my $align = join("",@align); 
   @align = split(/=/,$align);
foreach my $tem_align (@align){
    next if $tem_align !~ />/;
    my @tem_seq = split(/>/,$tem_align);
       shift @tem_seq;
    my ($chr1,$stt1,$end1,$strand1,$tem_seq1,$id) = &proc_seq($tem_seq[0]);
    my ($chr2,$stt2,$end2,$strand2,$tem_seq2) = &proc_seq($tem_seq[1]);
#    print "xx$chr2,$stt2,$end2,$strand2,$tem_seq2\n";
       $chr2 = "chr".$chr2 if $chr2 !~ /chr/;
        foreach my $region(keys %{$hash_dmr{$chr2}}){
            my ($stt,$end) = split(/\t/,$region);
            if( ($stt < $stt2 && $end >= $stt2) ||  ($stt >= $stt2 && $stt <= $end2) ){
                print "DMR\_$chr2\_$stt\_$end\t$chr2\t$stt2\t$end2\t$strand2\t$chr1\t$stt1\t$end1\t$strand1\n";
                 &gener_VISTA($chr2,$stt2,$end2,$strand2,$tem_seq2, $chr1,$stt1,$end1,$strand1,$tem_seq1);
            }
        }
}

sub gener_VISTA{
    my ($chr2,$stt2,$end2,$strand2,$tem_seq2, $chr1,$stt1,$end1,$strand1,$tem_seq1) = @_;
    open VISTA,"+>./$out_dir/$chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.align" or die "$!";
    print VISTA ">$species1\_$chr2\_$stt2\_$end2\n$tem_seq2\n>$species2\_$chr1\_$stt1\_$end1\n$tem_seq1\n";
    close VISTA;
}

sub proc_seq{
    my ($seq) = @_;
    my ($id,@tem_seq) = split(/\n/,$seq);
    my $tem_seq = join("",@tem_seq);
    my ($chr,$stt,$end,$strand) = $id =~ /v\..*\s+(.*):(\d+)-(\d+)\s\(([+-])\)/;
    return ($chr,$stt,$end,$strand,$tem_seq,$id);
}

sub usage{
    my $die =<<DIE;
    perl *.pl <pDMR> <mfa file> <species1> <species2> <out_dir>
DIE
}
