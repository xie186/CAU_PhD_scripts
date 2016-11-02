#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==7;
my ($database,$tissue,$len_cut,$ge_pos,$gff,$ge_type,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$database","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$ge_pos or die;
my %hash_pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$name,$strand,$type)=(split)[0,1,2,3,4,5];
    $chr="chr".$chr;
    $hash_pos{$name}=$type;
}

open GFF,$gff or die "$!";
my %meth_forw;my %meth_forw_nu;my %meth_rev;my %meth_rev_nu;my $flag=1;
while(my $line=<GFF>){
    print "$flag have been done\n" if $flag%5000==0;$flag++;
    chomp $line;
    my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
    next if ($ele ne "gene" && $hash_pos{$name} eq $ge_type);
    $chr="chr".$chr;
    my %hash_forw;my %hash_rev;
    my $row=$dbh->prepare(qq(select * from $tissue where chrom="$chr" and pos>=$stt-1999-30 and pos<=$end+1999+30));
       $row->execute();
    my ($id,$len,$copy,$rna_strand,$chrom,$pos)=(0,0,0,0,0,0);
       $row->bind_columns(\$id,\$len,\$copy,\$rna_strand,\$chrom,\$pos);
    while($row->fetch()){
       next if $len==$len_cut;
       if($rna_strand==16){
          $pos=$pos+$len-1;
          $hash_rev{"$chr\t$pos"}=$copy;
       }else{
          $hash_forw{"$chr\t$pos"}=$copy;
       }
    }
    foreach(my $i=$stt-2000;$i<=$end+2000;++$i){
        &cal($stt,$end,$strand,$i,$hash_forw{"$chr\t$i"},"forw_derive") if(exists $hash_forw{"$chr\t$i"});
        &cal($stt,$end,$strand,$i,$hash_rev{"$chr\t$i"},"rev_derive") if(exists $hash_rev{"$chr\t$i"});
    }
    %hash_forw=();
    %hash_rev=();
}

foreach(sort keys %meth_forw){
    my $meth_forw=${$meth_forw{$_}}[0]/${$meth_forw_nu{$_}}[0];
    my $meth_rev=${$meth_forw{$_}}[1]/${$meth_forw_nu{$_}}[1];
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_forw\t$meth_rev\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev,$derive)=@_;
    my $unit=($end-$stt)/100;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    if($derive eq "forw_derive"){
        ${$meth_forw{$keys}}[0]+=$methlev;
        ${$meth_forw_nu{$keys}}[0]++;
    }else{
        ${$meth_forw{$keys}}[1]+=$methlev;
        ${$meth_forw_nu{$keys}}[1]++;
    }
}

sub usage{
    my $die=<<DIE;

    perl *.pl <smRNA database> <tissue smRNA_em or smRNA_endo> <Length cutoff(24,22,21)> <Gene position with type(protein coding,pseudogene and transposable elements)> <GFF exp || noexp> <gene type> <OUTPUT>

    To get the smRNA density across expressed and non-expressed gene

DIE
}
