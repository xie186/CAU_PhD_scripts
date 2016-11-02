#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==3;
my ($cgi,$pos,$out)=@ARGV;

open OUT,"+>$out" or die;
my $start_time=localtime();

open CGI,$cgi or die "$!";my %hash;
while(<CGI>){
    chomp;
    my ($chrom,$stt,$end,$strands)=(split(/\t/,$_))[0,1,2];
    my $pos=int (($end+$stt)/2);
    $hash{"$chrom\t$pos"}++;
}

open POS,$pos or die;
my %prom_density;my %body_density;my %terminal_density;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($chr,$stt,$end,$name,$strand)=split(/\s+/,$line);
    $chr="chr".$chr;
    foreach(my $i=$stt-1999;$i<=$end+1999;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"});
        }
    }
}
%hash=();

foreach(sort{$a<=>$b}keys %prom_density){
    print OUT "$_\t$prom_density{$_}\n";
}
foreach(sort{$a<=>$b}keys %body_density){
    print OUT "$_\t$body_density{$_}\n";
}
foreach(sort{$a<=>$b}keys %terminal_density){
    print OUT "$_\t$terminal_density{$_}\n";
}


my $end_time=localtime();
print OUT "$start_time\t$end_time\n";
close OUT;
sub cal{
    my ($stt,$end,$strand,$pos1,$methlev)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $prom_density{$keys}++;
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
#            $keys.="body";
            $body_density{$keys}++;
        }else{
            $keys=int(($pos1-$end)/100);
            $terminal_density{$keys}++;
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $terminal_density{$keys}++;
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $body_density{$keys}++;
        }else{
            $keys=int(($end-$pos1)/100);
            $prom_density{$keys}++;
            
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CGI position> <Gene position> <OUTPUT>
    This is to get the methylation distribution throughth gene or TEs
DIE
}
