#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($repeat,$pos,$methor,$cut,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=TE","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr";
open OUT,"+>$out" or die;
open POS,$pos or die;
my %hash;
my %te_mth;my %exp_ele;my $flag=1;
while(my $line=<POS>){
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand,$name,$rpkm)=(split(/\s+/,$line))[0,2,3,4,6,8,9];
    next if $rpkm<=$cut;
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    my $tem=$dbh->prepare(qq(select * from $repeat where chrom="$chr" and mid>$stt+1 and mid<$end+1));
       $tem->execute();
    my ($chrom,$mid,$tem_stt,$tem_end,$tem_str,$type,$cov_c,$meth_lev,$tol_c)=(0,0,0,0,0,0,0,0,0);
       $tem->bind_columns(\$chrom,\$mid,\$tem_stt,\$tem_end,\$tem_str,\$type,\$cov_c,\$meth_lev,\$tol_c);
    while($tem->fetch()){
         if($methor eq "meth"){
             next if $meth_lev<=10;
         }elsif($methor eq "unmeth"){
             next if $meth_lev>10;
        }
        push @{$te_mth{$ele}},$meth_lev;
        push @{$exp_ele{$ele}},$rpkm;
    }
}

foreach(sort keys %te_mth){
    open R,"+>$methor.R";
    my $meth=join(',',@{$te_mth{$_}});
    my $exp=join(',',@{$exp_ele{$_}});
    print R "meth<-c\($meth\)\nexp<-c($exp)\ncor.test(jitter(meth),jitter(exp),method='spearman')";
    my $report=`R --vanilla --slave <$methor.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Repeats [TE_endo][TE_sd]> <Gene with expression> <MethOrNot meth unmeth> <RPKM cut> <OUTPUT>
    To get the correlation between each bins and methylation
DIE
}
