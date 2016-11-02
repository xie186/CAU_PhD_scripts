#!/usr/bin/perl -w
use strict;
my ($rebase,$gff,$class1,$class2)=@ARGV;
die usage() unless @ARGV==4;
open MIPS,$rebase or die "$!";
my %id_rebase;my %id_rebase_gt5;my %real_id;
while(<MIPS>){
    chomp;
    next if !/^>/;
    my ($id,$name)=(split(/\|/,$_))[-2,-1];
    next if $id!~/^02/;
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
my %mips_class;
open CLASSI,"+>$class1" or die "$!";
open CLASSII,"+>$class2" or die "$!";
while(<GFF>){
    chomp;
    next if (/^#/ || /^UNKNOWN/ || /^chloroplas/ || /^mito/);
    my ($chr,$stt,$end,$strand,$id)=(split(/\s+/,$_))[0,3,4,6,8];
    ($id)=$id=~/class=(.+)\;type/;
    next if $id!~/^02./;
    my $re_id=$id;
    my @id=split(/\./,$id);

    if(@id>4){   #some ID of TEs have less than 3 numbers
        $id=join('.',($id[0],$id[1],$id[2],$id[3]));
    }
    if(exists $id_rebase{$id}){
        if($id=~/^02\.01/){
            print CLASSI "$id\t$id_rebase{$id}\n";
            print "$chr\t$stt\t$end\t$strand\t$id_rebase{$id}\t$real_id{$re_id}\tretro\n";
        }else{
            print CLASSII "$id\t$id_rebase{$id}\n";
            print "$chr\t$stt\t$end\t$strand\t$id_rebase{$id}\t$real_id{$re_id}\tnot_retro\n";
        }
    }else{
        if($id=~/^02\.01/){
            print CLASSI "$re_id\t$id_rebase{$re_id}\n";
            print "$chr\t$stt\t$end\t$strand\t$id_rebase{$re_id}\t$real_id{$re_id}\tretro\n";
        }else{
            print CLASSII "$re_id\t$id_rebase{$re_id}\n";
            print "$chr\t$stt\t$end\t$strand\t$id_rebase{$re_id}\t$real_id{$re_id}\tretro\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Rebase> <MIPS GFF> <Class I> <Class II>  >>OUT
DIE
}
