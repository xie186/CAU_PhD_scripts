#!usr/bin/perl -w
use strict;
use Text::NSP::Measures::2D::Fisher::twotailed;
die usage() unless @ARGV == 12;

my ($control1,$control2,$control3,$control4,$control5,$control6,@mutant) = @ARGV;
my @control = ($control1,$control2,$control3,$control4,$control5,$control6);
my %hash_site;
foreach my $control (@control){
    open CON,"zcat $control|" or die "$!";
    while(<CON>){
       chomp;
       my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
       next if ($number < 4 || $number >=100);
       my $numberC = ($number * $level)/100;
       $numberC = int($numberC+0.5);
       my $numberT = $number - $numberC;
       push @{$hash_site{"$chr\t$stt"}} ,($numberC, $numberT);
    }
}
foreach my $mutant (@mutant){
    open MUTANT,"zcat $mutant|" or die "$!";
    while(<MUTANT>){
        chomp;
        my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
        next if ($number < 4 || $number >=100);
        my $numberC = ($number * $level)/100;
        $numberC = int($numberC+0.5);
        my $numberT = $number - $numberC; 
        push @{$hash_site{"$chr\t$stt"}} , ($numberC, $numberT);
    }
}

foreach(keys %hash_site){
    chomp;
    next if @{$hash_site{$_}} !=4;
    my ($c_nu_control,$t_nu_control,$c_nu_mutant,$t_nu_mutant) =  @{$hash_site{$_}};
    my $npp = $c_nu_control+$t_nu_control+$c_nu_mutant+$t_nu_mutant;
    my $np1 = $c_nu_control + $c_nu_mutant;
    my $n1p = $c_nu_control + $t_nu_control;
    my $n11 = $c_nu_control;
    my $p_value = calculateStatistic( n11=>$n11,
                                      n1p=>$n1p,
                                      np1=>$np1,
                                      npp=>$npp);
    print "$_\t$c_nu_control\t$t_nu_control\t$c_nu_mutant\t$t_nu_mutant\t$p_value\n";    
}

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <Control> <Mutant>
DIE
} 
