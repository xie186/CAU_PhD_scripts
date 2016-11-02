#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==4;
my ($p_dmr,$tis,$cpg_ot,$cpg_ob)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tis","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open DMR,$p_dmr or die "$!";
while(my $line=<DMR>){
    chomp $line;
    my ($chr,$stt,$end)=split(/\t/,$line);
    
    my ($meth_up,$meth_up_nu) = (0, 0);
    foreach my $contxt($cpg_ot,$cpg_ob){
        my $row=$dbh->prepare(qq(select * from $contxt where chrom="$chr" and pos1>=$stt-2000 and pos1<=$stt));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
             $meth_up+=$lev;
             ++ $meth_up_nu;
        }
    }

    my ($meth_down, $meth_down_nu) = (0, 0);
    foreach my $contxt($cpg_ot,$cpg_ob){
        my $row=$dbh->prepare(qq(select * from $contxt where chrom="$chr" and pos1>=$end and pos1<=$end+2000));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
             $meth_down+=$lev;
             ++ $meth_down_nu;
        }
    }
    print "$chr\t$stt\t$end\n" if $meth_up/$meth_up_nu >=80 and $meth_down/$meth_down_nu >= 80;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <pDMR> <Tissue> <CpG_OT> <CpG_OB>
DIE
}
