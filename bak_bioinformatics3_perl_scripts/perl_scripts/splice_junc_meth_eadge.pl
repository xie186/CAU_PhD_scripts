#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==6;
my ($tissue1,$tissue2,$forw,$rev,$junc,$out)=@ARGV;
my @dbh;
my ($driver,$dsn,$root,$usr)=("mysql","database=$tissue1","root","123456");
   $dbh[0]=DBI->connect("dbi:$driver:$dsn",$root,$usr) or die "$DBI::errstr\n";
   ($driver,$dsn,$root,$usr)=("mysql","database=$tissue2","root","123456");
   $dbh[1]=DBI->connect("dbi:$driver:$dsn",$root,$usr) or die "$DBI::errstr\n";

open JUNC,$junc or die "$!";
my %hash;my %meth;my %meth_nu;my $flag=1;
while(my $line=<JUNC>){
    print "$flag has been done!!!" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$strand,$blk,$exon)=(split(/\s+/,$line))[0,1,2,5,10,11];
    my ($block_size1,$block_size2)=split(/,/,$blk);
       ($stt,$end)=($stt+$block_size1+1,$end-$block_size2+1);
    next if ($end-$stt<=100 ||$end-$stt>=10000);
    my $tis=0;
    foreach my $dbh(@dbh){
        foreach my $forw_rev($forw,$rev){
            my $row=$dbh->prepare(qq(SELECT * FROM $_ WHERE chrom="$chr" AND pos1>=$stt-100 AND pos1<=$end+100));
               $row->execute();
            my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
               $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
            while($row->fetch()){
                $hash{"$chrom\t$pos1"}=$lev;
                print "$chrom,$pos1,$pos2,$depth,$lev\n";
            }
        }
        &cal($chr,$stt,$end,$strand,$tis);
        ++$tis;
        %hash=();
    }
}

open OUT,"+>$out" or die "$!";
foreach(sort{$a<=>$b}keys %meth){
    my $lev_seed=@{$meth{$_}}[0]/@{$meth_nu{$_}}[0];
    my $lev_endo=@{$meth{$_}}[1]/@{$meth_nu{$_}}[1];
    print OUT "$_\t$lev_seed\t$lev_endo\n";
}
sub cal{
    my ($chr,$stt,$end,$strand,$tis)=@_;
    if($strand eq "+"){
        for(my $i=-100;$i<=+100;++$i){
            my $pos=$stt+$i;
            if(exists $hash{"$chr\t$pos"}){
                @{$meth{"1\t$i"}}[$tis]+=$hash{"$chr\t$pos"};
                @{$meth_nu{"1\t$i"}}[$tis]++;
            }
               $pos=$end+$i;
            if(exists $hash{"$chr\t$pos"}){
               @{$meth{"2\t$i"}}[$tis]+=$hash{"$chr\t$pos"};
               @{$meth_nu{"2\t$i"}}[$tis]++;
            }
        }
    }else{
        for(my $i=-100;$i<=100;++$i){
            my $pos=$stt-$i;
            if(exists $hash{"$chr\t$pos"}){
                @{$meth{"2\t$i"}}[$tis]+=$hash{"$chr\t$pos"};
                @{$meth_nu{"2\t$i"}}[$tis]++;
            }
               $pos=$end-$i;
            if(exists $hash{"$chr\t$pos"}){
               @{$meth{"1\t$i"}}[$tis]+=$hash{"$chr\t$pos"};
               @{$meth_nu{"1\t$i"}}[$tis]++;
            }
        }
    }
}
sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <BSR1> <BSR5> <Forw> <Rev> <Junc> <OUT>
DIE
}
