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
    open OUT,"+>pDMR_$chr\_$stt\_$end\_mth.res" or die "$!";
    foreach my $contxt($cpg_ot,$cpg_ob){
        my $row=$dbh->prepare(qq(select * from $contxt where chrom="$chr" and pos1>=$stt-2000 and pos1<=$end+2000));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
             print OUT "$chrom\t$pos1\t$pos2\t$depth\t$lev\n";
        }
    }
    my $tem="tem.R";
    open TEM,"+>$tem" or die "$!";
    print TEM <<R;
pdf("pDMR_$chr\_$stt\_$end\_mth.pdf")
source("draw_test.R")
draw_pDMR("pDMR_$chr\_$stt\_$end\_mth.pdf")
dev.off()
R
    system("R --vanilla --slave <tem.R")
     
}

sub usage{
    my $die=<<DIE;
    perl *.pl <pDMR> <Tissue> <CpG_OT> <CpG_OB>
DIE
}
