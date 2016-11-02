#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==6;
my ($geno_len,$chrom,$tissue,$forw,$rev,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn","$usr","$pswd");

open GENO,$geno_len or die "$!";
my %hash1;
while(<GENO>){
    chomp;
    my ($chr,$len)=split(/\s+/);
    $hash1{$chr}=$len;
}

my $num=int $hash1{$chrom}/100000;
open OUT,"+>$out" or die "$!";
for(my $i=0;$i<=$num;++$i){
     my ($methy_forw,$forw_nu,$methy_rev,$rev_nu,$forw_meth_nu,$rev_meth_nu)=(0,0,0,0,0,0);
     
        my %methy;
        my $row=$dbh->prepare(qq(select * from $forw where chrom="$chrom" and pos1>=$i*100000 and pos1<=$i*100000+100000));
           $row->execute();
        my ($chr,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chr,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
            $methy{"$pos1.forw"}=$lev;
        }
           $row=$dbh->prepare(qq(select * from $rev where chrom="$chrom" and pos1>=$i*100000 and pos1<=$i*100000+100000));
           $row->execute();
           $row->bind_columns(\$chr,\$pos1,\$pos2,\$depth,\$lev);
         while($row->fetch()){
            $methy{"$pos1.rev"}=$lev;
        }
        
     for(my $j=$i*100000;$j<=$i*100000+100000;++$j){
        if(exists $methy{"$j.forw"}){
             $methy_forw+=$methy{"$j.forw"};
             $forw_meth_nu++ if $methy{"$j.forw"}>=0.8;
             $forw_nu++;
        }
        if(exists $methy{"$j.rev"}){
             $methy_rev+=$methy{"$j.rev"};
             $rev_meth_nu++ if $methy{"$j.rev"}>=0.8;
             $rev_nu++;
        }
    }
    my $win_stt=$i*100000;
    my ($lev_forw,$lev_rev,$meth_forw,$meth_rev)=(0,0,0,0);

    $lev_forw=$methy_forw/($forw_nu+0.000001);
    $lev_rev =$methy_rev/($rev_nu+0.000001);

    $meth_forw=$forw_meth_nu/($forw_nu+0.000001);
    $meth_rev =$rev_meth_nu/($rev_nu+0.000001);

    print OUT "$chr\t$win_stt\t$lev_forw\t$lev_rev\t$meth_forw\t$meth_rev\t$forw_meth_nu\t$rev_meth_nu\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Geno length> <Chrom> <Tissue> <Forwards_methy> <Reverse_methy> <OUT>
    <windows> <Forward meth_lev> <Reverse meth_lev> <Forward meth proportion> <Reverse Proportion>
DIE
}
