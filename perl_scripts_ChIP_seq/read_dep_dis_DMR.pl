#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($coor, $depth, $out) = @ARGV;

my $FLANK = 4999;
my $BIN_LEN = 50;
my $BIN_NUM = ($FLANK + 1)/$BIN_LEN;

print "Start record site need to see ", `date`;
my %rec_depth;
open COOR,$coor or die "$!";
while(<COOR>){
    chomp;
    my ($chr, $stt, $end, $id, $strand) = split;
    $chr =~ s/chr//;
    for(my $i = $stt - 5999;$i < $end+5999;++$i){
        @{$rec_depth{"$chr\t$i"}} = ();
    }
}
close COOR;

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
    $chr =~ s/chr//;
    @{$rec_depth{"$chr\t$pos"}} = @depth if exists $rec_depth{"$chr\t$pos"};
    for(my $i = 0; $i < @depth; ++$i){
        $rec_tot_depth{$i} += $depth[$i];
    }
    ++$flag1;
}
close DEP;

print "Start processing distribution ", `date`;
my $flag = 1;
my ($len_tot) = (0);
my %rec_bin_dep;
open COOR,$coor or die "$!";
while(<COOR>){
    chomp;
    print "$flag have processed\n" if $flag % 500 == 0;
    my ($chr, $stt, $end, $id, $strand) = split;
    $chr =~ s/chr//;
    $len_tot += $FLANK;
    my $mid = int (($stt+$end)/2);
    for(my $i = $mid - $FLANK;$i < $mid+$FLANK;++$i){
       if(exists $rec_depth{"$chr\t$i"}){
           next if @{$rec_depth{"$chr\t$i"}} == 0;
           &cal($mid,$strand,$i, @{$rec_depth{"$chr\t$i"}});
       }
    }
    ++$flag;
}
close COOR;

my $bin_len_tot = $len_tot/$BIN_NUM;
open OUT, "+>$out" or die "$!";
print "Start printing results\n";
foreach my $tem_key(sort keys %rec_bin_dep){
    my @norm_dep;
    my @dep;
    my $num = @sam_id;
    for(my $i = 0; $i < @sam_id; ++$i){
        $norm_dep[$i] = $rec_bin_dep{$tem_key}->{$i} * 1000000000/$bin_len_tot/$rec_tot_depth{$i};
        $dep[$i] = $rec_bin_dep{$tem_key}->{$i};
    }
    my $norm_dep = join("\t", @norm_dep);
    $tem_key =~ s/prom/-1/;
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
$len_tot
REPORT

sub cal{
    my ($mid,$strand,$pos1,@rec_depth) = @_;
    my $keys=0;
        if($pos1<$mid){
            $keys=int(($pos1-$mid)/$BIN_LEN);
            $keys="prom\t$keys";
        }else{
            $keys=int(($pos1-$mid)/$BIN_LEN);
            $keys="term\t$keys";
        }
    for(my $i = 0; $i < @rec_depth; ++$i){
        $rec_bin_dep{$keys} -> {$i} += $rec_depth[$i];
    }
    #$rec_bin_site{$keys} -> {$i} ++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <coor> <depth> <out>
    This is to get the read depth distribution throughth specific regions
DIE
}
