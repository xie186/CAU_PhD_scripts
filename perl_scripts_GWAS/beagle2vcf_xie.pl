#/usr/bin/perl -w
#$ARGV[0]=the vcf file without imputation  $ARGV[1]=the beagle imputation file
my ($origin_vcf,$imput_res, $maf_cut, $out)  = @ARGV;
die usage() unless @ARGV == 4;
sub usage{
    my $die =<<DIE;
    perl *.pl <original jvcf> <imput results> <maf cutoff> <out>
DIE
}
open T , "$origin_vcf" or die "$!";
open OUT,"+>$out" or die "$!";
my $header = <T>;
   $header =~ s/ /\t/g if $header =~ / /;
print OUT "$header";
chomp $header;
my @head = split(/\t/,$header);
my %snp_rs;
my $line_nu = 1;
while(<T>){
    chomp;
    my ($chr,$pos,$alle,@geno) = split;
    $snp_rs{$line_nu} = "$chr\t$pos\t$alle";
    ++ $line_nu;
}

open IMPUT,"zcat $imput_res|" or die "$!";
<IMPUT>;
$line_nu = 1;
while(<IMPUT>){
    chomp;
    my (@geno) = split;
    my @tem_geno;
    for(my $i = 2;$i < @geno; $i += 2){
        push @tem_geno, $geno[$i];
    }
    my $tem_geno = join("\t",@tem_geno);
    my ($mis_rate,$maf) = &maf($tem_geno);
    print "$snp_rs{$line_nu}\t$mis_rate\t$maf\n";
    if($maf < $maf_cut){
        ++ $line_nu;
        next;
    }
    print OUT "$snp_rs{$line_nu}\t$tem_geno\n";
    ++ $line_nu;
}

sub maf{
    my ($snp_infor) = @_;
    my $tot_1 = $snp_infor =~ s/X/0/g;
    my $tot_2 = $snp_infor =~ tr/ACGTx/12340/;
    my $tot = $tot_1 + $tot_2;
    my $mis = $snp_infor =~ tr/0/0/ || 0;
    my @base_nu;
       $base_nu[0] = $snp_infor =~ s/1/1/g || 0;
       $base_nu[1] = $snp_infor =~ s/2/2/g || 0;
       $base_nu[2] = $snp_infor =~ s/3/3/g || 0;
       $base_nu[3] = $snp_infor =~ s/4/4/g || 0;
    my ($max,$min) = sort{$b<=>$a} @base_nu;
    my $mis_rate = $mis / $tot;
    my $maf = 0;
       $maf = $min / ($tot -  $mis) if $tot -  $mis != 0;
#    print "$line\t$mis_rate, $maf\t$max,$min\n";
    return ($mis_rate,$maf);
}

