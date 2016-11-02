#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($snp_geno, $gff, $out) = @ARGV;

open GENO,$snp_geno or die "$!";
my %hash_imp;
while(<GENO>){
    chomp;
    my ($chr,$pos,$dot,$ref,$alt) = split;
    $hash_imp{"$chr\t$pos"} = "$chr\t$pos\t$ref/$alt";
}

open OUT,"+>$out" or die "$!";
open GFF,$gff or die "$!";
my %hash_anno;
my %hash_anno_rep;
my %snp_imp;
my %gene_pos;
while(<GFF>){
    chomp;
    &snp_anno($_);
}

foreach(keys %hash_imp){
    if(exists $snp_imp{$_}){
        foreach my $anno (@{$hash_anno{$_}}){
            print "xx\t$_\t$hash_anno_rep{$_}\n";
            if($hash_anno_rep{$_} =~ /exon/){
                next if $anno =~ /intron|promoter|downstream/; 
                print OUT "$anno\n";
            }elsif($hash_anno_rep{$_} =~ /intron/){
                next if $anno =~ /promoter|downstream/;
                print OUT "$anno\n";
            }elsif($hash_anno_rep{$_} =~ /promoter/){
                next if $anno =~ /downstream/;
                print OUT "$anno\n";
            }else{
                print OUT "$anno\n";
            }
        }
    }else{
        print OUT "$hash_imp{$_}\tNA\tNA\tintergenic\tNA\tNA\tNA\n";
    }
}

close OUT;
close GFF;


sub snp_anno{
    my ($line) = @_;
    my ($chr,$tools,$ele,$stt,$end,$dot1,$strand,$dot2,$id) = split(/\t/,$line);

    if($ele eq "gene"){
        my ($gene) = $id =~ /ID=(.*);Name=/;
        $gene_pos{$gene} = "$chr\t$stt\t$end\t$strand";
        &judge_up_down($chr,$stt,$end,$gene,$strand);
    }elsif($ele eq "intron" || $ele eq "exon"){
        my ($gene) = $id =~ /Parent=(.*);Name/;
           ($gene) = split(/_/,$gene) if $gene =~ /^GRMZM/;
           $gene =~ s/FGT/FG/;
    #    push @{$gene_ele{$gene}->{$ele}} , "$chr\t$stt\t$end\t$strand";
         &judge_ele($chr,$stt,$end,$gene,$strand,$ele);
    }
}
sub judge_ele{
    my ($chr,$stt,$end,$gene,$strand,$ele) = @_;
    my ($ge_chr,$ge_stt,$ge_end,$ge_strand) = split(/\t/,$gene_pos{$gene});
    for(my $i = $stt;$i <= $end; ++ $i){
        if(exists $hash_imp{"$chr\t$i"}){
            $snp_imp{"$chr\t$i"} ++;   ### stat the snp in genic regions
            my ($rela_pos, $tem_stt, $tem_end) = (0, 0, 0);
            if($strand eq "+"){
                $rela_pos = $i - $ge_stt +1; 
                ($tem_stt,$tem_end) = ($stt - $ge_stt + 1, $end - $ge_stt + 1);
            }else{
                $rela_pos = $ge_end - $i +1;
                ($tem_stt,$tem_end) = ($ge_end - $end + 1, $ge_end - $stt + 1);
            }
            push @{$hash_anno{"$chr\t$i"}}, "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\t$ele\t$tem_stt\t$tem_end\t$strand";
            $hash_anno_rep{"$chr\t$i"} .= "$ele";
#            print OUT "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\t$ele\t$tem_stt\t$tem_end\t$strand\n";
        }
    }
}

sub judge_up_down{
    my ($chr,$stt,$end,$gene,$strand) = @_;
    for(my $i = $stt - 2000;$i < $stt; ++ $i){
            if(exists $hash_imp{"$chr\t$i"}){
                $snp_imp{"$chr\t$i"} ++;  ### stat the snp in genic regions
                if($strand eq "+"){
                    my $rela_pos = $i - $stt;
                    push @{$hash_anno{"$chr\t$i"}}, "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\tpromoter\tNA\tNA\t$strand";
                    $hash_anno_rep{"$chr\t$i"} .= "promoter";
#                    print OUT "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\tpromoter\tNA\tNA\t$strand\n";
                }else{
                    my $rela_pos = $stt - $i;
                    push @{$hash_anno{"$chr\t$i"}}, "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\tdownstream\tNA\tNA\t$strand";
                    $hash_anno_rep{"$chr\t$i"} .= "downstream";
#                    print OUT "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\tdownstream\tNA\tNA\t$strand\n";
                }
            }
    }
    for(my $i = $end + 1; $i <= $end + 2000; ++ $i){
            if(exists $hash_imp{"$chr\t$i"}){
                $snp_imp{"$chr\t$i"} ++;      ### stat the snp in genic regions
                if($strand eq "+"){
                    my $rela_pos = $i - $end; 
                    push @{$hash_anno{"$chr\t$i"}}, "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\tdownstream\tNA\tNA\t$strand";
                    $hash_anno_rep{"$chr\t$i"} .= "downstream";
#                    print OUT "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\tdownstream\tNA\tNA\t$strand\n";
                }else{
                    my $rela_pos = $end - $i;
                    push @{$hash_anno{"$chr\t$i"}}, "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\tpromoter\tNA\tNA\t$strand";
                    $hash_anno_rep{"$chr\t$i"} .= "promoter";
#                    print OUT "$hash_imp{\"$chr\t$i\"}\t$gene\t$rela_pos\tpromoter\tNA\tNA\t$strand\n";
                }
            }
    }
}

sub usage{
    print <<DIE;
    perl *.pl <SNP geno> <gene position [gff]> <OUT put> 
DIE
    exit 1;
}
