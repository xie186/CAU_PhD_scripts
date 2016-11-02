#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==5;
my ($dmr,$gene)=@ARGV;

open DMR,$dmr or die "$!";
my %dmr_hash;
while(<DMR>){
    next if /^##/;
    chomp;
    my ($chr,$stt,$end)=split;
    my $mid=int (($stt+$end)/2);
    push (@{$dmr_hash{"$chr\t$mid"}},"Intergenic");
}
close DMR;

open GENE,$gene or die "$!";
my %hash;my %hash_len;
while(<GENE>){
    chomp;
    my ($chr,$ele,$stt,$end,$name)=(split)[0,2,3,4,-1];
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    next if($name=~/GRMZM/ && $name!~/T01/); 
    next if ($ele=~/chromosome/ || $ele=~/gene/ ||$ele=~/CDS/);
    $name=~s/_T01// if $name=~/GRMZM/;
        $chr="chr".$chr;
    $hash_len{$ele}+=$end-$stt+1;
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $dmr_hash{"$chr\t$i"}){
            $hash{$ele}++;
            push @{$dmr_hash{"$chr\t$i"}},"$name\t$ele";
        }
    }
}

foreach(keys %hash){
    print "==\t$_\t$hash{$_}\t$hash_len{$_}\n";
}

print "\n====================================================\n";
open DMR,$dmr or die "$!";
while(<DMR>){
    chomp;
    next if /^#/;
    my ($chr,$stt,$end)=split;
    my $mid=int (($stt+$end)/2);
    if(@{$dmr_hash{"$chr\t$mid"}}==1){
       print "$chr\t$stt\t$end\tIntergenic\n";
    }else{
       shift  @{$dmr_hash{"$chr\t$mid"}};       
       foreach my $line(@{$dmr_hash{"$chr\t$mid"}}){
           print "$chr\t$stt\t$end\t$line\n";
       }
    }
}
close DMR;

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR> <Gene ele gff>
DIE
}
