#!/usr/bin/perl -w
use strict;use DBI;
my ($gff,$tissue,$cg_forw,$cg_rev,$chg_forw,$chg_rev,$chh_forw,$chh_rev)=@ARGV;
die usage() unless @ARGV==8;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open GFF,$gff or die "$!";
my %cov_nu;my %meth_nu;
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end)=(split)[0,2,3,4];
    next if ($ele eq "chromosome" || $ele eq "gene" || $ele eq "CDS");
    $chr="chr".$chr;
    foreach my $meth($cg_forw,$cg_rev){
        my $row=$dbh->prepare(qq(SELECT * FROM $meth WHERE chrom="$chr" AND pos1>=$stt AND pos1<=$end));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           ${$meth_nu{"$ele"}}[0]++ if $lev>=80;
           ${$cov_nu{"$ele"}}[0]++;
        }
    }

    foreach my $meth($chg_forw,$chg_rev){
        my $row=$dbh->prepare(qq(SELECT * FROM $meth WHERE chrom="$chr" AND pos1>=$stt AND pos1<=$end));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           ${$meth_nu{"$ele"}}[1]++ if $lev>=80;
           ${$cov_nu{"$ele"}}[1]++;
        }
    }
  
    foreach my $meth($chh_forw,$chh_rev){
        my $row=$dbh->prepare(qq(SELECT * FROM $meth WHERE chrom="$chr" AND pos1>=$stt AND pos1<=$end));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           ${$meth_nu{"$ele"}}[2]++ if $lev>=15;
           ${$cov_nu{"$ele"}}[2]++;
        }
    }
    
}
foreach(sort keys %cov_nu ){
    my $cg_ratio=${$meth_nu{$_}}[0]/${$cov_nu{$_}}[0];
    my $chg_ratio=${$meth_nu{$_}}[1]/${$cov_nu{$_}}[1];
    my $chh_ratio=${$meth_nu{$_}}[0]/${$cov_nu{$_}}[2];
    print "$_\t$cg_ratio\t$chg_ratio\t$chh_ratio\n";
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <GFF> <Tissue> <CG_OT> <CG_OB> <CHG_OT> <CHG_OB> <CHH_OT> <CHH_OB> 
DIE
}
