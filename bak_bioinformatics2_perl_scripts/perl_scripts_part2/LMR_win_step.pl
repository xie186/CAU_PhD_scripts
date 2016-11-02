#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==9;
my ($geno_len,$cpg_ot,$cpg_ob,$chg_ot,$chg_ob,$tissue1,$win,$step,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue1","root","123456");
my $dbh1=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    next if ($chr eq "chr11" || $chr eq "chr12" || $chr eq "chr0");
    $hash{$chr}=$len;
}

open OUT,"+>$out" or die "$!";
foreach my $chrom(keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1,($i-1)*$step+$win);
        my ($c_nu, $meth1, $unmeth1)=&get($chrom,$stt,$end,$dbh1);
        print OUT "$chrom\t$stt\t$end\t\t$c_nu\t$meth1\t$unmeth1\n";
        ##print "$chrom\t$stt\t$end\t\t$c_nu\t$meth1\t$unmeth1\n"; 
    }
}

sub get{
    my ($chrom,$stt,$end,$dbh)=@_;
    my ($meth,$unmeth, $c_nu)=(0,0,0);
    foreach ($cpg_ot,$cpg_ob,$chg_ot,$chg_ob){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chrom" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrm,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrm,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $c_nu++;
           $meth   += (int ($depth*$lev+0.5))/100;
           $unmeth += $depth-(int ($depth*$lev+0.5))/100;
        }
    }
    return ($c_nu, $meth, $unmeth);
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Geno_len> <CpG_OT> <CpG_OB> <CHG_OT> <CHG_OB> <Tissue1> <Windows size > <Step size> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> <# of Cs covered> <C_nu> <T_nu> <methlev>
DIE
}
