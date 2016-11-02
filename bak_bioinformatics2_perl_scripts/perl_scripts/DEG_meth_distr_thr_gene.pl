#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==8;
my ($forw,$rev,$ge_pos,$deg,$out,@tissues)=@ARGV;
my @dbh;
for(my $i=0;$i<@tissues;++$i){
     my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissues[$i]","root","123456");
     $dbh[$i]=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
}

open GEPOS,$ge_pos or die "$!";my %ge_pos;
while(<GEPOS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    $chr="chr".$chr;
    @{$ge_pos{$gene}}=($chr,$stt,$end,$gene,$strand);
}

open OUT,"+>$out" or die;
open POS,$deg or die;
my %meth_forw;my %meth_forw_nu;my $flag=1;
while(my $line=<POS>){
    print "$line";
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($gene)=split(/\t/,$line);
    my ($chr,$stt,$end,$name,$strand)=@{$ge_pos{$gene}};
    print "$chr,$stt,$end,$name,$strand\n";
    my %hash;
    for(my $i=0;$i<@dbh;++$i){
         foreach my $tab($forw,$rev){
         my $row=$dbh[$i]->prepare(qq(select * from $tab where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
            $row->execute();
         my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
            $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
            while($row->fetch()){
                $hash{"$chr\t$pos1"}=$lev;
            }
         }
        foreach(my $j=$stt-2000;$j<=$end+2000;++$j){
            if(exists $hash{"$chr\t$j"}){
                &cal($stt,$end,$strand,$j,$hash{"$chr\t$j"},$i);
            }
        }
        undef %hash;
    }
}

foreach(sort keys %meth_forw){
    my @meth;
    for(my $i=0;$i<@{$meth_forw{$_}};++$i){
        $meth[$i]=${$meth_forw{$_}}[$i]/${$meth_forw_nu{$_}}[$i];
    }
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    my $output=join("\t",@meth);
    print OUT "$_\t$output\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$i)=@_;
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
    ${$meth_forw{$keys}}[$i]+=$methlev;
    ${$meth_forw_nu{$keys}}[$i]++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Forword> <Reverse> <Gene position> <DEG> <OUTPUT> <Tissues INT>
    This is to get the methylation distribution through DEG gene in different tissues
DIE
}
