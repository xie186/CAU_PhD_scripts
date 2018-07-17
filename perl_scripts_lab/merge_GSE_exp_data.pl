#   mkdir bam_stat 
#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dir, $out) = @ARGV;

my @files = <$dir/GSM*.tsv.gz>;
my @eco;
my %fpkm;
foreach(@files){
    print "Starting $_\n";
    $_ = "zcat $_|" if $_=~ /gz$/;
    open FILE,$_ or die "$!";
    my ($eco) = $_ =~ /GSM\d+_(.*)_expression.tsv.gz/; 
    push @eco, $eco;
    while(my $line = <FILE>){
        chomp $line;
        next if $line =~ /fpkm/;
        my ($gene_id,$coor, $fpkm) = split(/\t/, $line);
        push @{$fpkm{"$gene_id\t$coor"}}, $fpkm;
    }
}

my $eco = join("\t", @eco);
open OUT, "+>$out" or die "$!";
print OUT "#gene\tcoordinate\t$eco\n";
foreach(keys %fpkm){
    chomp;
    my $fpkm = join("\t", @{$fpkm{$_}});
    print OUT "$_\t$fpkm\n";
}

sub usage{
    my $die =<<DIE;
perl $0 <directory> <out> 
DIE
}
