#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($rabase,$gff)=@ARGV;
open MIPS,$rabase or die "$!";
my %id_rebase;my %id_rebase_gt5;
while(<MIPS>){
    chomp;
    next if !/^>/;
    my ($id,$name)=(split(/\|/,$_))[-2,-1];
    my @id=split(/\./,$id);
    if(@id>4){
        $id_rebase_gt5{$id}=$name;
    }else{
        $id_rebase{$id}=$name;
    }
}
foreach(keys %id_rebase_gt5){
    my @id=split(/\./,$_);
    my $id=join('.',($id[0],$id[1],$id[2],$id[3]));
    if(!(exists $id_rebase{$id})){
        $id_rebase{$_}=$id_rebase_gt5{$_};
    }
}

open GFF,$gff or die "$!";
my %mips_nu;my %mips_len;
while(<GFF>){
    chomp;
    next if /^#/;
    my ($chr,$stt,$end,$strand,$id)=(split(/\s+/,$_))[0,3,4,6,8];
    ($id)=$id=~/class=(.+)\;type/;
    my @id=split(/\./,$id);
    if(exists $id_rebase{$id}){
        
    }elsif(@id>4){
        $id=join('.',($id[0],$id[1],$id[2],$id[3]));
    }
    print "$id\n" if !exists $id_rebase{$id};
    $mips_nu{$id_rebase{$id}}++;
    $mips_len{$id_rebase{$id}}+=$end-$stt+1;
}

foreach(keys %mips_nu){
    my $len=$mips_len{$_}/$mips_nu{$_};
    print "$_\t$mips_nu{$_}\t$len\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Rabase> <MIPS GFF>
DIE
}
