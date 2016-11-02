#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV == 7;

my ($gff,$gene_region , $BIN, $tissue, $forw, $rev, $out) = @ARGV;
my $dbh=DBI->connect("dbi:mysql:database=$tissue","root","123456") or die "$DBI::errstr\n";

my %hash_gene;
my %hash_gene_len;
my %hash_gene_pos;
my %hash_gene_chr;
my %hash_gene_str;
open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$tool,$ele,$stt,$end,$flag1,$strand,$flag2,$name) = split;
    if($ele =~ /$gene_region/){
        my ($gene_name) = $name =~ /(.*)\.\d*/;
#        print "$gene_name\n";
#           ($gene_name) = split(/_/,$gene_name) if $gene_name =~ /^GRMZM/;
        for(my $i = $stt;$i <= $end; ++$i){
            $hash_gene{$gene_name}->{"$chr\t$i"} = "xxx";
        }
        push @{$hash_gene_pos{$gene_name}}, ($stt,$end);
        $hash_gene_chr{$gene_name} = $chr;
        $hash_gene_str{$gene_name} = $strand;
    }
}

my %meth_bin;
my %meth_bin_nu;
foreach(keys %hash_gene){
    $hash_gene_len{$_} = keys %{$hash_gene{$_}};
    &gene_pos($_);
    &exon_pos($_);
    &get_meth_infor($_); 
}

open OUT,"+>$out" or die "$!";
foreach(sort keys %meth_bin){
    my $meth_average=$meth_bin{$_}/$meth_bin_nu{$_};
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_average\n";
}
close OUT;

sub get_meth_infor{
    my ($gene_name) = @_;
    my ($chr,$stt,$end,$strand) = ($hash_gene_chr{$gene_name}, @{$hash_gene_pos{$gene_name}},$hash_gene_str{$gene_name});
    my %hash;
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt-1999 and pos1<=$end+1999));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $hash{"$chr\t$pos1"}=$lev;
#           print "$chrom,$pos1,$pos2,$depth,$lev\n";
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
            $keys=int(($pos1-$stt)/$unit);
            $keys="prom\t$keys";
        }elsif($pos1 > $end){
            $keys=int(($pos1-$end)/$unit) + $BIN + 1;
            $keys="term\t$keys";
        }
    }else{
        if($pos1 < $stt){
            $keys=int(($stt-$pos1)/$unit) + $BIN + 1;
            $keys="term\t$keys";
        }elsif($pos1 > $end){
            $keys=int(($end-$pos1)/$unit);
            $keys="prom\t$keys";
        }
    }
    $meth_bin{$keys}+=$methlev if $keys ne 0;
    $meth_bin_nu{$keys}++ if $keys ne 0;
}

sub exon_pos{
    my ($gene_name) = @_;
    my $unit = $hash_gene_len{$gene_name} / $BIN;
    my ($chr,$stt,$end,$strand) = ($hash_gene_chr{$gene_name}, @{$hash_gene_pos{$gene_name}},$hash_gene_str{$gene_name});
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

sub gene_pos{
    my ($gene_name) = @_;
    my @pos = sort{$a<=>$b}@{$hash_gene_pos{$gene_name}};
    @{$hash_gene_pos{$gene_name}} = ($pos[0],$pos[-1]);
}

sub usage{
    print <<DIE;
    perl *.pl <FGS GFF file> <Gene element> <Bin number> <Tissue> <OT> <OB> <OUT> 
DIE
    exit 1;
}
