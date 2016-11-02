#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==4;
my ($chip_db,$chip_tab,$gff,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$chip_db","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die;
open POS,$gff or die;
my %chip_dep;my %chip_len;my %element;my %flag;my $flag=1;
while(my $line=<POS>){    
    print "$flag have been done\n" if $flag%10000==0;$flag++;
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand,$gene,$rpkm,$rank)=(split(/\t/,$line))[0,1,2,3,4,5,6,7];
    next if ($ele=~/mRNA/ ||$ele=~/CDS/);
    next if $end-$stt==0;
    $chr="chr".$chr;
    my $row=$dbh->prepare(qq(select * from $chip_tab where chrom="$chr" and pos>=$stt and pos<=$end));
       $row->execute();
    my ($chrom,$tem_pos1,$depth)=(0,0,0);
       $row->bind_columns(\$chrom,\$tem_pos1,\$depth);
    $chip_len{"$ele\t$rank"} += ($end-$stt+1)/20;
    while($row->fetch()){
        &cal($ele,$stt,$end,$strand,$tem_pos1,$depth,$rank);
    }
}

foreach(sort keys %flag){
    my ($ele)=(split(/\t/,$_))[1];
    my $rank0=$chip_dep{"$_\t0"}/$chip_len{"$ele\t0"};
    my $rank1=$chip_dep{"$_\t1"}/$chip_len{"$ele\t1"};
    my $rank2=$chip_dep{"$_\t2"}/$chip_len{"$ele\t2"};
    my $rank3=$chip_dep{"$_\t3"}/$chip_len{"$ele\t3"};
    my $rank4=$chip_dep{"$_\t4"}/$chip_len{"$ele\t4"};
    my $rank5=$chip_dep{"$_\t5"}/$chip_len{"$ele\t5"};
    print OUT "$_\t$rank0\t$rank1\t$rank2\t$rank3\t$rank4\t$rank5\n";
}

close OUT;
sub cal{
    my ($ele,$stt,$end,$strand,$pos1,$depth,$rank)=@_;
#    print "$ele,$stt,$end,$strand,$pos1,$depth,$rank\n";
    my $unit=($end-$stt+1)/20;
    my $keys=0;
    if($strand eq '+'){
        $keys=int (($pos1-$stt+1)/$unit);
    }else{
        $keys=int (($end-$pos1+1)/$unit);
    }
    $keys-=1 if $keys==20;
    $chip_dep{"$keys\t$ele\t$rank"}+=$depth;
    $flag{"$keys\t$ele"}++;
#    print "$keys\t$ele\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CHIP database> <CHIP table>  <Gene postion with RANK> <OUTPUT>
    This is to get the histone modification distribution throughth gene for different rank of gene.
DIE
}
