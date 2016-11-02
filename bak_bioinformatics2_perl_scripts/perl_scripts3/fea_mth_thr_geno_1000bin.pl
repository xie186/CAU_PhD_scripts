#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==5;
my ($geno_len,$tissue,$forw,$rev,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn","$usr","$pswd");

open GENO,$geno_len or die "$!";
my %hash1;
while(<GENO>){
    chomp;
    my ($chr,$len)=split(/\s+/);
    $hash1{$chr}=$len;
}

open OUT,"+>$out" or die "$!";
for(my $j = 1;$j <= keys %hash1;++ $j){
        my $chr_tem = "chr".$j;
        my $aver=int $hash1{$chr_tem}/1000;
        my @mth_info;
        for(my $i=1;$i<=1000;++$i){
            my ($stt,$end)=(($i-1)*$aver,$i*$aver);
            my ($meth_lev,$meth_nu)=(0,0);
            my $row=$dbh->prepare(qq(select * from $forw where chrom="$chr_tem" and pos1>=$stt and pos1<=$end));
               $row->execute();
           my ($chr,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
              $row->bind_columns(\$chr,\$pos1,\$pos2,\$depth,\$lev);
            while($row->fetch()){
               $meth_lev+=$lev;
               ++$meth_nu;
            }
              $row=$dbh->prepare(qq(select * from $rev where chrom="$chr_tem" and pos1>=$stt and pos1<=$end));
              $row->execute();
              $row->bind_columns(\$chr,\$pos1,\$pos2,\$depth,\$lev);
            while($row->fetch()){
              $meth_lev+=$lev;
              ++$meth_nu;
            }
            my $aver_mth = $meth_lev/($meth_nu+0.0000001);
#            print "$chr_tem\t$stt\t$end\t$meth_lev\t$meth_nu\t$aver_mth\n";
            push @mth_info,$aver_mth;
#            print OUT "$chr_tem\t$stt\t$end\t$meth_lev\t$meth_nu\t$aver_mth\n";
         }
         for(my $i=1;$i<=1000;++$i){
             my ($tol_lev,$tol_nu)=(0,0);
             for(my $h=-5;$h<=5;++$h){
                 my $pos = $i + $h;
                 next if($pos-1<0 || $pos -1 > 1000);
                 $tol_lev+=$mth_info[$pos];
                 ++$tol_nu;
             }
             my $aver_mth=$tol_lev/$tol_nu;
             print OUT "$i\t$aver_mth\n";
         }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Geno length> <Tissue> <Forwards_methy> <Reverse_methy> <OUT>
    <Chr> <Stt> <End> <Total level> <Total number> <Forward meth_lev>
DIE
}
