#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==9;
my ($tissue,$forw_CpG,$rev_CpG,$forw_CHG,$rev_CHG,$forw_CHH,$rev_CHH,$gff,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,$gff or die;
my %meth_forw;my %meth_forw_nu;my %element;my %flag;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%10000==0;$flag++;
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand,$gene,$rpkm,$rank)=(split(/\s+/,$line))[0,1,2,3,4,5,6,7];
    next if ($ele=~/gene/ ||$ele=~/CDS/);
    next if $end-$stt==0;
    $chr="chr".$chr;
    foreach($forw_CpG,$rev_CpG,$forw_CHG,$rev_CHG,$forw_CHH,$rev_CHH){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            &cal($ele,$stt,$end,$strand,$tem_pos1,$lev,$rank);
        }
    }
}

foreach(sort keys %flag){
    my $meth_rank1=$meth_forw{"$_\t1"}/$meth_forw_nu{"$_\t1"};
    my $meth_rank2=$meth_forw{"$_\t2"}/$meth_forw_nu{"$_\t2"};
    my $meth_rank3=$meth_forw{"$_\t3"}/$meth_forw_nu{"$_\t3"};
    my $meth_rank4=$meth_forw{"$_\t4"}/$meth_forw_nu{"$_\t4"};
    my $meth_rank5=$meth_forw{"$_\t5"}/$meth_forw_nu{"$_\t5"};
    print OUT "$_\t$meth_rank1\t$meth_rank2\t$meth_rank3\t$meth_rank4\t$meth_rank5\n";
}

close OUT;
sub cal{
    my ($ele,$stt,$end,$strand,$pos1,$methlev,$rank)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        $keys=int (($pos1-$stt)/$unit);
    }else{
        $keys=int (($end-$pos1)/$unit);
    }
    $meth_forw{"$ele\t$keys\t$rank"}+=$methlev;
    $meth_forw_nu{"$ele\t$keys\t$rank"}++;
    $flag{"$ele\t$keys"}++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword_CpG> <Reverse_CpG> <Forword_CHG> <Reverse_CHG> <Forword_CHH> <Reverse_CHH> <Gene postion with RANK> <OUTPUT>
    This is to get the methylation distribution througth genes for different ranks of gene for three C contexts.
DIE
}
