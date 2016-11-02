#!usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
open SAMESITE,$ARGV[0] or die;
open FISH,"+>$ARGV[1]" or die;
#<SAMESITE>;
print FISH "chromosome\tposition\tB73numberC\tB73numberT\tMo17numberC\tMo17numberT\tfishertest\n";
while(<SAMESITE>){
   my ($chr,$position,$B73numberC,$B73numberT,$Mo17numberC,$Mo17numberT) = split;
   my $fish = &fish($B73numberC,$Mo17numberC,$B73numberT,$Mo17numberT);
   print FISH "$chr\t$position\t$B73numberC\t$B73numberT\t$Mo17numberC\t$Mo17numberT\t$fish\n";
}

sub fish{
   my ($numberC1,$numberC2,$numberT1,$numberT2) = @_;
   open FISHTEST,"+>$ARGV[2]" or die;
   print FISHTEST "asm<-c($numberC1,$numberC2,$numberT1,$numberT2)\ndim(asm)<-c(2,2)\nfisher.test(asm)\$p";
   my $p_value = `R --vanilla --slave <$ARGV[2]`;
   $p_value = (split /\s/,$p_value)[1];
   return $p_value;
} 

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <SAMESITE> <FISH> <FISHTEST>
DIE
}   

