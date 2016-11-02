#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==6;
my ($repeat,$pos,$methor,$eadge,$cut,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=TE","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr";
open OUT,"+>$out" or die;
open POS,$pos or die;
my %hash;
my %promoter;my %prom_exp;my %termina;my %ter_exp;my %intragenic;my %intra_exp;my $flag=1;
while(my $line=<POS>){
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand,$name,$rpkm)=(split(/\s+/,$line))[0,2,3,4,6,8,9];
    next if $rpkm<=$cut;
    next if $ele!~/gene/;
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    my $tem=$dbh->prepare(qq(select * from $repeat where chrom="$chr" and mid>$stt-$eadge+1 and mid<$end+$eadge+1));
       $tem->execute();
    my ($chrom,$mid,$tem_stt,$tem_end,$tem_str,$type,$cov_c,$meth_lev,$tol_c)=(0,0,0,0,0,0,0,0,0);
       $tem->bind_columns(\$chrom,\$mid,\$tem_stt,\$tem_end,\$tem_str,\$type,\$cov_c,\$meth_lev,\$tol_c);
    while($tem->fetch()){
         if($methor eq "meth"){
             next if $meth_lev<=10;
         }elsif($methor eq "unmeth"){
             next if $meth_lev>10;
         }
         if($strand eq "+"){
             &cal_forw($name,$chr,$stt,$end,$rpkm,$mid,$meth_lev);
        }else{
             &cal_rev($name,$chr,$stt,$end,$rpkm,$mid,$meth_lev);
        }
    }
}

foreach(sort{$a<=>$b}keys %promoter){
    open R,"+>$methor.R";
    my $meth=join(',',@{$promoter{$_}});
    my $exp=join(',',@{$prom_exp{$_}});
    print R "#$_\nmeth<-c\($meth\)\nexp<-c($exp)\ncor.test(jitter(meth),jitter(exp),method='spearman')";
    my $report=`R --vanilla --slave <$methor.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}
foreach(sort{$a<=>$b}keys %intragenic){
    open R,"+>$methor.R";
    my $meth=join(',',@{$intragenic{$_}});
    my $exp =join(',',@{$intra_exp{$_}});
    print R "#$_\nmeth<-c\($meth\)\nexp<-c($exp)\ncor.test(jitter(meth),jitter(exp),method='spearman')";
    my $report=`R --vanilla --slave <$methor.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}
foreach(sort{$a<=>$b}keys %termina){
    open R,"+>$methor.R";
    my $meth=join(',',@{$termina{$_}});
    my $exp =join(',',@{$ter_exp{$_}});
    print R "#$_\nmeth<-c\($meth\)\nexp<-c($exp)\ncor.test(jitter(meth),jitter(exp),method='spearman')";
    my $report=`R --vanilla --slave <$methor.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}
sub cal_forw{
    my ($name,$chr,$stt,$end,$rpkm,$mid,$meth)=@_;
    my $uni=($end-$stt+1)/100;
    my $key=0;
    if($mid<$stt){
        $key=(int (($mid-$stt)/100));
        push (@{$promoter{$key-1}},$meth);
        push (@{$prom_exp{$key-1}},$rpkm);
    }elsif($mid>=$stt && $mid<=$end){
        $key=int (($mid-$stt+1)/$uni);
        push(@{$intragenic{$key+1}},$meth);
        push(@{$intra_exp{$key+1}},$rpkm);
    }elsif($mid>$end){
        $key=(int (($mid-$end)/100));
        push (@{$termina{$key+1}},$meth);
        push (@{$ter_exp{$key+1}},$rpkm);
    }
}

sub cal_rev{
    my ($name,$chr,$stt,$end,$rpkm,$mid,$meth)=@_;
    my $uni=($end-$stt+1)/100;
    my $key=0;
    if($mid<$stt){
        $key=-(int (($mid-$stt)/100));
        push (@{$termina{$key+1}},$meth);
        push (@{$ter_exp{$key+1}},$rpkm);
    }elsif($mid>=$stt && $mid<=$end){
        $key=int (($stt-$mid+1)/$uni);
        push(@{$intragenic{$key+1}},$meth);
        push(@{$intra_exp{$key+1}},$rpkm);
    }elsif($mid>$end){
        $key=-(int (($mid-$end)/100));
        push (@{$promoter{$key-1}},$meth);
        push (@{$prom_exp{$key-1}},$rpkm);
    }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Repeats [TE_endo][TE_sd]> <Gene with expression> <MethOrNot meth unmeth> <Eadge to statistic> <RPKM cut> <OUTPUT>
    To get the correlation between each bins and methylation
DIE
}
