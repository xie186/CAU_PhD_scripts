#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==4;
my ($repeat,$pos,$out)=@ARGV;
open OUT,"+>$out" or die;
my $start_time=localtime();

open REP,$repeat or die "$!";
while(<REP>){
    chomp;
    my ($chr,$stt,$end,$strand,$mips,$sec_mips,$number,$meth_pro)=split(/\t/);

}

open POS,$pos or die;
my %promoter;my %prom_exp;my %termina;my %ter_exp;my %intragenic;my %intra_exp;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($name,$chr,$stt,$end,$strand,$rpkm,$rank)=split(/\s+/,$line);
    $chr="chr0".$chr;
    if($strand eq "+"){
        &cal_forw($name,$chr,$stt,$end,$strand,$rpkm,$rank);
    }else{
        &cal_rev($name,$chr,$stt,$end,$strand,$rpkm,$rank);
    }
}
%hash=();

sub cal_forw{
    my ($name,$chr,$stt,$end,$strand,$rpkm,$rank)=@_;
    my ($meth,$report)=(0,0);
        #promoter
        for(my $i=-20;$i<=-1;++$i){
            for(my $j=1;$j<=100;++$j){
                my $key_part=$stt+$i*100+$j;
                if(exists $hash{"$chrom\t$key_part"}){
                    $meth+=$hash{"$chrom\t$key_part"};
                    $report++;
                }
            }
            if($report !=0;){
                push (@{$promoter{$i}},$meth);
                push (@{$prom_exp{$i}},$rpkm);
            }
        }
        #3' termination
        ($meth,$report)=(0,0);
        for(my $i=0;$i<20;++$i){
            for(my $j=1;$j<=100;++$j){
                my $key_part=$end-$i*100+$j;
                if(exists $hash{"$chrom\t$key_part"}){
                    $meth+=$hash{"$chrom\t$key_part"};
                    $report++;
                }
            }
            if($report !=0){
                push (@{$termina{$i+1}},$meth);
                push (@{$ter_exp{$i+1}},$rpkm);
            }
        }
        #gene body
        ($meth,$report)=(0,0);my $uni=($end-$stt)/100;
        for(my $i=0;$i<=99;++$i)
            for(my $j=int ($stt+$i*$uni);$j<=int($stt+($i+1)*$uni);++$j){
                if(exists $hash{"$chrom\t$j"}){
                        $meth+=$hash{"$chrom\t$j"};
                        $report++;
                }
            }
            if($report !=0){
                push(@{$intragenic{$i+1}},$meth); 
                push(@{$intra_exp{$i+1}},$rpkm);
            }
         }
}

sub cal_rev{
    my ($name,$chr,$stt,$end,$strand,$rpkm,$rank)=@_;
    my ($meth,$report)=(0,0);
        #promoter
        for(my $i=-19;$i<=0;++$i){
            for(my $j=1;$j<=100;++$j){
                my $key_part=$end-$i*100+$j;
                if(exists $hash{"$chrom\t$key_part"}){
                    $meth+=$hash{"$chrom\t$key_part"};
                    $report++;
                }
            }
            if($report !=0;){
                push (@{$promoter{$i-1}},$meth);
                push (@{$prom_exp{$i-1}},$rpkm);
            }
        }
        #3' termination
        ($meth,$report)=(0,0);
        for(my $i=1;$i<=20;++$i){
            for(my $j=1;$j<=100;++$j){
                my $key_part=$stt-$i*100+$j;
                if(exists $hash{"$chrom\t$key_part"}){
                    $meth+=$hash{"$chrom\t$key_part"};
                    $report++;
                }
            }
            if($report !=0){
                push (@{$termina{$i}},$meth);
                push (@{$ter_exp{$i}},$rpkm);
            }
        }
        #gene body
        ($meth,$report)=(0,0);my $uni=($end-$stt)/100;
        for(my $i=0;$i<=99;++$i)
            for(my $j=int ($stt+$i*$uni);$j<=int($stt+($i+1)*$uni);++$j){
                if(exists $hash{"$chrom\t$j"}){
                        $meth+=$hash{"$chrom\t$j"};
                        $report++;
                }
            }
            if($report !=0){
                push(@{$intragenic{100-$i}},$meth); 
                push(@{$intra_exp{100-$i}},$rpkm);
            }
        }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Forword> <Reverse> <Gene with expression Rank> <OUTPUT>
    To get the correlation between each bins and methylation
DIE
}
