#!/usr/bin/perl -w
open F,$ARGV[0] or die;
while(<F>){
	if(/^(@.*)\/\d$/){$hash{$1}++}

}
close F;

open G,$ARGV[1] or die;
while(<G>){
	if(/^(@.*)\/\d$/){$hash{$1}++}
}
close G;

open H,$ARGV[2] or die;
open I,$ARGV[3] or die;
open OUT1,"+>$ARGV[4]" or die;
open OUT2,"+>$ARGV[5]" or die;
while(<H>){
	/^(@.*)\/\d$/;
	$p1_n1=$_;
	$_=<I>;
	$p2_n1=$_;
	
	$_=<H>;
	$p1_s=$_;
	$_=<I>;
	$p2_s=$_;

	$_=<H>;
	$p1_n2=$_;
	$_=<I>;
	$p2_n2=$_;
	
	$_=<H>;
	$p1_q=$_;
	$_=<I>;
	$p2_q=$_;
	
	if($hash{$1}){
		print OUT1 $p1_n1,$p1_s,$p1_n2,$p1_q;
		print OUT2 $p2_n1,$p2_s,$p2_n2,$p2_q;
	}
}
close H;
close I;
close OUT1;
close OUT2;
