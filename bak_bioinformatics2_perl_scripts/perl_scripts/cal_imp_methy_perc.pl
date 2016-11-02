#!/usr/bin/perl -w
use strict;use DBI;
die usage() if @ARGV==4;
my ($tissue,$forw,$rev,$imp)=@ARGV;
my ($fir,$sec,$thi,$for,$fiv,$six,$sev,$eig,$nine,$ten)=(0,0,0,0,0,0,0,0,0,0);
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open GENE,$imp;
while(<GENE>){
    chomp;
    my ($chr,$ele,$stt,$end)=(split)[0,2,3,4];
    next if $ele!=$ele;
    my %hash_meth;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" AND pos1>=$stt-1999 AND pos1<=$end+1999));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            $hash_meth{"$chrom\t$tem_pos1"}=$lev;
        }
    }
        for(my $i=$stt;$i<=$end;++$i){
            if(exists $hash_meth{"chr$chr\t$i"}){
    #            my ($fir,$sec,$thi,$for,$fiv,$six,$sev,$eig,$nine,$ten)=(0,0,0,0,0,0,0,0,0,0);
                if($hash_meth{"chr$chr\t$i"}<=10){
                    $fir++;    
                 }elsif($hash_meth{"chr$chr\t$i"}<=20 && $hash_meth{"chr$chr\t$i"}>10){
                    $sec++;
                }elsif($hash_meth{"chr$chr\t$i"}<=30 && $hash_meth{"chr$chr\t$i"}>20){
                    $thi++;
                }elsif($hash_meth{"chr$chr\t$i"}<=40 && $hash_meth{"chr$chr\t$i"}>30){
                    $for++;
                }elsif($hash_meth{"chr$chr\t$i"}<=50 && $hash_meth{"chr$chr\t$i"}>40){
                    $fiv++
                }elsif($hash_meth{"chr$chr\t$i"}<=60 && $hash_meth{"chr$chr\t$i"}>50){
                    $six++;
                }elsif($hash_meth{"chr$chr\t$i"}<=70 && $hash_meth{"chr$chr\t$i"}>60){
                    $sev++;
                }elsif($hash_meth{"chr$chr\t$i"}<=80 && $hash_meth{"chr$chr\t$i"}>70){
                    $eig++;
                }elsif($hash_meth{"chr$chr\t$i"}<=90 && $hash_meth{"chr$chr\t$i"}>80){
                    $nine++;
                }else{
                    $ten++
                }
            }
        }   
       %hash_meth={};
    }
my $total=$fir+$sec+$thi+$for+$fiv+$six+$sev+$eig+$nine+$ten;
my ($fir_ratio,$sec_ratio,$thi_ratio,$for_ratio,$fiv_ratio,$six_ratio,$sev_ratio,$eig_ratio,$nine_ratio,$ten_ratio)=($fir/$total,$sec/$total,$thi/$total,$for/$total,$fiv/$total,$six/$total,$sev/$total,$eig/$total,$nine/$total,$ten/$total);
print "$fir_ratio\t$sec_ratio\t$thi_ratio\t$for_ratio\t$fiv_ratio\t$six_ratio\t$sev_ratio\t$eig_ratio\t$nine_ratio\t$ten_ratio\n";

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Tissue> <Forw> <Rev> <Gene Position>
DIE
}
