#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==5;
my ($gff,$te_select,$gene_rank,$cut,$out)=@ARGV;

open OUT,"+>$out" or die;
open SEL,$te_select or die "$!";
my %hash_selec;
while(<SEL>){
    chomp;
    $hash_selec{$_} ++;
}

open TE,$gff or die "$!";my %hash;
while(<TE>){
    chomp;
    my ($chrom,$stt,$end,$strand,$type)=(split(/\t/,$_));
    next if !exists $hash_selec{$type};
    my $pos=int (($end+$stt)/2);
    $hash{"$chrom\t$pos"}++;
}

open POS,$gene_rank or die;
my %prom_density;my %body_density;my %terminal_density;my $flag=1;
my (%promot_len,%down_len,%body_len);
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand,$type,$fpkm,$rank)=split(/\s+/,$line);
    next if ($line !~ /^\d/ || $line =~ /^#/);
    $promot_len{$rank} += 2000;
    $down_len{$rank} += 2000;
    $body_len{$rank} += $end-$stt+1;
    foreach(my $i=$stt-1999;$i<=$end+1999;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$rank,$i,$hash{"$chr\t$i"});
        }
    }
}
%hash=();

foreach(sort{$a<=>$b}keys %prom_density){
    my $nomal_dens;
    my $rank = 0;
    foreach my $tem_nu(@{$prom_density{$_}}){
        $tem_nu = 0 if !$tem_nu;
        my $tem_nam = $tem_nu*1000000*100 / $promot_len{$rank};
        $nomal_dens .= "\t$tem_nam";
        ++ $rank;
    }
    print OUT "$_"."$nomal_dens\n";
    foreach my $rank(0..5){
        my $tem_nu = 0 if (${$prom_density{$_}}[0];
        my $tem_nam = $tem_nu*1000000*100 / $promot_len{$rank};
        $nomal_dens .= "\t$tem_nam";
    }
    print OUT "$_"."$nomal_dens\n";
}
foreach(sort{$a<=>$b}keys %body_density){
    my $nomal_dens;
    my $rank = 0;
    foreach my $tem_nu(@{$body_density{$_}}){
        $tem_nu = 0 if !$tem_nu;
        my $tem_nam = $tem_nu*1000000*$cut / $body_len{$rank};
        $nomal_dens .= "\t$tem_nam";
        ++ $rank;
    }
    print OUT "$_"."$nomal_dens\n";
}
foreach(sort{$a<=>$b}keys %terminal_density){
    my $nomal_dens;
    my $rank = 0;
    foreach my $tem_nu(@{$terminal_density{$_}}){
        $tem_nu = 0 if !$tem_nu;
        my $tem_nam = $tem_nu*1000000*100 / $down_len{$rank};
        $nomal_dens .= "\t$tem_nam";
        ++ $rank;
    }
    print OUT "$_"."$nomal_dens\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$rank,$pos1,$methlev)=@_;
    my $unit=($end-$stt)/$cut;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            ${$prom_density{$keys}}[$rank]++;
        }elsif($pos1>=$stt && $pos1<=$end){
            $keys=int (($pos1-$stt)/$unit);
            ${$body_density{$keys}}[$rank]++;
        }else{
            $keys=int(($pos1-$end)/100);
            ${$terminal_density{$keys}}[$rank]++;
        }
    }else{
        if($pos1<$stt){
            $keys=int(($stt-$pos1)/100);
            ${$terminal_density{$keys}}[$rank]++;
        }elsif($pos1>=$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            ${$body_density{$keys}}[$rank]++;
        }else{
            $keys=int(($end-$pos1)/100);
            ${$prom_density{$keys}}[$rank]++;
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE GFF file> <TE selected> <Gene FPKM rank6> <Bin number> <OUTPUT>
    This is to get the methylation distribution throughth gene or TEs
DIE
}
