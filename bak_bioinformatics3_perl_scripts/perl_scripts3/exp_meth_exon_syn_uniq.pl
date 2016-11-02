#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==7;
my ($gff,$ele_want,$tis,$forw,$rev,$syn,$out) = @ARGV;

open SYN,$syn or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($zm_gene,$rice_gene) = split;
    $hash_syn{$zm_gene} ++;
    $hash_syn{$rice_gene} ++;
}

my $dbh=DBI->connect("dbi:mysql:database=$tis","root","123456") or die "$DBI::errstr\n";
open OUT,"+>$out" or die;
open POS,$gff or die;
my %meth_forw;my %meth_forw_nu;my %flag;my $flag=1;
my %hash_uniq;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%10000==0;$flag++;
    chomp $line;
    my ($chr,$tool,$ele,$stt,$end,$flag1,$strand,$flag2,$name) = split(/\s+/,$line);
    next if $chr !~ /\d/;
    next if ($ele !~ /$ele_want/);
    my ($gene_name) = &get_gene_name($name, $tis);
    #print "$name, $tis\n";
    next if (!exists $hash_syn{$gene_name} && $tis !~ /ara/);
    ($ele) = $ele =~ /_(.*)/ if $ele =~/_/;
    $chr="chr".$chr if $chr !~/[a-z]/;
    $hash_uniq{"$chr\t$stt\t$end\t$ele\t$strand"} ++;
}

my %hash_print;
foreach(keys %hash_uniq){
    chomp; 
    my ($chr,$stt,$end,$ele,$strand) = split(/\t/,$_);
    foreach($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chr" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
             next if exists $hash_print{"$chrom\t$tem_pos1"};
#            &cal($stt,$end,$strand,$tem_pos1,$lev,$ele);
             print OUT "$chrom\t$tem_pos1\t$tem_pos2\t$depth\t$lev\n";
             $hash_print{"$chrom\t$tem_pos1"} ++;
        }
    }
}

sub get_gene_name{
    my ($name, $tem_spec) = @_;
    my $gene_name;
    if($tem_spec =~ /ara/ || $tem_spec =~ /rice/){
        ($gene_name) = $name =~ /(.*)\.\d+/;
    }else{
        ($gene_name) = $name =~ /Parent=(.*);Name=/;
        ($gene_name) = split(/_/,$gene_name) if $gene_name =~ /^GRMZM/;
    }
#    print "$name, $tem_spec \t $gene_name\n";
    return $gene_name;
}

sub usage{
    print <<DIE;
    perl *.pl <GFF> <ele> <tissue> <OT> <OB> <Syntenic genes> <out> 
DIE
    exit 1;
}
