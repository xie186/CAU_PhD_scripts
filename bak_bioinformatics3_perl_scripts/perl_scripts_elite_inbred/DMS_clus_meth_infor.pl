#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($clus, $tis, $header, $out)  = @ARGV;

open CLUS,$clus or die "$!";
my %DMR_region;
while(<CLUS>){
    chomp;
    my ($chr,$stt,$end, $dms_num) = split;
    $DMR_region{"$chr\t$stt\t$end"} ++;
}
close CLUS; 

my @tis = split(/,/,$tis);
my %meth_DMR;
for(my $i = 0; $i < @tis; ++ $i){
    open METH, $tis[$i] or die "$!";
    print "start reading: $tis[$i]\n";
    my %meth_info;
    while(<METH>){
        chomp;
        my ($chr,$pos,$c_num,$t_num) = split(/\t/, $_);
        $meth_info{"$chr\t$pos"} = "$c_num\t$t_num";
    }
    close METH;
    print "Reading: $tis[$i] Done\n";
    foreach(keys %DMR_region){
#       chr10_80671886_80672336 
        my ($chr,$stt,$end) = split;
        my ($c_num, $t_num,$sites) = (0, 0, 0 );
        for(my $j = $stt;$j <= $end; ++$j){
            if(exists $meth_info{"$chr\t$j"}){
                my ($tem_c_num,$tem_t_num) = split(/\t/,$meth_info{"$chr\t$j"});
                $c_num += $tem_c_num;
                $t_num += $tem_t_num;
                ++ $sites;
            }
        }
#        if($c_num + $t_num == 0 || $sites/($end - $stt + 1) < 5/200){
#            push @{$meth_DMR{"$chr\t$stt\t$end"}}, "nan";
#        }else{
            push @{$meth_DMR{"$chr\t$stt\t$end"}}, $c_num / ($c_num + $t_num);
#        }
    }
}

open OUT,"+>$out" or die "$!";
$header =~ s/,/\t/g;
print OUT "#chr\tstt\tend\t$header\n";
foreach(keys %DMR_region){
    chomp;
    my ($chr,$stt,$end) = split;
    my $meth_infor = join("\t", @{$meth_DMR{"$chr\t$stt\t$end"}});
    next if $meth_infor =~ /nan/;
    #$_=~s/\t/_/g;
    print OUT "$_\t$meth_infor\n";
}
close OUT;

sub usage{
    my $die = <<DIE;
    perl *.pl <DMR> <bedgraph methinfor[tis1,tis2,tis3]> <header [8112,478,5003,Zheng58]  OUT 
DIE
}
