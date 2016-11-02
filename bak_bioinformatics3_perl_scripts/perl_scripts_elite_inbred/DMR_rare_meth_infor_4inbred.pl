#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($clus, $tis, $header, $out)  = @ARGV;

open CLUS,$clus or die "$!";
my %DMR_region;
while(<CLUS>){
    chomp;
    ## stat: "hypo" means the minority allele methylation stat.
    my ($chr,$stt,$end, $stat) = split;
    $chr = "chr".$chr if $chr !~ /chr/; 
    $DMR_region{"$chr\t$stt\t$end"} = $stat;
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
        next if ($c_num + $t_num) < 5;
        $meth_info{"$chr\t$pos"} = "$c_num\t$t_num";
    }
    close METH;
    print "Reading: $tis[$i] Done\n";
    foreach(keys %DMR_region){
        my ($chr,$stt,$end) = split;
        my ($c_num, $t_num,$sites) = (0, 0);
        for(my $j = $stt;$j <= $end; ++$j){
            if(exists $meth_info{"$chr\t$j"}){
                my ($tem_c_num,$tem_t_num) = split(/\t/,$meth_info{"$chr\t$j"});
                $c_num += $tem_c_num;
                $t_num += $tem_t_num;
                ++ $sites;
            }
        }
        if($c_num + $t_num == 0 || $sites/($end - $stt + 1) < 5/200){
#        if($c_num + $t_num == 0){
            push @{$meth_DMR{"$chr\t$stt\t$end"}}, "nan";
        }else{
            push @{$meth_DMR{"$chr\t$stt\t$end"}}, $c_num / ($c_num + $t_num);
            #push @{$meth_DMR{"$chr\t$stt\t$end"}}, $t_num / ($c_num + $t_num);  ## modi by xie 20130820
        }
    }
}

open OUT,"+>$out" or die "$!";
$header =~ s/,/\t/g;
print OUT "chr\tstt\tend\t$header\n";
foreach(keys %DMR_region){
    chomp;
    my ($chr,$stt,$end) = split;
    my $meth_infor = join("\t", @{$meth_DMR{"$chr\t$stt\t$end"}});
    next if $meth_infor =~ /nan/;
    print "$_\t$meth_infor\n";
    for(my $i = 0; $i < @{$meth_DMR{"$chr\t$stt\t$end"}}; ++$i){
        if( ${$meth_DMR{"$chr\t$stt\t$end"}}[$i] < 0.5){
            ${$meth_DMR{"$chr\t$stt\t$end"}}[$i] = "hypo";
        }else{
            ${$meth_DMR{"$chr\t$stt\t$end"}}[$i] = "hyper";
        }
        if(${$meth_DMR{"$chr\t$stt\t$end"}}[$i] eq $DMR_region{"$chr\t$stt\t$end"}){
            ${$meth_DMR{"$chr\t$stt\t$end"}}[$i] = 1;  ## rare allele 
        }else{
            ${$meth_DMR{"$chr\t$stt\t$end"}}[$i] = 0;   ## common allele
        }
    }
    $meth_infor = join("\t", @{$meth_DMR{"$chr\t$stt\t$end"}});
    print OUT "$_\t$meth_infor\n";
}
close OUT;

sub usage{
    my $die = <<DIE;
    perl *.pl <DMR> <bedgraph methinfor[tis1,tis2,tis3]> <header [8112,478,5003,Zheng58]  OUT 
DIE
}
