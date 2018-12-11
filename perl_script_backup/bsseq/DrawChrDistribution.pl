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
my @plu=<PST>;
my ($len)=(split(/\s+/,$plu[-1]))[1];                   #print "$len";
my $uni=2000/$len;                                      #print "$uni\n";
close PST;

#drwa the positive strand 
$methy->line('x1',150,'y1',1150,'x2',$len,'y2',1150,'stroke','black','stroke-width',5);
open PST,$plus or die;
my $level=0;                                            #the methylation level
my $i=0;
while(my $pst=<PST>){
    chomp $pst;
    my ($pos,$metcon,$melel)=(split(/\s+/,$pst))[1,3,4];
    my ($text,$read)=(split(/:/,$metcon))[0,1];
    next if($read<10 or $text ne $context);
    my $xcor=$uni*$pos+150;
    if($pos<50000*$i && $pos>=50000*($i-1) && $melel>0){
        $level+=1;                                       #print"$level\n";
    }else{
        $level=1150-$uni*$level*10000;                   #print "$level\n";
        $methy->line('x1',$xcor,'y1',1150,'x2',$xcor,'y2',$level,'stroke','red','stroke-width',5);
        $level=0;
        $i++;
    }
}
close PST;

print $methy->xmlify();
