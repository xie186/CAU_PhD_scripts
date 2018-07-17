#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($dmr, $bed_file, $tis, $out) = @ARGV;
sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <DMR> <bedfile [A(OT|OB),B(OT|OB)]> <Tis [A,B]> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> <Level1> <Level2>

DIE
}

open OUT, "+>$out" or die "$!";
my @bed_file = split(/,/, $bed_file);
my $bed_num = @bed_file;
my %meth_alle1;
my %meth_dmr;
foreach my $bed (@bed_file){
    $bed =~ s/:/ /g;
    print "$bed\n";
    if($bed=~/gz$/){
        open ALLE1,"zcat $bed|" or die "$!";
        print "zcat $bed|\n";
    }else{
        open ALLE1,"cat $bed|" or die "$!";
        print "cat $bed|\n";
    }
    while(<ALLE1>){
        chomp;
        my ($chr,$pos1,$pos2,$depth,$lev)=split;
        next if $depth < 4;
        @{$meth_alle1{"$chr\t$pos1"}}=($depth,$lev);
    }
    close ALLE1;

    open DMR,$dmr or die "$!";
    while(<DMR>){
        chomp;
        my ($chr,$stt,$end) = split;
        my ($c_cover_alle,$c_nu_alle,$t_nu_alle)=&get($chr,$stt,$end);
        next if $c_cover_alle * 100 / ($end - $stt +1) < 4;
        my $lev = $c_nu_alle / ($c_nu_alle + $t_nu_alle);
        push @{$meth_dmr{"$chr\t$stt\t$end"}}, $lev;
    }
    close DMR;
    %meth_alle1 = (); 
}

$tis =~ s/,/\t/g;
print OUT "\t$tis\n";
foreach(keys %meth_dmr){
    next if $bed_num != @{$meth_dmr{$_}} ;
    my $mul_lev = join("\t", @{$meth_dmr{$_}});
    $_ =~ s/\t/_/g;
    print OUT "$_\t$mul_lev\n";
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1)=(0,0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $meth_alle1{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle1{"$chrom\t$i"}});
            $c_nu_alle1 += $c_nu;
            $t_nu_alle1 += $t_nu;
            ++ $c_cover_alle1;
        }
    }
    return ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1);
}

sub cal_CT{
    my ($depth,$lev) = @_;
    my ($c_nu,$t_nu) = (int($depth*$lev/100+0.5) , $depth - (int($depth*$lev/100+0.5)));
    return ($c_nu, $t_nu);
}
