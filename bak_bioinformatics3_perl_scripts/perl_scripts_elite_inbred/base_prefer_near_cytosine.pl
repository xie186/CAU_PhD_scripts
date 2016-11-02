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
    $snp_pos{"$chr\t$pos"} = "$geno_5003\t$geno_8112";
}

$cytosine = "zcat $cytosine|" if $cytosine =~ /gz$/;
open CYTO,$cytosine or die "$!";
my %c_dmp;
my %c_all;
while(<CYTO>){
    my ($chr,$pos,$lev1,$lev2,$dif,$pvalue,$qvalue) = (split)[0,1,-5,-4,-3,-2,-1];
#    print "$chr,$pos,$lev1,$lev2,$dif,$pvalue,$qvalue\n";
    next if exists $snp_pos{"$chr\t$pos"};
    if($context eq "CpG"){
        my $tem_pos = $pos + 1;
        next if exists $snp_pos{"$chr\t$tem_pos"};
    }elsif($context eq "CHG"){
        my $tem_pos = $pos + 2;
        next if exists $snp_pos{"$chr\t$tem_pos"};
    }
    if($qvalue >0.05 && $lev1>=0.60 && $lev2 >= 0.60){
        $c_all{"$chr\t$pos"} ++;
    }
    if($qvalue < 0.01){
    #    next if abs($dif) < 0.70;
        if($dif > 0){
            $c_dmp{"$chr\t$pos"} = "8112_HIGH";
        }else{
            $c_dmp{"$chr\t$pos"} = "5003_HIGH";
        }
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
    &cal_dmp($chr,$pos,$c_dmp{$dmp[$i-1]});
    
    ## rand sites;
#    my $rand = int (rand($all_num));
#    ($chr,$pos) = split(/\t/,$all[$rand]);
#    &cal_dmp($chr,$pos,$ALL_RAND);
}

foreach(keys %win_num){
#    print "$_\t$win_num{$_}\n";
    my @base_num;
   # A C T G 
     my @base = sort keys %{$win_num{$_}}; 
    foreach my $base(sort keys %{$win_num{$_}}){
        push @base_num, $win_num{$_}->{$base};
    }
    my $sum = $base_num[0] + $base_num[1]  + $base_num[2] + $base_num[3];
    for(my $i = 0;$i <4; ++ $i){
        $base_num[$i] = $base_num[$i] / $sum;
    }
    my $join_base_num = join("\t",@base_num);
#    print "$_\t@base\n";
    print "$_\t$join_base_num\n";
}

sub cal_dmp{
    my ($chr,$pos,$keys) = @_;
    for(my $i = 1;$i <= $win; ++$i){
        my ($geno_5003,$geno_8112) = (0,0);
        my $up_pos = $pos - $i;
        if(exists $snp_pos{"$chr\t$up_pos"}){
            ($geno_5003,$geno_8112) = split(/\t/,$snp_pos{"$chr\t$up_pos"});
            if($i == 1){
     #           print "xx\t$keys\t$geno_5003\t$geno_8112\n";
            }
            #print "yy\t$chr\t$up_pos\t$geno_5003,$geno_8112\n";
        }
        if($geno_5003 =~ /[ATCG]/){
            $win_num{"$keys\t5003\t-$i"}->{$geno_5003} ++;
            $win_num{"$keys\t8112\t-$i"}->{$geno_8112} ++;
        }
         
        ($geno_5003,$geno_8112) = (0,0);
        if($context eq "CpG"){
            my $down_pos= $pos + $i + 1;
            if(exists $snp_pos{"$chr\t$down_pos"}){
                ($geno_5003,$geno_8112) = split(/\t/,$snp_pos{"$chr\t$down_pos"});
            }
        }elsif($context eq "CHG"){
            my $down_pos= $pos + $i + 2;
            if(exists $snp_pos{"$chr\t$down_pos"}){
                ($geno_5003,$geno_8112) = split(/\t/,$snp_pos{"$chr\t$down_pos"});
            }
        }elsif($context eq "CHH"){
            my $down_pos= $pos + $i;
            if(exists $snp_pos{"$chr\t$down_pos"}){
                ($geno_5003,$geno_8112) = split(/\t/,$snp_pos{"$chr\t$down_pos"});
            }
        }else{
            die "Wrong context given: $context\n";
        }
        if($geno_5003 =~ /[ATCG]/){
            $win_num{"$keys\t5003\t$i"}->{$geno_5003} ++;
            $win_num{"$keys\t8112\t$i"}->{$geno_8112} ++;
        }
    }
}
