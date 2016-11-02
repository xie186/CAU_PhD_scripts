#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==4;
select STDOUT;
$|=1;
my $start_time=localtime();
my ($forw,$rev,$pos,$out)=@ARGV;

open FORW,$forw or die;
my %hash;
while(<FORW>){
    chomp;
    my ($chrom,$cpos,$depth,$meth_lev)=(split(/\s+/,$_))[0,1,3,4];    
    next if $depth<3;
    $hash{"$chrom\t$cpos\tforw"}=$meth_lev;
}
close FORW;

open REV,$rev or die "$!";
while(<REV>){
    chomp;
    my ($chrom,$cpos,$depth,$meth_lev)=(split(/\s+/,$_))[0,1,3,4];
    next if $depth<3;
    $hash{"$chrom\t$cpos\trev"}=$meth_lev;
}
close REV;

open POS,$pos or die;
my %methforw_TSS;my %methforw_TSS_nu;my %methrev_TSS;my %methrev_TSS_nu;my $flag=0;
while(my $line=<POS>){
    chomp $line;
#    my ($chr,$ele,$pos1,$pos2,$strand)=(split(/\s+/,$line))[0,2,3,4,6];   For GFF
    my ($name,$chr,$pos1,$pos2,$strand)=(split(/\s+/,$line));
#    next if ($ele ne 'mRNA' ||$chr ne '1');    for GFF
    print "$flag have been done!\n" if $flag%50==0;++$flag;
    $chr="chr0".$chr;
    &methy($chr,$pos1,$pos2,$strand);
}
%hash=();
close POS;

open OUT,"+>$out" or die;
print OUT "POS\ttop strand\tbottom strand\n";
foreach(sort{$a<=>$b}(keys %methrev_TSS)){
    my $meth_for=$methforw_TSS{$_}/$methforw_TSS_nu{$_};
    my $meth_rev=$methrev_TSS{$_}/$methrev_TSS_nu{$_};
    print OUT "$_\t$meth_for\t$meth_rev\n";
}
#my $end_time=localtime();
#print OUT  "$start_time\t$end_time\n";
exit;

sub methy{
    my ($chr,$pos1,$pos2,$strand)=@_;
    if($strand eq '+'){
        for(my $i=$pos1-100;$i<=$pos1+100;$i+=10){
            for my $pos($i..$i+10){
                if(exists $hash{"$chr\t$pos\tforw"}){
                    $methforw_TSS{$i-$pos1}+=$hash{"$chr\t$pos\tforw"};
                    $methforw_TSS_nu{$i-$pos1}++;
                }elsif(exists $hash{"$chr\t$pos\trev"}){
                    $methrev_TSS{$i-$pos1}+=$hash{"$chr\t$pos\trev"};
                    $methrev_TSS_nu{$i-$pos1}++;
                }else{
                
                }
            }
        }
   }else{
       for(my $i=$pos2-100;$i<=$pos1+100;$i+=10){
            for my $pos($i..$i+10){
                if(exists $hash{"$chr\t$pos\tforw"}){
                    $methforw_TSS{$pos2-$i}+=$hash{"$chr\t$pos\tforw"};
                    $methforw_TSS_nu{$pos2-$i}++;
                }elsif(exists $hash{"$chr\t$pos\trev"}){
                    $methrev_TSS{$pos2-$i}+=$hash{"$chr\t$pos\trev"};
                    $methrev_TSS_nu{$pos2-$i}++;
                }else{
 
                }
           }
       }
   }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <forw> <reverse> <TSSs> <OUT>
    We use this to get methylation information aroud TSSs or TTSs.If TTs,the codes need small modigication.
DIE
}
