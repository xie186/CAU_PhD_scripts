#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($tissue,$forw,$rev,$pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$pos or die;
my %promoter;my %prom_exp;my %termina;my %ter_exp;my %intragenic;my %intra_exp;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($name,$chr,$stt,$end,$strand,$rpkm,$rank)=split(/\s+/,$line);
    $chr="chr".$chr;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" AND pos1>=$stt-1999 AND pos1<=$end+1999));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            &cal($name,$chr,$stt,$end,$strand,$rpkm,$rank,$tem_pos1,$lev);
        }
    }
}

foreach(sort{$a<=>$b}keys %promoter){
    open R,"+>$forw.R";
    my $meth=join(',',@{$promoter{$_}});
    my $exp=join(',',@{$prom_exp{$_}});
    print R "meth<-c\($meth\)\nexp<-c($exp)\ncor.test(meth,exp,method='spearman')";
    my $report=`R --vanilla --slave <$forw.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}
foreach(sort{$a<=>$b}keys %intragenic){
    open R,"+>$forw.R";
    my $meth=join(',',@{$intragenic{$_}});
    my $exp =join(',',@{$intra_exp{$_}});
    print R "meth<-c\($meth\)\nexp<-c($exp)\ncor.test(meth,exp,method='spearman')";
    my $report=`R --vanilla --slave <$forw.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}
foreach(sort{$a<=>$b}keys %termina){
    open R,"+>$forw.R";
    my $meth=join(',',@{$termina{$_}});
    my $exp =join(',',@{$ter_exp{$_}});
    print R "meth<-c\($meth\)\nexp<-c($exp)\ncor.test(meth,exp,method='spearman')";
    my $report=`R --vanilla --slave <$forw.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}
sub cal{
    my ($name,$chr,$stt,$end,$strand,$rpkm,$rank,$pos1,$lev)=@_;
    my $key=0;
    my $unit=($end-$stt)/100;
    if($strand eq '+'){
        if($pos1<$stt){
            $key=int(($pos1-$stt)/100);
            push (@{$promoter{$key}},$meth);
            push (@{$prom_exp{$key}},$rpkm);
        }elsif($pos1>=$stt && $pos1<$end){
            $key=int (($pos1-$stt)/$unit);
            push(@{$intragenic{$key}},$meth);
            push(@{$intra_exp{$key}},$rpkm);
        }else{
            $key=int(($pos1-$end)/100);
            push (@{$termina{$key}},$meth);
            push (@{$ter_exp{$key}},$rpkm);
        }
    }else{
        if($pos1<=$stt){
            $key=int(($stt-$pos1)/100);
            push (@{$termina{$key}},$meth);
            push (@{$ter_exp{$key}},$rpkm);
        }elsif($pos1>$stt && $pos1<=$end){
            $key=int (($end-$pos1)/$unit);
            push(@{$intragenic{$key}},$meth);
            push(@{$intra_exp{$key}},$rpkm);
        }else{
            $key=int(($end-$pos1)/100);
            push (@{$promoter{$key}},$meth);
            push (@{$prom_exp{$key}},$rpkm);
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <Gene with expression Rank> <OUTPUT>
    To get the correlation between each bins and methylation.
DIE
}
