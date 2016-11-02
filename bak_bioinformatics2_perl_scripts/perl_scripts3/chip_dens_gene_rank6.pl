#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==4;
my ($chip_db,$chip_tab,$pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$chip_db","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,$pos or die;
my %chip_depth;my %chip_len;my %flag;my $flag=1;
my $bin_two_side=0;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    next if $line =~/^#/;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand,$type,$clas,$rpkm,$rank)=split(/\s+/,$line);
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
    $chip_len{$rank} += ($end-$stt+1)/20;
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"},$rank);
        }
    }
    %hash=();
}

foreach(sort keys %flag){
    my ($region)=(split(/\t/,$flag))[1];
    my ($rank0,$rank1,$rank2,$rank3,$rank4,$rank5)=(0,0,0,0,0,0);
    if($region == -1 || $region == 1){
        $rank0=$chip_depth{"$_\t0"}/$bin_two_side;
        $rank1=$chip_depth{"$_\t1"}/$bin_two_side;
        $rank2=$chip_depth{"$_\t2"}/$bin_two_side;
        $rank3=$chip_depth{"$_\t3"}/$bin_two_side;
        $rank4=$chip_depth{"$_\t4"}/$bin_two_side;
        $rank5=$chip_depth{"$_\t5"}/$bin_two_side;
    }else{
        $rank0=$chip_depth{"$_\t0"}/$chip_len{"0"};
        $rank1=$chip_depth{"$_\t1"}/$chip_len{"1"};
        $rank2=$chip_depth{"$_\t2"}/$chip_len{"2"};
        $rank3=$chip_depth{"$_\t3"}/$chip_len{"3"};
        $rank4=$chip_depth{"$_\t4"}/$chip_len{"4"};
        $rank5=$chip_depth{"$_\t5"}/$chip_len{"5"};
    }
    print OUT "$_\t$rank0\t$rank1\t$rank2\t$rank3\t$rank4\t$rank5\n";
}

system qq(sort -k2,2n -k1,1n $out > $out.res);

close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$depth,$rank)=@_;
    my $unit=($end-$stt+1)/20;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/200);
            $keys.="\t-1";                     # -1,0 and 1 represented promoter,gene body and 3'terminal respectively.
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys.="\t0";
        }else{
            $keys=int(($pos1-$end)/200);
            $keys.="\t1";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/200);
            $keys.="\t1";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys.="\t0";
        }else{
            $keys=int(($end-$pos1)/200);
            $keys.="\t-1";
        }
    }
    $chip_depth{"$keys\t$rank"}+=$depth;
#    $meth_forw_nu{"$keys\t$rank"}++;
    $flag{$keys}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CHIP database> <CHIP table> <Gene postion with RANK> <OUTPUT>
    This is to get the chip_seq throughth gene for different rank of gene.
DIE
}
