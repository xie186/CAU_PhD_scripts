#############################################$$
# Get the transcripts which are also 5:1
###############################################
#!/usr/bin/perl -w
use strict;
open SNP,$ARGV[0] or die;
while(my $aa=<SNP>){
    chomp $aa;
    my ($ies,$five)=(split(/\s+/,$aa))[0,-2];
    if($five eq "mat" || $five eq "pat"){
        print "$ies\t$five\n";
    }else{
        next;
    }
}
