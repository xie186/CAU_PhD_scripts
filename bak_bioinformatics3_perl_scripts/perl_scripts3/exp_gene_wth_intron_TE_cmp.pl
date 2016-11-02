#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==5;
my ($TE_pos,$gff,$ge_pos,$out1,$out2)=@ARGV;
open POS,$TE_pos or die "$!";
my %hash;
my %hash_file;
while(<POS>){
    next if /#/;
    chomp;
    my ($chr,$stt,$end,$strand,$type)=(split)[0,1,2,3,4];
    my $mid=int (($stt+$end)/2);
    $hash{"$chr\t$mid"}=$type;
    $hash_file{"$chr\t$mid"}=$strand;
}

open GFF,$gff or die "$!";
open OUT1,"+>$out1" or die "$!";
open OUT2,"+>$out2" or die "$!";
my %hash_intron;
my %hash_ele_nu;
my %hash_ele_len;
my %hash_wth_TE;
my @wth_or;
while(<GFF>){
    chomp;
    next if (/chromosome/ || /CDS/ || /mRNA/ || /^##/);
    my ($chr,$ele,$stt,$end,$strand,$name)=(split)[0,2,3,4,6,8];
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
#    $name=~s/_T\d+// if $name=~/GRMZM/;
    my @aa=split;
    $aa[-1]=$name;

    if($ele!~/intron/){
        push @wth_or,"$chr\t$ele\t$stt\t$end\t$strand\t$name\tNO";
    }else{
        my $join=join("\t",@aa);
        $hash_ele_nu{"$ele"}++;
        $hash_ele_len{"$ele"}+=($end-$stt+1);
        my $flag=0; 
        for(my $i=$stt;$i<=$end;++$i){
            if(exists $hash{"$chr\t$i"}){
                my $TE_strand=$hash_file{"$chr\t$i"};
    #            print OUT "$TE\t$join\t$tem_rpkm\n";
                my $type=$hash{"$chr\t$i"};
                $hash_intron{"$ele\t$type"}++;
                $hash_wth_TE{$name}=$TE_strand;
                ++$flag;
            }
        }
        if($flag == 0){
            push @wth_or,"$chr\t$ele\t$stt\t$end\t$strand\t$name\tNO";
        }else{
            push @wth_or,"$chr\t$ele\t$stt\t$end\t$strand\t$name\tTE";
        }
    }
}

foreach(@wth_or){
    my ($chr,$ele,$stt,$end,$strand,$name,$stat)=split;
    if(exists $hash_wth_TE{$name}){
        print OUT1 "$_\n";
    }else{
        print OUT2 "$_\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE position> <GFF> <Geneposition [WGS][FGS]> <OUT gene not with TE insertion> <OUT gene not with TE insertion>
DIE
}
