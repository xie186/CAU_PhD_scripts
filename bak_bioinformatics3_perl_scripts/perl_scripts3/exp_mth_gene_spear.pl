#!/usr/bin/perl -w
use strict;use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($tissue,$forw,$rev,$pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$pos or die "$!";
my %promoter;my %prom_exp;my %termina;my %ter_exp;my %intragenic;my %intra_exp;my $flag=1;my %hash;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
 #   next if $line!~/mRNA/;
    chomp $line;

    my ($chr,$ele,$stt,$end,$strand,$name,$rpkm)=(split(/\s+/,$line))[0,1,2,3,4,5,6];
#    $rpkm=log($rpkm);

    $chr="chr".$chr; 
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" AND pos1>=$stt-1999 AND pos1<=$end+1999));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            $hash{"$chrom\t$tem_pos1"}=$lev;
        }
    }
    if($strand eq "+"){
        &cal_forw($name,$chr,$stt,$end,$strand,$rpkm);
    }else{
        &cal_rev($name,$chr,$stt,$end,$strand,$rpkm);
    }
    %hash=();
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
    my $real=0 if $p_value>0.001;
       $real=$correla if $p_value<=0.001;
    print OUT "$_\t$p_value\t$correla\t$real\n";
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
    my $real=0 if $p_value>0.001;
       $real=$correla if $p_value<=0.001;
    print OUT "$_\t$p_value\t$correla\t$real\n";
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
    my $real=0 if $p_value>0.001;
       $real=$correla if $p_value<=0.001;
    print OUT "$_\t$p_value\t$correla\t$real\n";
}
sub cal_forw{
    my ($name,$chr,$stt,$end,$strand,$rpkm)=@_;
    my ($meth,$report)=(0,0);
        #promoter
        for(my $i=-20;$i<=-1;++$i){
            for(my $j=1;$j<=100;++$j){
                my $key_part=$stt+$i*100+$j;
                if(exists $hash{"$chr\t$key_part"}){
                    $meth+=$hash{"$chr\t$key_part"};
                    $report++;
                }
            }
            if($report !=0){
                push (@{$promoter{$i}},$meth/$report);
                push (@{$prom_exp{$i}},$rpkm);
            }
        }
        #3' termination
        ($meth,$report)=(0,0);
        for(my $i=0;$i<20;++$i){
            for(my $j=1;$j<=100;++$j){
                my $key_part=$end-$i*100+$j;
                if(exists $hash{"$chr\t$key_part"}){
                    $meth+=$hash{"$chr\t$key_part"};
                    $report++;
                }
            }
            if($report !=0){
                push (@{$termina{$i+1}},$meth/$report);
                push (@{$ter_exp{$i+1}},$rpkm);
            }
        }
        #gene body
        ($meth,$report)=(0,0);my $uni=($end-$stt)/100;
        for(my $i=0;$i<=99;++$i){
            for(my $j=int ($stt+$i*$uni);$j<=int($stt+($i+1)*$uni);++$j){
                if(exists $hash{"$chr\t$j"}){
                        $meth+=$hash{"$chr\t$j"};
                        $report++;
                }
            }
            if($report !=0){
                push(@{$intragenic{$i+1}},$meth/$report);
                push(@{$intra_exp{$i+1}},$rpkm);
            }
        }
}

sub cal_rev{
    my ($name,$chr,$stt,$end,$strand,$rpkm)=@_;
    my ($meth,$report)=(0,0);
        #promoter
        for(my $i=-19;$i<=0;++$i){
            for(my $j=1;$j<=100;++$j){
                my $key_part=$end-$i*100+$j;
                if(exists $hash{"$chr\t$key_part"}){
                    $meth+=$hash{"$chr\t$key_part"};
                    $report++;
                }
            }
            if($report !=0){
                push (@{$promoter{$i-1}},$meth/$report);
                push (@{$prom_exp{$i-1}},$rpkm);
            }
        }
        #3' termination
        ($meth,$report)=(0,0);
        for(my $i=1;$i<=20;++$i){
            for(my $j=1;$j<=100;++$j){
                my $key_part=$stt-$i*100+$j;
                if(exists $hash{"$chr\t$key_part"}){
                    $meth+=$hash{"$chr\t$key_part"};
                    $report++;
                }
            }
            if($report !=0){
                push (@{$termina{$i}},$meth/$report);
                push (@{$ter_exp{$i}},$rpkm);
            }
        }
        #gene body
        ($meth,$report)=(0,0);my $uni=($end-$stt)/100;
        for(my $i=0;$i<=99;++$i){
            for(my $j=int ($stt+$i*$uni);$j<=int($stt+($i+1)*$uni);++$j){
                if(exists $hash{"$chr\t$j"}){
                        $meth+=$hash{"$chr\t$j"};
                        $report++;
                }
            }
            if($report !=0){
                push(@{$intragenic{100-$i}},$meth/$report);
                push(@{$intra_exp{100-$i}},$rpkm);
            }
        }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forword> <Reverse> <Gene with expression Rank> <OUTPUT>  FGS
    To get the correlation between each bins and methylation
DIE
}
