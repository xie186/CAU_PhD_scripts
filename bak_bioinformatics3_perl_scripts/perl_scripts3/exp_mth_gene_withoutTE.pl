#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV == 8;
my ($gff, $te_pos, $BIN, $syn ,$tissue, $forw, $rev, $out) = @ARGV;
my $dbh=DBI->connect("dbi:mysql:database=$tissue","root","123456") or die "$DBI::errstr\n";

open SYN,$syn or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($zm_gene,$rice_gene) = split;
    $hash_syn{$zm_gene} ++;
    $hash_syn{$rice_gene} ++;
}

my %hash_exclu;
open TE,$te_pos or die "$!";
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$chrom,$te_stt,$te_end) = split;
    $chrom = "chr".$chrom if $chrom !~ /[a-z]/;
    for(my $i = $te_stt; $i <= $te_end; ++ $i){
        $hash_exclu{"$chrom\t$i"} ++;
    }
}

print "xx\n";
my %hash_gene;
my %hash_gene_len;
open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$stt,$end,$name,$strand) = split;
    next if $chr !~ /\d/;
    $chr = "chr".$chr if $chr !~ /[a-z]/;
#        my ($gene_name) = &get_gene_name($name, $tissue);
    next if (!exists $hash_syn{$name} && ($tissue =~ /BSR/ || $tissue =~ /rice/)) ;
    print "$_\n";
    for(my $i = $stt;$i <= $end; ++$i){
        next if exists $hash_exclu{"$chr\t$i"};
        print "$chr\t$i\n";
        $hash_gene{$name}->{"$chr\t$i"} = "xxx";
    }
    $hash_gene{$name}->{"chr"} = $chr;
    $hash_gene{$name}->{"stt"} = $stt;
    $hash_gene{$name}->{"end"} = $end;
    $hash_gene{$name}->{"strand"} = $strand;
}

my %meth_bin;
my %meth_bin_nu;
foreach(keys %hash_gene){
    print "$_\n";
    $hash_gene_len{$_} = (keys %{$hash_gene{$_}} ) - 4;
    &exon_pos($_);
    &get_meth_infor($_); 
}

print "hash_gene\n";

open OUT,"|sort -k1,1n -k2,2n >$out" or die "$!";
print "meth_bin\n";
foreach(sort keys %meth_bin){
    my $meth_average=$meth_bin{$_}/$meth_bin_nu{$_};
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_average\n";
    print "$_\t$meth_average\n";
}
close OUT;

sub get_meth_infor{
    my ($gene_name) = @_;
    my ($chr,$stt,$end,$strand) = ($hash_gene{$gene_name}->{"chr"}, $hash_gene{$gene_name}->{"stt"} , $hash_gene{$gene_name}->{"end"} , $hash_gene{$gene_name}->{"strand"});
    print "($chr,$stt,$end,$strand,$gene_name\n";
    my %hash;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $hash{"$chr\t$pos1"}=$lev;
        }
    }
    foreach(my $i=$stt-2000;$i<=$stt-1;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"});
        }
    }
    foreach(my $i=$end-1;$i<=$end+2000;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($stt,$end,$strand,$i,$hash{"$chr\t$i"});
        }
    }
    foreach(my $i = $stt;$i <= $end;++ $i){
        if(exists $hash{"$chr\t$i"} && exists $hash_gene{$gene_name}->{"$chr\t$i"}){
            my $tem_bin_nu = $hash_gene{$gene_name}->{"$chr\t$i"};
            print "body\t$tem_bin_nu\t$hash{\"$chr\t$i\"}\n";
            $meth_bin{"body\t$tem_bin_nu"} += $hash{"$chr\t$i"};
            $meth_bin_nu{"body\t$tem_bin_nu"} ++;
        }
    }
}

sub cal{
    my ($stt,$end,$strand,$pos1,$methlev)=@_;
    my $unit = 2000 / $BIN;
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1 > $end){
            $keys=int(($pos1-$end)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="term\t$keys";
        }elsif($pos1 > $end){
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    $meth_bin{$keys}+=$methlev if $keys ne 0;
    $meth_bin_nu{$keys}++ if $keys ne 0;
}

sub exon_pos{
    my ($gene_name) = @_;
    my $unit = $hash_gene_len{$gene_name} / $BIN;
    my ($chr,$stt,$end,$strand) = ($hash_gene{$gene_name}->{"chr"}, $hash_gene{$gene_name}->{"stt"} , $hash_gene{$gene_name}->{"end"} , $hash_gene{$gene_name}->{"strand"});
#    print "$chr,$stt,$end,$strand\n";
    if($strand eq "+"){
        my $count=0;
        for(my $i = $stt;$i <= $end;++$i){
            if(exists $hash_gene{$_}->{"$chr\t$i"}){
                 ++ $count;
                 $hash_gene{$_}->{"$chr\t$i"} = int ($count/$unit)+1;
                 $hash_gene{$_}->{"$chr\t$i"} = $BIN if $hash_gene{$_}->{"$chr\t$i"} > $BIN;
#                 print "$hash_gene{$_}->{\"$chr\t$i\"}\n";
            }
        }
    }else{
        my $count=0;
        for(my $i = $end;$i >= $stt;--$i){
            if(exists $hash_gene{$_}->{"$chr\t$i"}){
                 ++ $count;
                 $hash_gene{$_}->{"$chr\t$i"} = int ($count/$unit)+1;
                 $hash_gene{$_}->{"$chr\t$i"} = $BIN if $hash_gene{$_}->{"$chr\t$i"} > $BIN;
#                 print "$hash_gene{$_}->{\"$chr\t$i\"}\n";
            }
        }
    }
}

sub usage{
    print <<DIE;
    perl *.pl <gene position> <TE_asso gene> <Bin number> <Syntenic genes> <Tissue> <OT> <OB>  <OUT>
DIE
    exit 1;
}
