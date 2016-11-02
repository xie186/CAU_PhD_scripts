#!/usr/bin/perl -w
use strict;

my ($cytosine,$snp,$win,$context) =  @ARGV;
die usage() unless @ARGV == 4;
sub usage{
    my $die =<<DIE;
    perl *.pl <qvalue res> <SNP> <win size> <context> 
DIE
}
my $DMP = "DMP";
my $ALL_RAND = "ALL_RAND";
open SNP,$snp or die "$!";
<SNP>;
my %snp_pos;
while(<SNP>){
    chomp;
    my ($chr,$pos,$geno_5003,$geno_8112) = split;
    next if $geno_5003 eq $geno_8112;
    $snp_pos{"$chr\t$pos"} ++;
}

$cytosine = "zcat $cytosine|" if $cytosine =~ /gz$/;
open CYTO,$cytosine or die "$!";
my %c_dmp;
my %c_all;
while(<CYTO>){
    my ($chr, $pos, $qvalue, $stat_bw_parent) = (split)[0,1,-2, -1];
    next if $stat_bw_parent eq "N";  #judge whether the methylation state of 2 parents were different.
    next if exists $snp_pos{"$chr\t$pos"};
    if($context eq "CpG"){
        my $tem_pos = $pos + 1;
        next if exists $snp_pos{"$chr\t$tem_pos"};
    }elsif($context eq "CHG"){
        my $tem_pos = $pos + 2;
        next if exists $snp_pos{"$chr\t$tem_pos"};
    }
    $c_all{"$chr\t$pos"} ++;
    if($qvalue < 0.01){
        $c_dmp{"$chr\t$pos"} ++;
    }
}

my @dmp = keys %c_dmp;
my $dmp_num = @dmp;
my @all = keys %c_all;
my $all_num = @all;

my %win_num;
for(my $i = 1; $i <= $dmp_num; ++$i){
    ### dmp;
    my ($chr,$pos) = split(/\t/,$dmp[$i-1]);
    &cal_dmp($chr,$pos,$DMP);        
    
    ## rand sites;
    my $rand = int (rand($all_num));
    ($chr,$pos) = split(/\t/,$all[$rand]);
    &cal_dmp($chr,$pos,$ALL_RAND);
}

foreach(keys %win_num){
    print "$_\t$win_num{$_}\n";
}

sub cal_dmp{
    my ($chr,$pos,$keys) = @_;
    for(my $i = 1;$i <= $win; ++$i){
        my $up_pos= $pos - $i;
        if(exists $snp_pos{"$chr\t$up_pos"}){
            $win_num{"$keys\t-$i"} ++;
        }
        if($context eq "CpG"){
            my $down_pos= $pos + $i + 1;
            if(exists $snp_pos{"$chr\t$down_pos"}){
                $win_num{"$keys\t$i"} ++;
            }
        }elsif($context eq "CHG"){
            my $down_pos= $pos + $i + 2;
            if(exists $snp_pos{"$chr\t$down_pos"}){
                $win_num{"$keys\t$i"} ++;
            }
        }elsif($context eq "CHH"){
            my $down_pos= $pos + $i;
            if(exists $snp_pos{"$chr\t$down_pos"}){
                $win_num{"$keys\t$i"} ++;
            }
        }else{
            die "Wrong context given: $context\n";
        }
    }
}

