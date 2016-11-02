#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($snp,$genepos,$exon_seq,$cod)=@ARGV;

open EXON,$exon_seq or die "$!";
my @aa=<EXON>;
my $join=join('',@aa);
   $join=~s/>//;
   @aa=split(/>/,$join);
   $join=0;
my %hash_exon;

my $len=@aa;
for(my $i=0;$i<$len;++$i){
    my $tem_seq=shift @aa;
    my ($name,@seq)=split(/\n/,$tem_seq);
       chomp @seq;
       $tem_seq=join('',@seq);
    my ($gene)=(split(/\s+/,$name))[0];
    $hash_exon{$gene}=$tem_seq;
}

open SNP,$snp or die "$!";
my %hash_snp;
while(<SNP>){
    chomp;
    my($chr,$pos)=split;
    $hash_snp{"$chr\t$pos"}=$_;
}

open COD,$cod or die "$!";
my %hash_cod;
while(<COD>){
    chomp;
    my ($aa,@code_b)=split;
    foreach my $code(@code_b){
        $hash_cod{$code}=$aa;
    }
}

open GFF,$genepos or die "$!";
my %hash_cds;
my %hash_intron;
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end,$strand,$gene)=(split)[0,2,3,4,6,8];
    next if $ele ne 'CDS';
    ($gene)=$gene=~/Parent=(.*);Name/;
    push @{$hash_cds{$gene}},$_;
    push @{$hash_intron{$gene}}
}

open GFF,$genepos or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end,$strand,$gene)=(split)[0,2,3,4,6,8];
    next if($ele eq "chromosome" || $ele eq "exon" || $ele eq "gene");
    ($gene)=$gene=~/Parent=(.*);Name/;
    $chr="chr".$chr;
    &MRNA($chr,$ele,$stt,$end,$strand,$gene);
}

sub MRNA{
    my ($chr,$ele,$stt,$end,$strand,$gene)=@_;
    if($ele =~/CDS/){
        for(my $i=$stt;$i<=$end;++$i){
            if(exists $hash_snp{"$chr\t$i"}){
                my ($nu,$codon,$resi)=(0,0,0);                
                if($strand eq "+"){
                    for(my $j=0;$j<@{$hash_cds{$gene}};++$j){
                        my ($tem_chr,$tem_ele,$tem_stt,$tem_end)=(split(/\s/,${$hash_cds{$gene}}[$j]))[0,2,3,4,6];
                        if($i>$tem_end){
                            $nu+=($tem_end-$tem_stt+1);
                        }elsif($i>=$tem_stt  && $i<=$tem_end){
                            $nu+=($i-$tem_stt+1);
                        }else{
                            
                        }
                    }
                }else{
                    for(my $j=0;$j<@{$hash_cds{$gene}};++$j){
                        my ($tem_chr,$tem_ele,$tem_stt,$tem_end)=(split(/\s/,${$hash_cds{$gene}}[$j]))[0,2,3,4,6];
                        if($i<$tem_stt){
                            $nu+=($tem_end-$tem_stt+1);
#                            print "$tem_end-$tem_stt+1\n";
                        }elsif($i>=$tem_stt && $i<=$tem_end){
                            $nu+=($tem_end-$i+1);
#                            print "$tem_end-$i+1\n";
                        }else{
                             
                        }
                    }
                }
                $resi=$nu%3;
                $nu=int($nu/3-0.1);
                my $index_stt=3*$nu;
                   $codon=substr($hash_exon{$gene},$index_stt,3); 
                   next if $codon=~/N/;
                   my @tem_codon=split(//,$codon);
                   
                   if($resi!=0){
                       $tem_codon[$resi-1]=~tr/CG/TA/;
                   }else{
                       $tem_codon[2]=~tr/CG/TA/;
                   }
                   my $former_aa=$hash_cod{$codon};
                   my $codon_now=join('',@tem_codon);
                   my $now_aa=$hash_cod{$codon_now};
                   my $tem_len=length $hash_exon{"$gene"};
                 #  next if $former_aa eq $now_aa;
                   print "$hash_snp{\"$chr\t$i\"}\t$gene\t$ele\t$codon\t$former_aa\t$codon_now\t$now_aa\t$index_stt\t$nu\n" ;
            }
        }
    }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <SNP> <GFF file> <CDS sequence> <codon usage>
DIE
}
