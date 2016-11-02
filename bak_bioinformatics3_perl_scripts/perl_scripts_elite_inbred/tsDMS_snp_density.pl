#!/usr/bin/perl -w
use strict;

my ($cytosine,$snp,$win,$context) =  @ARGV;
die usage() unless @ARGV == 4;
sub usage{
    my $die =<<DIE;
    perl *.pl <qvalue res> <SNP> <win size> <context> 
DIE
}
my $tDMS = "tDMS";
my $ALL_RAND_tDMS = "ALL_RAND_tDMS";
my $sDMS = "sDMS";
my $ALL_RAND_sDMS = "ALL_RAND_sDMS";
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
my %c_tdms;
my %c_sdms;
my %c_all_tdms;
my %c_all_sdms;
while(<CYTO>){
    my ($chr, $pos, $qvalue, $stat_bw_parent) = (split)[0,1,-2, -1];
    #next if $stat_bw_parent eq "N";  #judge whether the methylation state of 2 parents were different.
    next if exists $snp_pos{"$chr\t$pos"};
    if($context eq "CpG"){
        my $tem_pos = $pos + 1;
        next if exists $snp_pos{"$chr\t$tem_pos"};
    }elsif($context eq "CHG"){
        my $tem_pos = $pos + 2;
        next if exists $snp_pos{"$chr\t$tem_pos"};
    }
    if($stat_bw_parent eq "Y"){
        $c_all_tdms{"$chr\t$pos"} ++;
        $c_tdms{"$chr\t$pos"} ++ if $qvalue < 0.01;
    }else{  ## $stat_bw_parent eq "N"
        $c_all_sdms{"$chr\t$pos"} ++;
        $c_sdms{"$chr\t$pos"} ++ if $qvalue < 0.01;
    }
}

my @tdms = keys %c_tdms;
my @sdms = keys %c_sdms;
my $tdms_num = @tdms;
my $sdms_num = @sdms;

my @all_tdms = keys %c_all_tdms;
my $all_tdms_num = @all_tdms;
my @all_sdms = keys %c_all_sdms;
my $all_sdms_num = @all_sdms;

my %win_num;
for(my $i = 1; $i <= $tdms_num; ++$i){
    ### dmp;
    my ($chr,$pos) = split(/\t/,$tdms[$i-1]);
    &cal_dmp($chr,$pos,$tDMS);        
    
    ## rand sites;
    my $rand = int (rand($all_tdms_num));
    ($chr,$pos) = split(/\t/,$all_tdms[$rand]);
    &cal_dmp($chr,$pos,$ALL_RAND_tDMS);
}

for(my $i = 1; $i <= $sdms_num; ++$i){
    ### dmp;
    my ($chr,$pos) = split(/\t/,$sdms[$i-1]);
    &cal_dmp($chr,$pos,$sDMS);

    ## rand sites;
    my $rand = int (rand($all_sdms_num));
    ($chr,$pos) = split(/\t/,$all_sdms[$rand]);
    &cal_dmp($chr,$pos,$ALL_RAND_sDMS);
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

