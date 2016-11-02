#!/usr/bin/perl -w
use strict;
use DBI;
die "\n",usage(),"\n" unless @ARGV==5;
my ($te,$pos,$methor,$cut,$out)=@ARGV;
open TE,$te or die "$!";
my %hash_ele;
while(<TE>){
    chomp;
    my ($chrom,$mid,$tem_stt,$tem_end,$tem_str,$type,$cov_c,$meth_lev,$tol_c)=split;
    $hash_ele{"$chrom\t$mid"}=$meth_lev if $meth_lev>40;
#    if($methor eq "methy"){
#        $hash_ele{"$chrom\t$mid"}=$meth_lev if $meth_lev>10;
#    }elsif($methor eq "unmeth"){
#        $hash_ele{"$chrom\t$mid"}=$meth_lev if $meth_lev<=10;
#    }
}
open OUT,"+>$out" or die;
open POS,$pos or die;
my %ele;my %ele_exp;my $flag=1;
while(my $line=<POS>){
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand,$name,$rpkm)=(split(/\s+/,$line))[0,2,3,4,6,8,9];
    next if $rpkm<$cut;
    next if $ele=~/gene/;
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    if($strand eq "+"){
         &cal_forw($ele,$chr,$stt,$end,$rpkm);
    }else{
         &cal_rev($ele,$chr,$stt,$end,$rpkm);
    }
}

foreach(sort keys %ele){
    open R,"+>$methor.R";
    my $meth=join(',',@{$ele{$_}});
    my $exp=join(',',@{$ele_exp{$_}});
    print R "#$_\nmeth<-c\($meth\)\nexp<-c($exp)\ncor.test(jitter(meth),jitter(exp),method='spearman')";
    my $report=`R --vanilla --slave <$methor.R`;
    my @tem=split(/\n/,$report);
    my ($p_value)=$tem[-5]=~/p-value\s*[><=]\s*(.+)/;
    $tem[-1]=~s/\s//g;
    my $correla=$tem[-1];
    print OUT "$_\t$p_value\t$correla\n";
}

sub cal_forw{
    my ($ele,$chr,$stt,$end,$rpkm)=@_;
    my ($meth,$report,$key)=(0,0,0);
    my $uni=($end-$stt+1)/100;
       for(my $i=0;$i<=99;++$i){
           for(my $j=int ($stt+$i*$uni);$j<=int($stt+($i+1)*$uni);++$j){
                if(exists $hash_ele{"$chr\t$j"}){
                        $meth+=$hash_ele{"$chr\t$j"};
                        $report++;
                }
            }
            if($report !=0){
                $key=$i+1;
                $key="$ele\t$key";
                push(@{$ele{$key}},$meth/$report);
                push(@{$ele_exp{$key}},$rpkm);
            }
        }
}

sub cal_rev{
     my ($ele,$chr,$stt,$end,$rpkm)=@_;
    my ($meth,$report,$key)=(0,0,0);
    my $uni=($end-$stt+1)/100;
        for(my $i=0;$i<=99;++$i){
            for(my $j=int ($stt+$i*$uni);$j<=int($stt+($i+1)*$uni);++$j){
                if(exists $hash_ele{"$chr\t$j"}){
                        $meth+=$hash_ele{"$chr\t$j"};
                        $report++;
                }
            }
            if($report !=0){
                $key=100-$i;$key="$ele\t$key";       ####Reverse
                push(@{$ele{$key}},$meth/$report);
                push(@{$ele_exp{$key}},$rpkm);
            }
        } 
}
sub usage{
    my $die=<<DIE;
    perl *.pl <TE meth table > <Gene with expression gff> <MethOrNot meth unmeth> <RPKM cut> <OUTPUT>
    To get the correlation between each bins and methylation
DIE
}
