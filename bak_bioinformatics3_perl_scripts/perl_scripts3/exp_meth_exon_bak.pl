#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($gff,$BIN) = @ARGV;
my %hash_gene;
my %hash_gene_len;
my %hash_gene_pos;
my %hash_gene_chr;
my %hash_gene_str;
open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$tool,$ele,$stt,$end,$flag1,$strand,$flag2,$name) = split;
    $chr = "chr".$chr; 
    if($ele eq "exon"){
        my ($gene_name) = $name =~ /Parent=(.*);Name=/;
           ($gene_name) = split(/_/,$gene_name) if $gene_name =~ /^GRMZM/;
#        print "$gene_name\n";
        for(my $i = $stt;$i <= $end; ++$i){
            $hash_gene{$gene_name}->{"$chr\t$i"} = 0;
        }
        push @{$hash_gene_pos{$gene_name}}, ($stt,$end);
        $hash_gene_chr{$gene_name} = $chr;
        $hash_gene_str{$gene_name} = $strand;
    }
}


foreach(keys %hash_gene){
    $hash_gene_len{$_} = keys %{$hash_gene{$_}};
    &gene_pos($_);
    &exon_pos($_);
}

sub exon_pos{
    my ($gene_name) = @_;
    my $unit = $hash_gene_len{$gene_name} / $BIN;
    my ($chr,$stt,$end,$strand) = ($hash_gene_chr{$gene_name}, @{$hash_gene_pos{$gene_name}},$hash_gene_str{$gene_name});
#    print "$chr,$stt,$end,$strand\n";
    if($strand eq "+"){
        my $count=0;
        for(my $i = $stt;$i <= $end;++$i){
            if(exists $hash_gene{$_}->{"$chr\t$i"}){
                 ++ $count;
                 $hash_gene{$_}->{"$chr\t$i"} = int ($count/$unit)+1;
                 $hash_gene{$_}->{"$chr\t$i"} = $BIN if $hash_gene{$_}->{"$chr\t$i"} > $BIN;
#                 print "$hash_gene{$_}->{\"$chr\t$i\"}\n";
            }
        }
    }else{
        my $count=0;
        for(my $i = $end;$i >= $stt;--$i){
            if(exists $hash_gene{$_}->{"$chr\t$i"}){
                 ++ $count;
                 $hash_gene{$_}->{"$chr\t$i"} = int ($count/$unit)+1;
                 $hash_gene{$_}->{"$chr\t$i"} = $BIN if $hash_gene{$_}->{"$chr\t$i"} > $BIN;
#                 print "$hash_gene{$_}->{\"$chr\t$i\"}\n";
            }
        }
    }
}

sub gene_pos{
    my ($gene_name) = @_;
    my @pos = sort{$a<=>$b} @{$hash_gene_pos{$gene_name}};
    @{$hash_gene_pos{$gene_name}} = ($pos[0],$pos[-1]);
    #print "gene_pos\t$pos[0],$pos[-1]\n";
}

sub usage{
    print <<DIE;
    perl *.pl <FGS GFF file> <Bin number> 
DIE
    exit 1;
}
