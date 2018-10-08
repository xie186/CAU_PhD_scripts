#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($clus, $prop_cut,$prefix,$gene_pos,$bam_pwd) = @ARGV;
open CLUS,$clus or die "$!";
my $haplo_group = 1;
my %hash_group;
while(<CLUS>){
    chomp;
    my($id1,$id2,$prop,$tot_inbred,$inbred_name)  = split;
    next if $prop < $prop_cut;
    my @inbred_name = split(/-/,$inbred_name);
    push @{$hash_group{$haplo_group}},@inbred_name;
    ++ $haplo_group;
}

foreach(keys %hash_group){
    open OUT ,"+>$prefix.group$_.fq" or die "$!";
    my $out_fa1 = "$prefix.group$_\_1.fa";
    my $out_fa2 = "$prefix.group$_\_2.fa";
    my $out_fa = "$prefix.group$_.fa";
    my %hash_read;
    foreach my $inbred( @{$hash_group{$_}}){
        my $tem_inbred = $inbred;
           $tem_inbred =~ s/CAU0/CAU/;
        if(-e "$bam_pwd/$inbred.sorted.picard.bam"){
            open READ1,"samtools view -f 0x0040 $bam_pwd/$inbred.sorted.picard.bam $gene_pos |" or die "$!";
            while (my $read = <READ1>){
                my ($read_id,$seq,$qual) = (split(/\t/,$read))[0,9,10];
                print OUT "\@$read_id\n$seq\n+\n$qual\n";
                push @{$hash_read{$read_id}},"$seq\n+\n$qual\n";
            }
            open READ2,"samtools view -f 0x0080 $bam_pwd/$inbred.sorted.picard.bam $gene_pos |" or die "$!";
            while (my $read = <READ2>){
                my ($read_id,$seq,$qual) = (split(/\t/,$read))[0,9,10];
                print OUT "\@$read_id\n$seq\n+\n$qual\n";
                push @{$hash_read{$read_id}},"$seq\n+\n$qual\n";
            }
        }
        if(!-e "$bam_pwd/$inbred.sorted.picard.bam" && -e "$bam_pwd/$tem_inbred.sorted.picard.bam"){
            print "$_\t$tem_inbred\tinbred_id_not_equal\n";
            open READ1,"samtools view -f 0x0040 $bam_pwd/$tem_inbred.sorted.picard.bam $gene_pos|" or die "$!";
            while (my $read = <READ1>){
                my ($read_id,$seq,$qual) = (split(/\t/,$read))[0,9,10];
#                push @{$hash_read{$read_id}},$seq;
                push @{$hash_read{$read_id}},"$seq\n+\n$qual\n";
            }
            open READ2,"samtools view -f 0x0080 $bam_pwd/$tem_inbred.sorted.picard.bam $gene_pos|" or die "$!";
            while (my $read = <READ2>){
                my ($read_id,$seq,$qual) = (split(/\t/,$read))[0,9,10];
                print OUT "\@$read_id\n$seq\n+\n$qual\n";
                push @{$hash_read{$read_id}},"$seq\n+\n$qual\n";
            }
        }
    }
#    &trim_single("$prefix.group$_.fq",$out_fa);
    open OUT1,"+>$prefix.group$_\_1.fq" or die "$!";
    open OUT2,"+>$prefix.group$_\_2.fq" or die "$!";
    foreach my $read_id(keys %hash_read){
        my $pair = @{$hash_read{$read_id}};
        next if $pair != 2;
        print OUT1 "\@$read_id\n$hash_read{$read_id}[0]";
        print OUT2 "\@$read_id\n$hash_read{$read_id}[1]";
    }
    close OUT1;
    close OUT2;
#    &trim_paired("$prefix.group$_\_1.fq","$prefix.group$_\_2.fq",$out_fa1,$out_fa2);
}

sub trim_single{
    my ($read,$out_fa) = @_;
    system("perl /NAS1/software/SolexaQA_1.12/DynamicTrim.pl $read");
    open FA,"+>$out_fa" or die "$!";
    open TRIM,"$read.trimmed" or die "$!";
    while(my $id = <TRIM>){
        chomp;
        my $seq = <TRIM>;
        <TRIM>;<TRIM>;
        print FA ">$id"."$seq";
    }
    close FA;
    close TRIM;
    system("rm $read $read.trimmed");
}

sub trim_paired{
    my ($read1,$read2,$out_fa1,$out_fa2) = @_;
    system("perl /NAS1/software/SolexaQA_1.12/DynamicTrim.pl $read1");
    system("perl /NAS1/software/SolexaQA_1.12/DynamicTrim.pl $read2");
    system("perl /NAS1/software/SolexaQA_1.12/LengthSort.pl $read1.trimmed $read2.trimmed");

    open FA,"+>$out_fa1" or die "$!";
    open TRIM,"$read1.trimmed.paired1" or die "$!";
    while(my $id = <TRIM>){
        chomp;
        my $seq = <TRIM>;
        <TRIM>;<TRIM>;
        print FA ">$id"."$seq";
    }
    close FA;
    close TRIM;

    open FA,"+>$out_fa2" or die "$!";
    open TRIM,"$read1.trimmed.paired2" or die "$!";
    while(my $id = <TRIM>){
        chomp;
        my $seq = <TRIM>;
        <TRIM>;<TRIM>;
        print FA ">$id"."$seq";
    }
    close FA;
    close TRIM;
    system("rm *trimmed* $prefix*fq");
}

sub usage{
    my $die =<<DIE;
    perl *.pl <Cluster> <Cutoff> <prefix out> <gene pos>  <bam pwd> 
DIE
}
