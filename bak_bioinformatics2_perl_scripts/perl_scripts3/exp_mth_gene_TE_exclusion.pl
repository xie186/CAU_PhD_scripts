#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==6;
my ($tissue,$forw,$rev,$pos,$te_spec,$out)=@ARGV;
my $dbh_te=DBI->connect("dbi:mysql:database=TE","root","123456") or die "$DBI::errstr\n";

my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:mysql:database=$tissue",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,$pos or die "$!";
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%500==0;$flag++;
    chomp $line;
    next if $line !~ /^\d/;
    my ($chr,$stt,$end,$gene,$strand)=(split(/\t/,$line));

    my %hash_exclu;
    my $row_te=$dbh_te->prepare(qq(select * from $te_spec where \(chrom="$chr" and pos1<=$end+2000 and pos1>$stt-2000\) or \(chrom="$chr" and pos1<=$stt-2000 and pos2>=$stt-2000\)));
       $row_te -> execute();
    my ($chrom,$tem_stt,$tem_end,$tem_strd,$type,$sub_type)=(0,0,0,0,0,0);
       $row_te -> bind_columns(\$chrom,\$tem_stt,\$tem_end,\$tem_strd,\$type,\$sub_type);
    my $i=0;
    while($row_te->fetch()){
        for(my $i = $tem_stt; $i<= $tem_end;++$i){
            $hash_exclu{"chr$chr\t$i"} ++;
        }
    }

    $chr="chr".$chr;
    my %hash;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           next if exists $hash_exclu{"$chr\t$pos1"};
           $hash{"$chr\t$pos1"}=$lev;
        }
    }
    foreach(keys %hash){
        my ($pos1) = (split(/\t/,$_))[1];
        &cal($stt,$end,$strand,$pos1,$hash{$_});
    }
}

foreach(sort keys %meth_forw){
    my $meth_forwprint=$meth_forw{$_}/$meth_forw_nu{$_};
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_forwprint\n";
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
    $meth_forw{$keys}+=$methlev;
    $meth_forw_nu{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <Genes> <TE table[TE_pos][TE_ara][TE_rice]> <OUTPUT>
    This is to get the methylation distribution throughth gene without TE
DIE
}
