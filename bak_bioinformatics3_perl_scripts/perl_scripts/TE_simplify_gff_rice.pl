#!/usr/bin/perl -w
use strict;
my ($rebase,$gff)=@ARGV;
die usage() unless @ARGV==2;
open MIPS,$rebase or die "$!";
my %id_rebase;my %id_rebase_gt5;my %real_id;
while(<MIPS>){
    chomp;
    next if !/^>/;
    my ($id,$name)=(split(/\|/,$_))[-2,-1];
    $real_id{$id}=$name;
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
    next if (/^#/ || /^UNKNOWN/ || /^chloroplas/ || /^mito/);
    my ($chr,$stt,$end,$strand,$id)=(split(/\t/,$_))[0,3,4,6,8];
    ($chr)=split(/\|/,$chr);
    $chr=~s/chr0/chr/;
    ($id)=split(/\s+/,$id);
    my @aa=split(/\|/,$id);
    next if @aa!=4;
    ($id)=$aa[2];
    my $re_id=$id;
    my @id=split(/\./,$id);
    if(exists $id_rebase{$id}){    #some ID of TEs have less than 3 numbers 
               
    }elsif(@id>4){
        $id=join('.',($id[0],$id[1],$id[2],$id[3]));       
    }
    print "xx:$chr\t$stt\t$end\t$strand\t$id_rebase{$id}\t$real_id{$re_id}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Rebase> <MIPS GFF>  
DIE
}
