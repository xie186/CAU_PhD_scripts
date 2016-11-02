#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV == 5;
my ($gff,$tis,$forw,$rev,$out) = @ARGV;

my $dbh=DBI->connect("dbi:mysql:database=$tis","root","123456") or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$gff or die;
my %hash_print;
while(<POS>){
    chomp; 
    my ($chr,$stt,$end,$ele,$strand,$intron_nu,$te_or) = split(/\t/,$_);
    if($te_or eq '.'){
        $te_or = "NT";
    }else{
        $te_or = "TE";
    }
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
             next if exists $hash_print{"$chrom\t$tem_pos1"};
#            &cal($stt,$end,$strand,$tem_pos1,$lev,$ele);
             print OUT "$chrom\t$tem_pos1\t$tem_pos2\t$depth\t$lev\t$te_or\n";
             $hash_print{"$chrom\t$tem_pos1"} ++;
        }
    }
}

sub usage{
    print <<DIE;
    perl *.pl <BED file> <tissue> <OT> <OB> <out> 
DIE
    exit 1;
}
