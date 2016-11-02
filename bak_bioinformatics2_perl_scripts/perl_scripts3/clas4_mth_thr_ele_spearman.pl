#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($tissue,$forw,$rev,$gff,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$gff or die;
my %intragenic;my %intra_exp;my $flag=1;my %hash;
while(my $line=<POS>){
    print "$line";
#    print "$flag have been done\n" if $flag%5000==0;$flag++;
    next if ($line=~/CDS/ ||$line=~/gene/ ||$line=~/mRNA/);
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand,$name,$rpkm)=split(/\t/,$line);
    next if $rpkm==0;
    $chr="chr".$chr;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" AND pos1>=$stt AND pos1<=$end));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
           $hash{"$chrom\t$tem_pos1"}=$lev;
        }
    }
    if($strand eq "+"){
        &cal_forw($ele,$chr,$stt,$end,$strand,$rpkm);
    }else{
        &cal_rev($ele,$chr,$stt,$end,$strand,$rpkm);
    }
    %hash=();
}

foreach(sort keys %intragenic){
    print "$_\n";
    open R,"+>$gff.$forw.spearman.R";
    my $meth=join(',',@{$intragenic{$_}});
    my $exp =join(',',@{$intra_exp{$_}});
    print R "meth<-c\($meth\)\nexp<-c($exp)\ncor.test(meth,exp,method='spearman')";
    my $report=`R --vanilla --slave <$gff.$forw.spearman.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}
sub cal_forw{
    my ($ele,$chr,$stt,$end,$strand,$rpkm)=@_;
    my ($meth,$report,$key)=(0,0,0);
       ($meth,$report)=(0,0);my $uni=($end-$stt)/100;
       for(my $i=0;$i<=99;++$i){
           for(my $j=int ($stt+$i*$uni);$j<=int($stt+($i+1)*$uni);++$j){
                if(exists $hash{"$chr\t$j"}){
                        $meth+=$hash{"$chr\t$j"};
                        $report++;
                }
            }
            if($report !=0){
                $key=$i+1;$key="$ele\t$key";
                push(@{$intragenic{$key}},$meth/$report);
                push(@{$intra_exp{$key}},$rpkm);
            }
        }
}

sub cal_rev{
    my ($ele,$chr,$stt,$end,$strand,$rpkm)=@_;
    my ($meth,$report,$key)=(0,0);
        ($meth,$report)=(0,0);my $uni=($end-$stt)/100;
        for(my $i=0;$i<=99;++$i){
            for(my $j=int ($stt+$i*$uni);$j<=int($stt+($i+1)*$uni);++$j){
                if(exists $hash{"$chr\t$j"}){
                        $meth+=$hash{"$chr\t$j"};
                        $report++;
                }
            }
            if($report !=0){
                $key=100-$i;$key="$ele\t$key";       ####Reverse 
                push(@{$intragenic{$key}},$meth/$report);
                push(@{$intra_exp{$key}},$rpkm);
            }
        }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <Gene with expression Rank> <OUTPUT>
    To get the correlation between each bins for each element and methylation
DIE
}
