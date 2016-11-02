#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==4;
my ($db,$chip_tab,$pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$db","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,"grep 'NT' $pos |" or die "$!";
my %chip_depth;my %chip_nu;my $flag=1;
my $nu=0;
my ($bin_two_side,$bin_gene_body)=(0,0);
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    ++$nu;
    my ($chr,$stt,$end,$gene,$strand,$cpg_oe)=(split(/\t/,$line))[0,1,2,3,4,11];
    my $cpg_lh = "LC";
       $cpg_lh = "HC" if $cpg_oe >= 0.8;
    $chr="chr".$chr;
    my %hash;
    my $row=$dbh->prepare(qq(select * from $chip_tab where chrom="$chr" and pos>=$stt-1999 and pos<=$end+1999));
       $row->execute();
    my ($chrom,$pos,$depth)=(0,0,0);
       $row->bind_columns(\$chrom,\$pos,\$depth);
    while($row->fetch()){
       $hash{"$chr\t$pos"}=$depth;
    }
    $bin_two_side  += 200;
    $bin_gene_body += ($end-$stt+1)/20;
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"},$cpg_lh);
        }
    }
    %hash=();
}

foreach(sort keys %chip_depth){
    my $tem_dep=0;
    if(/prom/ || /term/){
        $tem_dep = ($chip_depth{$_}/$bin_two_side);
#        $tem_dep = 20*($chip_depth{$_}/$nu);
    }else{
        $tem_dep = $chip_depth{$_}/$bin_gene_body;
#        $tem_dep = 20*$chip_depth{$_}/$nu;
    }
    $_ =~ s/prom/-1/;
    $_ =~ s/body/0/;
    $_ =~ s/term/1/;
    print OUT "$_\t$tem_dep\n";
}
close OUT;
system qq(sort -k1,1n -k2,2n $out >$out.srt);

sub cal{
    my ($stt,$end,$strand,$pos1,$chip_dep,$cpg_lh)=@_;
    my $unit=($end-$stt+1)/20;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/200);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end)/200);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/200);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/200);
            $keys="prom\t$keys";
        }
    }
    $keys=$keys."\t$cpg_lh";
    $chip_depth{$keys}+=$chip_dep;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> [<h3k27> <h3k36> <h3k4> <h3k9>] <Genes> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
