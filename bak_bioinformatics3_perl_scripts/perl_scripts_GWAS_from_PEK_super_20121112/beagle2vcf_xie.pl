#/usr/bin/perl -w
#$ARGV[0]=the vcf file without imputation  $ARGV[1]=the beagle imputation file
my ($origin_vcf,$imput_res,$out)  = @ARGV;
die usage() unless @ARGV == 3;
sub usage{
    my $die =<<DIE;
    perl *.pl <original jvcf> <imput results> <out>
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
    ++ $line_nu;
    
    print OUT "$snp_rs{$line_nu}\t$tem_geno\n";
}
