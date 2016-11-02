#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==5;
my ($repeat,$pos,$methor,$eadge,$out)=@ARGV;
open OUT,"+>$out" or die;
open REP,$repeat or die "$!";
my %hash;
while(<REP>){
    chomp;
    my ($chr,$stt,$end,$strand,$mips,$sec_mips,$cov_c,$meth_pro,$tol_c)=(split(/\t/))[0,1,2,3,4,5,6,7,8];
    next if (!$tol_c || $cov_c/($tol_c+0.00000001)<0.3 || $cov_c<5);
    my $mid=int (($stt+$end)/2);
    if($methor eq "meth"){
        next if $meth_pro<0.1;
    }elsif($methor eq "unmeth"){
        next if $meth_pro>=0.1;
    }else{

    }
    $hash{"$chr\t$mid"}=$meth_pro;
}

open POS,$pos or die;
my %promoter;my %prom_exp;my %termina;my %ter_exp;my %intragenic;my %intra_exp;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand,$name,$rpkm)=(split(/\s+/,$line))[0,2,3,4,6,8,9];
    next if $ele!~/gene/;
 #   print "$chr,$ele,$stt,$end,$strand,$name,$rpkm\n";
    if($strand eq "+"){
        &cal_forw($name,$chr,$stt,$end,$strand,$rpkm);
    }else{
        &cal_rev($name,$chr,$stt,$end,$strand,$rpkm);
    }
}

foreach(sort{$a<=>$b}keys %promoter){
    open R,"+>$methor.R";
    my $meth=join(',',@{$promoter{$_}});
    my $exp=join(',',@{$prom_exp{$_}});
    print R "meth<-c\($meth\)\nexp<-c($exp)\ncor.test(meth,exp,method='spearman')";
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
    print R "meth<-c\($meth\)\nexp<-c($exp)\ncor.test(meth,exp,method='spearman')";
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
    print R "meth<-c\($meth\)\nexp<-c($exp)\ncor.test(meth,exp,method='spearman')";
    my $report=`R --vanilla --slave <$methor.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}
sub cal_forw{
    my ($name,$chr,$stt,$end,$strand,$rpkm)=@_;
    my ($meth,$report)=(0,0);
        #promoter
        for(my $i=-$eadge;$i<=-1;++$i){
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
        for(my $i=0;$i<$eadge;++$i){
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
    my ($name,$chr,$stt,$end,$strand,$rpkm,$rank)=@_;
    my ($meth,$report)=(0,0);
        #promoter
        for(my $i=-$eadge;$i<=-1;++$i){
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
        for(my $i=1;$i<=$eadge;++$i){
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
    perl *.pl <Repeats> <Gene with expression Rank> <MethOrNot meth unmeth> <Eadge to statistic> <OUTPUT>
    To get the correlation between each bins and methylation
DIE
}
