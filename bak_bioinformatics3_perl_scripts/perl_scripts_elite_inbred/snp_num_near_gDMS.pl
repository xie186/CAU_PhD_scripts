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
    my ($chr,$pos,$dot,$geno1,$geno2) = split;
    next if $geno1 eq $geno2;
    $snp_pos{"$chr\t$pos"} ++;
}

$cytosine = "zcat $cytosine|" if $cytosine =~ /gz$/;
open CYTO,$cytosine or die "$!";
my %c_dmp;
my %c_all;
while(<CYTO>){
    #chr5    70604317        8       10      5       1       7       1       4       5       0.165985616214449       0.131221719457013       1       0.807024
    my ($chr,$pos,$bmb_c,$bmb_t,$bmm_c,$bmm_t,$mbb_c,$mbb_t,$mbm_c,$mbm_t,$p1,$p2,$q1,$q2) = split;
    next if $pos !~ /\d+/;
    next if exists $snp_pos{"$chr\t$pos"};
    $c_all{"$chr\t$pos"} ++;
    if($q1 < 0.01 && $q2 < 0.01){
        $c_dmp{"$chr\t$pos"} ++ if ($bmb_c/($bmb_c + $bmb_t) > $bmm_c/($bmm_c + $bmm_t)) && ($mbb_c/($mbb_c + $mbb_t) > $mbm_c/($mbm_c + $mbm_t));
        $c_dmp{"$chr\t$pos"} ++ if ($bmb_c/($bmb_c + $bmb_t) < $bmm_c/($bmm_c + $bmm_t)) && ($mbb_c/($mbb_c + $mbb_t) < $mbm_c/($mbm_c + $mbm_t));
    }
}

my @dmp = keys %c_dmp;
my $dmp_num = @dmp;
my @all = keys %c_all;
my $all_num = @all;

my %win_num;
for(my $i = 1; $i <= $dmp_num; ++$i){
    ### dmp;
    my ($chr,$pos) = split(/\t/,$dmp[$i - 1]);
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

