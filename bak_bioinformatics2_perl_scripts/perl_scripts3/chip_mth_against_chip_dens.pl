#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==7;
my ($tissue,$forw,$rev,$chip_db,$chip_tab,$pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
   ($driver,$dsn,$usr,$pswd)=("mysql","database=$chip_db","root","123456");
my $chip_dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,$pos or die "$!";
my %meth_forw;my %meth_forw_nu;my $flag=0;
my %dens_chip;my %dens_len;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$gene,$strand)=(split(/\t/,$line));
    $chr="chr".$chr;
    my %hash;my %hash_chip;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $hash{"$chr\t$pos1"}=$lev;
        }
    }
    my $line=$chip_dbh->prepare(qq(select * from $chip_tab where chrom="$chr" and pos>=$stt-1999 and pos<=$end+1999));
       $line->execute();
    my ($chrom,$pos,$depth)=(0,0,0);
       $line->bind_columns(\$chrom,\$pos,\$depth);
    while($line->fetch()){
       $hash_chip{"$chr\t$pos"}=$depth;
    }

    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"});
        }
        if(exists $hash_chip{"$chr\t$i"}){
            &chip($stt,$end,$strand,$i,$hash_chip{"$chr\t$i"});
        }
    }
    $dens_len{"body"} += $end-$stt+1;
    %hash=();%hash_chip=();
}

foreach(sort keys %meth_forw){
    open R,"+>$forw.R";
    my $meth=join(',',@{$meth_forw{$_}});
    my $exp=join(',',@{$dens_chip{$_}});
    print R "meth<-c\($meth\)\nexp<-c($exp)\ncor.test(meth,exp,method='spearman')";
    my $report=`R --vanilla --slave <$forw.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$correla\t$p_value\n";
}
close OUT;
system qq(sort -k1,1n -k2,2n $out >$out.res);

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    push @{$meth_forw{$keys}},$methlev;
#    $meth_forw_nu{$keys}++;
}

sub chip{
    my ($stt,$end,$strand,$pos1,$depth)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    push @{$dens_chip{$keys}},$depth;
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <chip_seq> <h3k36_shoot> <Genes> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
