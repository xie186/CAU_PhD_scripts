#!/usr/bin/perl -w
use strict;

use Cwd;
my $dir = getcwd;

print "$dir\n";

my $fortress_dir = $dir;
$fortress_dir =~ s/\/scratch\/conte\/x/\/home\/xie186\/conte_acc_bak/g;

print "$fortress_dir\n";
`hsi "mkdir -p $fortress_dir; cd $fortress_dir;cput -R -U *"`

