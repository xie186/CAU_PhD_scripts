#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($coor, $depth, $out) = @ARGV;

print "Start record site need to see ", `date`;
my %rec_depth;
open COOR,$coor or die "$!";
while(<COOR>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end, $id, $strand) = split;
    $chr = "chr".$chr if $chr !~ /chr/;
    for(my $i = $stt - 1999;$i < $end+1999;++$i){
        @{$rec_depth{"$chr\t$i"}} = ();
    }
}
close COOR;

my $BIN = 60;

print "Start recording depth information ", `date`;
my $flag1 = 1;
open DEP, $depth or die "$!";
my $header = <DEP>;
chomp $header;
my ($tem1,$tem2,@sam_id) = split(/\t/, $header);
my %rec_tot_depth;
while(<DEP>){
    chomp;
    print "$flag1 have processed\n" if $flag1 % 10000000 == 0;
    my ($chr, $pos, @depth) = split;
    $chr = "chr".$chr if $chr !~ /chr/;
    @{$rec_depth{"$chr\t$pos"}} = @depth if exists $rec_depth{"$chr\t$pos"};
    for(my $i = 0; $i < @depth; ++$i){
        $rec_tot_depth{$i} += $depth[$i];
    }
    ++$flag1;
}
close DEP;

print "Start processing distribution ", `date`;
my $flag = 1;
my ($len_up, $len_body, $len_down) = (0, 0, 0);
my %rec_bin_dep;
open COOR,$coor or die "$!";
while(<COOR>){
    chomp;
    print "$flag have processed\n" if $flag % 500 == 0;
    my ($chr, $stt, $end, $id, $strand,$rank) = split;
    $chr = "chr".$chr if $chr !~ /chr/;
    $len_up += 1999;
    $len_body += $end - $stt + 1;
    $len_down += 1999;
    for(my $i = $stt - 1999;$i < $end+1999;++$i){
       if(exists $rec_depth{"$chr\t$i"}){
           next if @{$rec_depth{"$chr\t$i"}} == 0;
           &cal($stt,$end,$strand,$i, $rank,  @{$rec_depth{"$chr\t$i"}});
       }
    }
    ++$flag;
}
close COOR;

open OUT, "+>$out" or die "$!";
print "Start printing results\n";
foreach my $tem_key(sort keys %rec_bin_dep){
    my $len = $len_body/$BIN;
    if($tem_key =~ /prom/){
        $len = $len_up/20;
    }elsif($tem_key =~ /term/){
        $len = $len_down/20;
    }
    my @norm_dep;
    my @dep;
    my $num = @sam_id;
    for(my $i = 0; $i < @sam_id; ++$i){
        $norm_dep[$i] = $rec_bin_dep{$tem_key}->{$i} * 1000000000/$len/$rec_tot_depth{$i};
        $dep[$i] = $rec_bin_dep{$tem_key}->{$i};
    }
    my $norm_dep = join("\t", @norm_dep);
    $tem_key =~ s/prom/-1/;
    $tem_key =~ s/body/0/;
    $tem_key =~ s/term/1/;
    print "$tem_key\t", join("\t", @dep), "\n";
    print OUT "$tem_key\t$norm_dep\n";
}
close OUT;

my @values = values %rec_tot_depth;
print <<REPORT;
Total reads:
@sam_id
@values
Total Length:
$len_up\t$len_body\t$len_down
REPORT

sub cal{
    my ($stt,$end,$strand,$pos1, $rank, @rec_depth) = @_;
    my $unit=($end-$stt+1)/($BIN - 0.01);
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt+1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1+1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    for(my $i = 0; $i < @rec_depth; ++$i){
        $rec_bin_dep{"$keys\t$rank"} -> {$i} += $rec_depth[$i];
    }
    #$rec_bin_site{$keys} -> {$i} ++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <coor> <depth> <out>
    This is to get the read depth distribution throughth specific regions
DIE
}
