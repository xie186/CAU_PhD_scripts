#!/usr/bin/perl -w
use strict;
my ($gff)=@ARGV;
die usage() unless @ARGV==1;

open GFF,"grep 'Note' $gff|" or die "$!";
my %hash_protein;
while(<GFF>){
   chomp;
   my ($chr,$spec,$ele,$stt,$end,$fei1,$strand,$fei2,$gff_id)=split;
   my ($type,$name) = $gff_id =~ /Note=(.*);Name=(.*)/;
   next if $type ne "protein_coding_gene";
   $hash_protein{$name} ++;
}

open GFF,$gff or die "$!";
my %hash;
my %hash_strand;
while(<GFF>){
    chomp;
    my ($chr,$spec,$ele,$stt,$end,$fei1,$strand,$fei2,$gff_id)=split;
    $chr = lc $chr;
     
    next if $chr!~/chr\d/;
    if($ele eq "mRNA"){
        my ($id)=split(/;/,$gff_id);
        my ($name)=(split(/=/,$id))[1];

        my ($tem_name) = $name =~ /(.*)\.\d*/;
        next if !exists $hash_protein{$tem_name};

        &up_down($chr,$spec,$ele,$stt,$end,$strand,$name);
    }elsif($ele eq "exon"){
         my ($name)=(split(/=/,$gff_id))[1];

         my ($tem_name) = $name =~ /(.*)\.\d*/;
         next if !exists $hash_protein{$tem_name}; 

         push @{$hash{$name}},"$chr\t$stt\t$end\t$strand";
         $hash_strand{$name}=$strand;
    }else{
    }
}
close GFF;
foreach(keys %hash){
    chomp;
    if(@{$hash{$_}}==1){
        my ($chr,$stt,$end,$strand)=split(/\t/,${$hash{$_}}[0]);
        print "$chr\t-\tsingle_exon\t$stt\t$end\t-\t$strand\t-\t$_\n";
    }elsif(@{$hash{$_}}==2){
        &sin_intron($_);
    }else{
        &inter_intron($_);    
    }
}

sub inter_intron{
    my ($name)=@_;
    if($hash_strand{$name} eq "+"){
        my $intron_report=0;
        for(my $i=0;$i<@{$hash{$name}};++$i){
            if($i == 0){
                 my ($chr1,$exon_stt1,$exon_end1,$strand1)=split(/\t/,${$hash{$name}}[$i]);
                 print "$chr1\t-\tfirst_exon\t$exon_stt1\t$exon_end1\t-\t$strand1\t-\t$name\n";
            }elsif($i > 0 && $i < @{$hash{$name}}){
                 my ($chr1,$exon_stt1,$exon_end1,$strand1)=split(/\t/,${$hash{$name}}[$i-1]);
                 my ($chr2,$exon_stt2,$exon_end2,$strand2)=split(/\t/,${$hash{$name}}[$i]);
                 my $intron_stt=$exon_end1+1;
                 my $intron_end=$exon_stt2-1;
                 if($intron_report == 0){
                     print "$chr1\t-\tfirst_intron\t$intron_stt\t$intron_end\t-\t$strand1\t-\t$name\n";
                 }else{
                     print "$chr1\t-\tinternal_intron\t$intron_stt\t$intron_end\t-\t$strand1\t-\t$name\n";
                 }
                 ++$intron_report;
                 if($i < @{$hash{$name}} - 1){
                    print "$chr2\t-\tinternal_exon\t$exon_stt2\t$exon_end2\t-\t$strand2\t-\t$name\n";
                }else{
                    print "$chr2\t-\tlast_exon\t$exon_stt2\t$exon_end2\t-\t$strand2\t-\t$name\n";
                }
            }else{
            }
        }    
    }else{
        my $intron_report=0;
        for(my $i = 0;$i < @{$hash{$name}};++$i){
            if($i == 0){
                my ($chr1,$exon_stt1,$exon_end1,$strand1)=split(/\t/,${$hash{$name}}[$i]);
                print "$chr1\t-\tfirst_exon\t$exon_stt1\t$exon_end1\t-\t$strand1\t-\t$name\n";
            }elsif($i > 0 && $i < @{$hash{$name}}){
                my ($chr1,$exon_stt1,$exon_end1,$strand1)=split(/\t/,${$hash{$name}}[$i-1]);
                my ($chr2,$exon_stt2,$exon_end2,$strand2)=split(/\t/,${$hash{$name}}[$i]);
                my $intron_stt = $exon_end2 + 1;
                my $intron_end = $exon_stt1 - 1;
                if($intron_report == 0){
                     print "$chr1\t-\tfirst_intron\t$intron_stt\t$intron_end\t-\t$strand1\t-\t$name\n";
                }else{
                     print "$chr1\t-\tinternal_intron\t$intron_stt\t$intron_end\t-\t$strand1\t-\t$name\n";
                }
                ++$intron_report;
                if($i < @{$hash{$name}} - 1){
                    print "$chr2\t-\tinternal_exon\t$exon_stt2\t$exon_end2\t-\t$strand2\t-\t$name\n";
                }else{
                    print "$chr2\t-\tlast_exon\t$exon_stt2\t$exon_end2\t-\t$strand2\t-\t$name\n";
                }
            }else{
            }
        }
    }
}

sub sin_intron{
    my ($name)=@_;
    my ($chr1,$exon_stt1,$exon_end1,$strand1)=split(/\t/,${$hash{$name}}[0]);
    my ($chr2,$exon_stt2,$exon_end2,$strand2)=split(/\t/,${$hash{$name}}[1]);   
    if($hash_strand{$name} eq "+"){
        my $intron_stt=$exon_end1+1;
        my $intron_end=$exon_stt2-1;
        print "$chr1\t-\tfirst_exon\t$exon_stt1\t$exon_end1\t-\t$strand1\t-\t$name\n";
        print "$chr1\t-\tsingle_intron\t$intron_stt\t$intron_end\t-\t$strand1\t-\t$name\n";
        print "$chr2\t-\tlast_exon\t$exon_stt2\t$exon_end2\t-\t$strand2\t-\t$name\n";
    }else{
        my $intron_stt=$exon_end2+1;
        my $intron_end=$exon_stt1-1;
        print "$chr1\t-\tfirst_exon\t$exon_stt1\t$exon_end1\t-\t$strand1\t-\t$name\n";
        print "$chr1\t-\tsingle_intron\t$intron_stt\t$intron_end\t-\t$strand1\t-\t$name\n";
        print "$chr2\t-\tlast_exon\t$exon_stt2\t$exon_end2\t-\t$strand2\t-\t$name\n";
    }
}
sub up_down{
    my ($chr,$spec,$ele,$stt,$end,$strand,$id)=@_;
    my $value1=$stt-2000;
    my $value2=$end+2000;
    my $value3=$stt-1;
    my $value4=$end+1;
    my @up;
    my @down;
    if($strand eq "+"){
        @up=($value1,$value3);
        @down=($value4,$value2);
    }else{
        @up=($value4,$value2);
        @down=($value1,$value3);
    }
    print "$chr\t-\tupstream\t$up[0]\t$up[1]\t-\t$strand\t-\t$id\n";
    print "$chr\t-\tdownstream\t$down[0]\t$down[1]\t-\t$strand\t-\t$id\n";
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <GFF>
DIE
}
