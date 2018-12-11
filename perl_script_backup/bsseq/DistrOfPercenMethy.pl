##############################################################################################
#Distribution of the percentage methylation in each context;
##############################################################################################
#!/usr/bin/perl -w
use strict;
#count the CG,CHG,CHH methylation fraction respectivly
my $cg;my $chg;my $chh;
my $methCG;my $methCHG;my $methCHH;my %bin10;
foreach(@ARGV){
    open PST,$_ or die;
    while(my $pst=<PST>){
        chomp $pst;
        my ($pos,$bb,$methlev)=(split(/\s+/,$pst))[1,3,4];
        my ($text,$read)=(split(/:/,$bb))[0,1];
    #    print "$text\t$read\n";
        if($text eq "CG"){
           $cg++;
           if($methlev>0){
                $methCG++;
                &distri($methlev,"CG");
            }
        }elsif($text eq "CHG"){
            $chg++;
            if($methlev>0){
                $methCHG++;
                &distri($methlev,"CHG");
            }
        }else{
            $chh++;
            if($methlev>0){
                $methCHH++;
                &distri($methlev,"CHH");
            }
        }
    }
    close PST;
}
foreach (keys %bin10){
    my $meth_lev=&which_context($_,$bin10{$_}); 
    printf ("$_\t%.3f\n",$meth_lev);
}   

#
sub distri{
    my $lev=shift;
    my $text=shift;
    if($lev>0 && $lev<=0.1){
        $text.="_01";
        $bin10{$text}++;
    }elsif($lev>0.1 && $lev<=0.2){
        $text.="_02";
        $bin10{$text}++;
    }elsif($lev>0.2 && $lev<=0.3){
        $text.="_03";
        $bin10{$text}++;
    }elsif($lev>0.3 && $lev<=0.4){
        $text.="_04";
        $bin10{$text}++;
    }elsif($lev>0.4 && $lev<=0.5){
        $text.="_05";
        $bin10{$text}++;
    }elsif($lev>0.5 && $lev<=0.6){
        $text.="_06";
        $bin10{$text}++;
    }elsif($lev>0.6 && $lev<=0.7){
        $text.="_07";
        $bin10{$text}++;
    }elsif($lev>0.7 && $lev<=0.8){
        $text.="_08";
        $bin10{$text}++;
    }elsif($lev>0.8 && $lev<=0.9){
        $text.="_09";
        $bin10{$text}++;
    }elsif($lev>0.9 && $lev<=1){
        $text.="_10";
        $bin10{$text}++;
    }else{
        next; 
    }
#    return %bin10;
}

#judge which value to devide
sub which_context{
    my $methy_text=shift;my $methy_nu=shift;
    ($methy_text)=(split(/\_/,$methy_text))[0];
    my $meth_lev;
    if($methy_text eq "CG"){
        $meth_lev=$methy_nu/$methCG;
    }elsif($methy_text eq "CHG"){
        $meth_lev=$methy_nu/$methCHG;
    }else{
        $meth_lev=$methy_nu/$methCHH;
    }
    return $meth_lev;
}
