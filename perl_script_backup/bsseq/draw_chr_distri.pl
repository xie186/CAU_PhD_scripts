#Draw the methylation distribution on genome
#!/usr/bin/perl -w
use strict;
use SVG;
die "Usage:perl *.pl <Positive_str><Negative_str><Context>\n" unless @ARGV==3;
my ($plus,$nega,$context)=@ARGV;
die "Please type the CG,CHH,or CHG\n" unless ($context eq "CG" or $context eq "CHH" or $context eq "CHG");
my $methy=SVG->new(width=>5000,height=>2300);

#alculate the genome length;
open PST,$plus or die;
my @plus=<PST>;
my $len=@plus;
my $uni=2000/$len;
close PST;

#drwa the positive strand 
$methy->line('x1',150,'y1',1150,'x2',$len,'y2',1150,'stroke','black','stroke-width',5);
open PST,$plus or die;
while(<PST>){
    next if !/$context/;chomp;
    my ($pos,$melel)=(split(/\s+/,$_))[1,4];
    my $xcor=$uni*$pos+150;
    my $level=1150-$uni*$melel*10000;
    $methy->line('x1',$xcor,'y1',1150,'x2',$xcor,'y2',$level,'stroke','red','stroke-width',5);
}
close PST;
open NST,$nega or die;
while(<NST>){
    next if !/$context/;chomp;
    my ($pos,$melel)=(split(/\s+/,$_))[1,4];
    my $xcor=$uni*$pos+150;
    my $level=1150+$uni*$melel*10000;
    $methy->line('x1',$xcor,'y1',1150,'x2',$xcor,'y2',$level,'stroke','red','stroke-width',5);
}

print $methy->xmlify();
