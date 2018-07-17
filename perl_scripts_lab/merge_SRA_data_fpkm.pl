#   mkdir bam_stat 
#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dir, $out) = @ARGV;

my @files = <$dir/cufflinks_*/genes.fpkm_tracking>;
my @eco;
my %fpkm;
foreach(@files){
    print "Starting $_\n";
    open FILE,$_ or die "$!";
    my ($eco) = $_ =~ /\/cufflinks_(.*)\/genes.fpkm_tracking/;
    $eco =~ s/-/_/g; 
    push @eco, $eco;
    while(my $line = <FILE>){
        chomp $line;
        next if $line =~ /tracking_id/;
        #tracking_id     class_code      nearest_ref_id  gene_id gene_short_name tss_id  locus   length  coverage        FPKM   
        my ($gene_id,$coor, $fpkm) = (split(/\t/, $line))[0,6,9];
        $gene_id =~ s/\.1//;
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
