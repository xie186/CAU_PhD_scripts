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
my $ALL_RAND_HIGH = "ALL_RAND_HIGH";
my $ALL_RAND_LOW = "ALL_RAND_LOW";
open SNP,$snp or die "$!";
<SNP>;
my %snp_pos;
while(<SNP>){
    chomp;
    my ($chr,$pos,$dot,$geno1,$geno2) = split;
    next if $geno1 eq $geno2;
    $snp_pos{"$chr\t$pos"} = "$geno1\t$geno2";
}

$cytosine = "zcat $cytosine|" if $cytosine =~ /gz$/;
open CYTO,$cytosine or die "$!";
my %c_dmp;
my %c_all_high;
my %c_all_low;
while(<CYTO>){
        #chr5    70604317        8       10      5       1       7       1       4       5       0.165985616214449       0.131221719457013       1       0.807024
    my ($chr,$pos,$bmb_c,$bmb_t,$bmm_c,$bmm_t,$mbb_c,$mbb_t,$mbm_c,$mbm_t,$p1,$p2,$q1,$q2) = split;
    next if $pos !~ /\d+/;
    next if exists $snp_pos{"$chr\t$pos"};
#    $c_all_high{"$chr\t$pos"} ++ ;
    if($q1 < 0.01 && $q2 < 0.01){
        $c_dmp{"$chr\t$pos"} = "inbred1_high" if ($bmb_c/($bmb_c + $bmb_t) > $bmm_c/($bmm_c + $bmm_t)) && ($mbb_c/($mbb_c + $mbb_t) > $mbm_c/($mbm_c + $mbm_t));
        $c_dmp{"$chr\t$pos"} = "inbred2_high" if ($bmb_c/($bmb_c + $bmb_t) < $bmm_c/($bmm_c + $bmm_t)) && ($mbb_c/($mbb_c + $mbb_t) < $mbm_c/($mbm_c + $mbm_t));
    }elsif($q1 >= 0.05 && $q2 >= 0.05 ){
        $c_all_high{"$chr\t$pos"} ++ if ($bmb_c/($bmb_c + $bmb_t) > 0.6 && $bmm_c/($bmm_c + $bmm_t)) > 0.6 && ($mbb_c/($mbb_c + $mbb_t) >0.6  && $mbm_c/($mbm_c + $mbm_t) > 0.6); 
        $c_all_low{"$chr\t$pos"} ++ if ($bmb_c/($bmb_c + $bmb_t) < 0.2 && $bmm_c/($bmm_c + $bmm_t)) < 0.2 && ($mbb_c/($mbb_c + $mbb_t) < 0.2 && $mbm_c/($mbm_c + $mbm_t) < 0.2);
    }
}

my @dmp = keys %c_dmp;
my $dmp_num = @dmp;
my @all_high = keys %c_all_high;
my $all_high_num = @all_high;
my @all_low = keys %c_all_low;
my $all_low_num = @all_low;


my %win_num;
for(my $i = 1; $i <= $dmp_num; ++$i){
    ### dmp;
    my ($chr,$pos) = split(/\t/,$dmp[$i-1]);
    &cal_dmp($chr,$pos,$c_dmp{$dmp[$i-1]});
    
    ## rand sites;  high
    my $rand = int (rand($all_high_num));
    ($chr,$pos) = split(/\t/,$all_high[$rand]);
    &cal_dmp($chr,$pos,$ALL_RAND_HIGH);

       $rand = int (rand($all_low_num));
    ($chr,$pos) = split(/\t/,$all_low[$rand]);
    &cal_dmp($chr,$pos,$ALL_RAND_LOW);
    
}

foreach(keys %win_num){
#    print "$_\t$win_num{$_}\n";
    my @base_num;
   # A C T G 
     my @base = sort keys %{$win_num{$_}}; 
    foreach my $base(sort keys %{$win_num{$_}}){
        push @base_num, $win_num{$_}->{$base};
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
            #print "yy\t$chr\t$up_pos\t$geno_5003,$geno_8112\n";
        }
        if($geno_5003 =~ /[ATCG]/){
            $win_num{"$keys\tinbred1\t-$i"}->{$geno_5003} ++;
            $win_num{"$keys\tinbred2\t-$i"}->{$geno_8112} ++;
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
            $win_num{"$keys\tinbred1\t$i"}->{$geno_5003} ++;
            $win_num{"$keys\tinbred2\t$i"}->{$geno_8112} ++;
        }
    }
}
