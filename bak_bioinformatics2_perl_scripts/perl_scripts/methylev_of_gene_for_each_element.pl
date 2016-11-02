#!/usr/bin/perl -w
use strict;use DBI;
die usage() unless @ARGV==4;
my ($tissue,$gff,$bed1,$bed2,$geno)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
my %gene_hash;
open GFF,$gff or die "$!";
my %hash;
while(<GFF>){
     chomp;
     my ($chr,$ele,$pos1,$pos2,$strand,$name)=(split(/\s+/,$_))[0,2,3,4,6,-1];
     next if ($ele eq "gene");
     ($name)=split(/\;/,$name);
     ($name)=(split(/=/,$name))[1];
     &ele($chr,$ele,$pos1,$pos2,$strand,$name);
     $chr="chr".$chr;
     $gene_hash{"$name"}=$chr;
}

foreach(keys %gene_hash){
     if ( (!exists $hash{"$_\tintron"})|| (@{$hash{"$_\tintron"}}<=1)){ #exists $hash{"$_\tintron"} 
         delete $gene_hash{$_};
         next;
     }
     my $tem1=shift @{$hash{"$_\texon"}};
     my $tem2=shift @{$hash{"$_\texon"}};
     push(@{$hash{"$_\tfir_exon"}},($tem1,$tem2));
}

my %methy;
open GENO,$geno or die "$!";
<GENO>;
my $seq;
while(<GENO>){
    chomp;
    $seq.=$_;
}

foreach(keys %gene_hash){
    my ($pro_lev,$tss,$tts,$exon5,$exon)=&get_meth($_,$gene_hash{$_});
    print "$_\t$pro_lev\t$tss\t$tts\t$exon5\t$exon\n";
}

sub get_meth{
    my ($ge_trans,$chr)=@_;
    my ($eadge1,$eadge2)=sort{$a<=>$b}(${$hash{"$ge_trans\ttss"}}[-1],${$hash{"$ge_trans\ttts"}}[1]);
    foreach($bed1,$bed2){
        my $row=$dbh->prepare(qq(SELECT * FROM $_ WHERE chrom="$chr" AND pos1>=$eadge1-2000 AND pos1<=$eadge2+2000));
           $row->execute();
        my ($chrom,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrom,\$pos1,\$pos2,\$depth,\$lev);
           $methy{"$chr\t$pos1"}=$lev;
    }
    my($pro_lev,$tss,$tts,$exon5,$exon,$intron)=(0,0,0,0,0,0);
    #promoter
    $pro_lev=&cal_meth(${$hash{"$ge_trans\tpromoter"}}[0],${$hash{"$ge_trans\tpromoter"}}[1]);
    #TSS 
    $tss=&cal_meth(${$hash{"$ge_trans\ttss"}}[0],${$hash{"$ge_trans\ttss"}}[1]);
    #TTS
    $tts=&cal_meth(${$hash{"$ge_trans\ttts"}}[0],${$hash{"$ge_trans\ttts"}}[1]); 
    #5' Exon
    $exon5=&cal_meth(${$hash{"$ge_trans\tfir_exon"}}[0],${$hash{"$ge_trans\tfir_exon"}}[1]);
    %methy={};
    return ($pro_lev,$tss,$tts,$exon5,$exon);
}

sub cal_meth{
    my ($posi1,$posi2)=@_;
    my ($meth_tem,$number)=(0,0);
    for(my $i=$posi1;$i<=$posi2;++$i){
        if(exists $methy{$i}){
            $meth_tem+=$methy{$i};
            $number++;
        }
    }

    my $tem=substr($seq,$posi1-2,$posi2-$posi1+2);
    my $cpg=$tem=~s/CG/CG/g;    
    if($cpg<2 || $number/(2*$cpg)<0.5){
        return "NA" 
    }else{
        my $return=$meth_tem/$number;
        return $return;
    }   
}

sub ele{
    my ($chr,$ele,$pos1,$pos2,$strand,$name)=@_;
    if($strand eq '+'){
        if($ele eq 'mRNA'){
            $hash{"$name\tpromoter"}=[$pos1-2000,$pos1];
            $hash{"$name\ttss"}=[$pos1-100,$pos1+100];
            $hash{"$name\ttts"}=[$pos2-100,$pos2+100];
        }elsif($ele eq 'intron'){
            push(@{$hash{"$name\tintron"}},($pos1,$pos2));
        }elsif($ele eq 'exon'){
            push(@{$hash{"$name\texon"}},($pos1,$pos2));
        }else{
            return 0;
        }
    }else{
        if($ele eq 'mRNA'){
            $hash{"$name\tpromoter"}=[$pos2,$pos2+2000];
            $hash{"$name\ttss"}=[$pos2-100,$pos2+100];
            $hash{"$name\ttts"}=[$pos1-100,$pos1+100];
        }elsif($ele eq 'intron'){
            unshift(@{$hash{"$name\tintron"}},($pos1,$pos2));
        }elsif($ele eq 'exon'){
            unshift(@{$hash{"$name\texon"}},($pos1,$pos2));
        }else{
            return 0;  
        }
    }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <GFF> <Bedgraph OT> <Bedgraph OB> <Geno>
    Output format:
    <Gene_transcripts> <Promoter> <TSS> <TTS> <First exon>
DIE
}
