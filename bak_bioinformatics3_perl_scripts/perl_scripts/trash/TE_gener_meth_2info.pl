#!/usr/bin/perl -w
use strict;
use DBI;
my ($rebase,$gff,$tissue,@meth)=@ARGV;
die usage() if @ARGV==0;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open MIPS,$rebase or die "$!";
my %id_rebase;my %id_rebase_gt5;my %real_id;
while(<MIPS>){
    chomp;
    next if !/^>/;
    my ($id,$name)=(split(/\|/,$_))[-2,-1];
    $real_id{$id}=$name;
    my @id=split(/\./,$id);
    if(@id>4){
        $id_rebase_gt5{$id}=$name;
    }else{
        $id_rebase{$id}=$name;
    }
}
foreach(keys %id_rebase_gt5){
    my @id=split(/\./,$_);
    my $id=join('.',($id[0],$id[1],$id[2],$id[3]));
    if(!(exists $id_rebase{$id})){
        $id_rebase{$_}=$id_rebase_gt5{$_};
    }
}
open GFF,$gff or die "$!";
my %mips_nu;my %mips_len;
while(<GFF>){
    chomp;
    next if (/^#/ || /^UNKNOWN/ || /^chloroplas/ || /^mito/);
    my ($chr,$stt,$end,$strand,$id)=(split(/\s+/,$_))[0,3,4,6,8];
    ($id)=$id=~/class=(.+)\;type/;
    my $re_id=$id;
    my @id=split(/\./,$id);
    if(exists $id_rebase{$id}){    #some ID of TEs have less than 3 numbers 
               
    }elsif(@id>4){
        $id=join('.',($id[0],$id[1],$id[2],$id[3]));       
    }
    my ($meth_lev,$c_nu)=(0,0);
    foreach(@meth){
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
        my $row=$dbh->prepare(qq(select * from $_ where chrom="chr$chr" and pos1>=$stt and pos1<=$end));
            $row->execute();
            $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            $meth_lev+=$lev;
            $c_nu++;
        }
    }
    $meth_lev=$meth_lev/(0.000001+$c_nu);  #methycytocine propotion	
    print "$chr\t$stt\t$end\t$strand\t$id_rebase{$id}\t$real_id{$re_id}\t$c_nu\t$meth_lev\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Rebase> <MIPS GFF> <Tissue> <Six methylation tables> 
DIE
}
