#!/usr/bin/perl -w
use strict;

die "\n",usage(),"\n" if @ARGV==0;
foreach(@ARGV){
    system qq(nohup perl ~/zeamxie/perl_scripts/LengthSort.pl -l 28 $_ >$_.LengthSort.nohup 2>&1 &);
}
print "Done\n";
sub usage{
    my $die=<<DIE;
    perl *.pl <Reads_trimmed>
DIE
}
