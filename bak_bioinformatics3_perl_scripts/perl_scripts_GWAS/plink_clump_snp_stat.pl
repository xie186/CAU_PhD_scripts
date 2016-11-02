#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($dir) = @ARGV;

my @file = <$dir/*clumped>;
foreach my $file (@file){
    open FILE,$file or die "$!";
#    print "$file\n";
    my $out = $file;
       $out =~ s/clumped/region/g;
    open OUT, "+>$out" or die "$!";
    while(my $line = <FILE>){
         chomp $line;
         next if ($line =~ /CHR/ || $line !~ /chr/);
         #CHR    F               SNP         BP        P    TOTAL   NSIG    S05    S01   S001  S0001    SP2 
         my ($dot,$chr, $f,$snp,$pos, $p, $tot,$nSIG,$s05,$s01,$s001,$s0001,$sp2) = split(/\s+/,$line);
#         print "$chr, $f,$snp,$pos, $p, $tot,$nSIG,$s05,$s01,$s001,$s0001,$sp2\n";
         if($sp2 eq "NONE"){
             print OUT "$chr\t$pos\t$snp\tNA\tNA\tNA\n";
         }else{
             my @snp = split(/,/, $sp2);
             my @pos;
             for(my $i =0; $i < @snp; ++$i){
                my ($tem_chr,$tem_pos)  = $snp[$i] =~ /(chr\d+)_(\d+)\(/;
                push @pos, $tem_pos;
             }
             @pos = sort{$a<=>$b} @pos;
             my $len = $pos[-1] - $pos[0] + 1;
             print OUT "$chr\t$pos\t$snp\t$pos[0]\t$pos[-1]\t$len\n";
         }
    }
    close OUT;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <File> 
DIE
}
