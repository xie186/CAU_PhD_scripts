#!/usr/bin/perl -w
use strict;use DBI;
die usage() unless @ARGV==5;
my ($tissue,$forw,$rev,$gff,$out)=@ARGV;
my $dbh=DBI->connect("dbi:mysql:database=$tissue","root","123456");

open GFF,$gff or die "$!";
my %hash;my %meth;my %meth_nu;my $flag=1;
while(my $line=<GFF>){
    print "$flag has been done!!!" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$strand)=split(/\t/,$line);

    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(SELECT * FROM $_ WHERE chrom="$chr" AND pos1>=$stt-100 AND pos1<=$end+100));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
            $hash{"$chrom\t$pos1"}=$lev;
        }
    }
    &cal($chr,$stt,$end,$strand);
    %hash=();
}

open OUT,"+>$out" or die "$!";
foreach(sort keys %meth){
    my $lev=$meth{$_}/$meth_nu{$_};
    print OUT "$_\t$lev\n";
}
sub cal{
    my ($chr,$stt,$end,$strand)=@_;
    if($strand eq "+"){
        for(my $i=-100;$i<=+100;++$i){
            my $pos=$stt+$i;
            if(exists $hash{"$chr\t$pos"}){
                $meth{"1\t$i"}+=$hash{"$chr\t$pos"};
                $meth_nu{"1\t$i"}++;
            }
               $pos=$end+$i;
            if(exists $hash{"$chr\t$pos"}){
               $meth{"2\t$i"}+=$hash{"$chr\t$pos"};
               $meth_nu{"2\t$i"}++;
            }
        }
    }else{
        for(my $i=-100;$i<=100;++$i){
            my $pos=$stt-$i;
            if(exists $hash{"$chr\t$pos"}){
                $meth{"2\t$i"}+=$hash{"$chr\t$pos"};
                $meth_nu{"2\t$i"}++;
            }
               $pos=$end-$i;
            if(exists $hash{"$chr\t$pos"}){
               $meth{"1\t$i"}+=$hash{"$chr\t$pos"};
               $meth_nu{"1\t$i"}++;
            }
        }
    }
}
sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <BSR> <Forw> <Rev> <Junction site > <OUT>
DIE
}
