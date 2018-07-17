#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;
my ($sam1,$sam2,$sam3,$p_cut,$out_hyper) = @ARGV;
my %hash_meth;
my %hash_c24;
foreach($sam1,$sam2,$sam3){
    open SAM,$_ or die "$!";
    while (my $cmp = <SAM>){
        chomp;
        my ($chr,$pos,$c_nu1,$t_nu1,$c_nu2,$t_nu2,$p_value) = split(/\t/,$cmp);
        push @{$hash_meth{"$chr\t$pos"}} ,"$c_nu1\t$t_nu1\t$p_value";
        $hash_c24{"$chr\t$pos"} = "$c_nu2\t$t_nu2";
    }
}

my @hash_sig = (0,0,0,0,0,0);
my ($sam2_to_sam1,$sam3_to_sam2,$sam3_to_sam1) = (0,0,0);
open HYPER,"+>$out_hyper" or die "$!";
foreach(keys %hash_meth){
    next if @{$hash_meth{$_}} <3;
    my $tem_3sam = join("\t",@{$hash_meth{$_}});
    my ($c_nu1,$t_nu1,$p_value1,$c_nu2,$t_nu2,$p_value2,$c_nu3,$t_nu3,$p_value3) = split(/\t/,$tem_3sam);
    my ($c24_c_nu,$c24_t_nu) = split(/\t/,$hash_c24{$_});
    my ($meth1,$meth2,$meth3,$meth4) = ( $c_nu1/($c_nu1+$t_nu1), $c_nu2/($c_nu2+$t_nu2), $c_nu3/($c_nu3+$t_nu3), $c24_c_nu/($c24_c_nu+$c24_t_nu) );
    ### hypermethylated in all three tissue
    if($p_value1 < $p_cut && $p_value2 < $p_cut && $p_value3 < $p_cut && $meth1 > $meth4 && $meth2 > $meth4 && $p_value3 < $p_cut){
    print HYPER "$_\t$c_nu1\t$t_nu1\t$c_nu2\t$t_nu2\t$c_nu3\t$t_nu3\t$c24_c_nu\t$c24_t_nu\t$meth1\t$meth2\t$meth3\t$meth4\t$p_value1\t$p_value2\t$p_value3\n";
    }

    ### statistics
    if($p_value1 < $p_cut){
        if($meth1 > $meth4){
            $hash_sig[0] ++;
        }else{
            $hash_sig[1] ++;
        }
    }
    if($p_value2 < $p_cut){
        if($meth2 > $meth4){
            $hash_sig[2] ++;
        }else{
            $hash_sig[3] ++;
        }
    }
    if($p_value3 < $p_cut){
        if($meth3 > $meth4){
            $hash_sig[4] ++;
        }else{
            $hash_sig[5] ++;
        }
    }
    $sam2_to_sam1 ++ if ($p_value1 < $p_cut && $p_value2 < $p_cut);
    $sam3_to_sam2 ++ if ($p_value3 < $p_cut && $p_value2 < $p_cut);
    $sam3_to_sam1 ++ if ($p_value1 < $p_cut && $p_value3 < $p_cut);
}

print "$sam2_to_sam1/($hash_sig[2] + $hash_sig[3]), $sam3_to_sam2/($hash_sig[4] + $hash_sig[5]), $sam3_to_sam1/($hash_sig[4] + $hash_sig[5]) \n";
my ($sam2_to_sam1_perc, $sam3_to_sam2_perc, $sam3_to_sam1_perc) = ( $sam2_to_sam1/($hash_sig[2] + $hash_sig[3]), $sam3_to_sam2/($hash_sig[4] + $hash_sig[5]), $sam3_to_sam1/($hash_sig[4] + $hash_sig[5]));

print <<RES;
156	$hash_sig[0]	$hash_sig[1]
204	$hash_sig[2]	$hash_sig[3]	$sam2_to_sam1_perc
ros1	$hash_sig[4]	$hash_sig[5]	$sam3_to_sam2_perc	$sam3_to_sam1_perc
RES

sub usage{
    my $die = <<DIE;
    perl *.pl <sam1> <sam2> <sam3> <p_value cut> <OUT hyper> 
DIE
}
