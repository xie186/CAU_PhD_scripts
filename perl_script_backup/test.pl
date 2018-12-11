#!/usr/bin/perl -w

use Tie::File::AsHash;

tie %hash, 'Tie::File::AsHash', 'test', split => ':' or die "Problem tying %hash: $!";

foreach(keys %hash){
    print "$_\t$hash{$_}\n";
}
