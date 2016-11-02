#!/usr/bin/perl -w
open F,$ARGV[0] or die;
while(<F>){
	next if !/^chr/;
	my @tem=split;
        next if $tem[4] =~ /\,/;

#############################
        #my ($gt58,$dp58)=$tem[-4]=~/(\d\/\d)\:\d+\,\d+\:(\d+)\:/;
        my ($gt58, $AF58 ,$dp58) = (split(/:/, $tem[-4]));
        if($tem[-4] =~ /\.\/\./){
            $gt58 = "-";
            $dp58 = 0;
        }else{
            my ($AF58_1, $AF58_2) = split(/,/, $AF58);
            next if ($AF58_1 != 0 && $AF58_2 != 0);
        }

        #my ($gt5003,$dp5003) = $tem[-3] =~ /(\d\/\d)\:\d+\,\d+\:(\d+)\:/;
        my ($gt5003, $AF5003,$dp5003) = (split(/:/, $tem[-3]));
        if($tem[-3] =~ /\.\/\./){
            $gt5003 = "-";
            $dp5003 = 0;
        }else{
            my ($AF5003_1, $AF5003_2) = split(/,/, $AF5003);
            next if ($AF5003_1 != 0 && $AF5003_2 != 0);
        }
        #my ($gt478,$dp478) = $tem[-2] =~ /(\d\/\d)\:\d+\,\d+\:(\d+)\:/;
        my ($gt478, $AF478, $dp478) = (split(/:/, $tem[-2]));
        if($tem[-2] =~ /\.\/\./){
            $gt478 = "-";
            $dp478 = 0;
        }else{
            my ($AF478_1, $AF478_2) = split(/,/, $AF478);
            next if ($AF478_1 != 0 && $AF478_2 != 0);
        }
        #my ($gt8112,$dp8112)=$tem[-1]=~/(\d\/\d)\:\d+\,\d+\:(\d+)\:/;
        my ($gt8112, $AF8112, $dp8112) = (split(/:/, $tem[-1]));
        if($tem[-1] =~ /\.\/\./){
            $gt8112 = "-";
            $dp8112=0;
        }else{
            my ($AF8112_1, $AF8112_2) = split(/,/, $AF8112);
            next if ($AF8112_1 != 0 && $AF8112_2 != 0);
        }


#############################
        my $ff;
        my $tt;
        if($gt5003 ne "-"){
                $tt++;
                if($gt5003 eq "0/1"){
                        #print;
                        next;
                }
                elsif($gt5003 eq "1/1"){
                        $ff += 1;
                }
                else{
                        $ff += -1;
                }
        }
        if($gt478 ne "-"){
                $tt ++;
                if($gt478 eq "0/1"){
                        #print;
                        next;
                }
                elsif($gt478 eq "1/1"){
                        $ff += 1;
                }
                else{
                        $ff += -1;
                }
        }
        if($gt8112 ne "-"){
                $tt++;
                if($gt8112 eq "0/1"){
                        #print;
                        next;
                }
                elsif($gt8112 eq "1/1"){
                        $ff += 1;
                }
                else{
                        $ff += -1;
                }
        }
        if($gt58 ne "-"){
                $tt++;
                if($gt58 eq "0/1"){
                        #print;
                        next;
                }
                elsif($gt58 eq "1/1"){
                        $ff += 1;
                }
                else{
                        $ff += -1;
                }
        }
        my $flag=(abs($ff))/$tt;
	next if $dp58<5 || $dp478<5 || $dp5003<5 || $dp8112<5; # get sites that dp >= 5 
        next if $flag==1; # remove no diversity SNP
	next if $gt478 eq "0/1" ||  $gt58 eq "0/1" || $gt5003 eq "0/1" || $gt8112 eq "0/1"; # get sites that no hetro
	print;

}
close F;
