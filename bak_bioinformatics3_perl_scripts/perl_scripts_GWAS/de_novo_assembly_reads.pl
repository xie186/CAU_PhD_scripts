#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($clus, $prop_cut,$gene, $ge_pos,$bam_pwd) = @ARGV;
open GENE,$ge_pos, or die "$!";
my $gene_pos = 0;
while(<GENE>){
    my ($chr,$stt,$end,$tem_gene) = split;
       $chr = "chr".$chr if $chr !~ /chr/;
      ($stt,$end) = ($stt - 2000, $end + 2000);
    $gene_pos = "$chr:$stt-$end" if $gene eq $tem_gene;
}
open CLUS,$clus or die "$!";
my $haplo_group = 1;
my %hash_group;
while(<CLUS>){
    chomp;
    my($id1,$id2,$prop,$tot_inbred,$inbred_name)  = split;
    next if $prop < $prop_cut;
    my @inbred_name = split(/-/,$inbred_name);
    push @{$hash_group{$haplo_group}},@inbred_name;
    ++ $haplo_group;
}

foreach my $group(keys %hash_group){
    my %hash_read;
    foreach my $inbred( @{$hash_group{$group}}){
        print "group$group\t$inbred\n";
        my $tem_inbred = $inbred;
           $tem_inbred =~ s/CAU0/CAU/;
        if(-e "$bam_pwd/$inbred.sorted.picard.bam"){
            open SAM,"samtools view -q 20 $bam_pwd/$inbred.sorted.picard.bam $gene_pos |" or die "$!";
            while(my $read = <SAM>){
                chomp $read;
                my ($read_id,$flag,$seq,$qual) = (split(/\t/,$read))[0,1,9,10];
                my ($pe_sin,$fir_sec,$rev_for) = &flager($flag);
                if($rev_for =~ /reverse/){
                    $seq = reverse $seq;$seq =~ tr/ATGC/TACG/;$qual = reverse $qual;
                }
                if($fir_sec =~ /second/){
                    unshift @{$hash_read{$read_id}} , "$seq\n+\n$qual";
                }else{
                    push @{$hash_read{$read_id}} , "$seq\n+\n$qual";
                }
             }
        }
        
        if(!-e "$bam_pwd/$inbred.sorted.picard.bam" && -e "$bam_pwd/$tem_inbred.sorted.picard.bam"){
            open SAM,"samtools view -q 20 $bam_pwd/$tem_inbred.sorted.picard.bam $gene_pos |" or die "$!";
            while(my $read = <SAM>){
                chomp $read;
                my ($read_id,$flag,$seq,$qual) = (split(/\t/,$read))[0,1,9,10];
                my ($pe_sin,$fir_sec,$rev_for) = &flager($flag);
                if($rev_for =~ /reverse/){
                    $seq = reverse $seq;$seq =~ tr/ATGC/TACG/;$qual = reverse $qual;
                }
                if($fir_sec =~ /second/){
                    unshift @{$hash_read{$read_id}} , "$seq\n+\n$qual";
                }else{
                    push @{$hash_read{$read_id}} , "$seq\n+\n$qual";
                }
            }
        }
        
    }
    `mkdir tem_fq` if (!-e "tem_fq");
     open MER,"+>./tem_fq/$gene\_group$group.fq"  or die "$!";
     open READ1,"+>./tem_fq/$gene\_group$group\_1.fq" or die "$!";
     open READ2,"+>./tem_fq/$gene\_group$group\_2.fq" or die "$!";
     foreach(keys %hash_read){
         my $nu = @{$hash_read{$_}};
         if($nu == 2){
                print MER "\@$_\n$hash_read{$_}[0]\n\@$_\n$hash_read{$_}[1]\n";
                print READ1 "\@$_\n$hash_read{$_}[0]\n";
                print READ2 "\@$_\n$hash_read{$_}[1]\n";
         }else{
                print MER "\@$_\n$hash_read{$_}[0]\n";
         }
    }
    &trim_single("./tem_fq/$gene\_group$group.fq","./tem_fq/$gene\_group$group.fa");
    &trim_paired("./tem_fq/$gene\_group$group\_1.fq","./tem_fq/$gene\_group$group\_2.fq","./tem_fq/$gene\_group$group\_1.fa","./tem_fq/$gene\_group$group\_2.fa");
    `rm *trimmed*`;
} 

sub trim_single{
    my ($read,$out_fa) = @_;
    system("perl /NAS1/software/SolexaQA_1.12/DynamicTrim.pl $read");
    open FA,"+>$out_fa" or die "$!";
    my $tem = $read;
       $tem =~ s/tem_fq\///;
    open TRIM,"$tem.trimmed" or die "$!";
    while(my $id = <TRIM>){
#        chomp $id;
        my $seq = <TRIM>;
        <TRIM>;<TRIM>;
        print FA ">$id"."$seq";
    }
    close FA;
    close TRIM;
#    system("rm $read $read.trimmed");
}

sub trim_paired{
    my ($read1,$read2,$out_fa1,$out_fa2) = @_;
    system("perl /NAS1/software/SolexaQA_1.12/DynamicTrim.pl $read1");
    system("perl /NAS1/software/SolexaQA_1.12/DynamicTrim.pl $read2");
    my $tem1 = $read1;
       $tem1 =~ s/tem_fq\///;
    my $tem2 = $read2;
       $tem2 =~ s/tem_fq\///;
    system("perl /NAS1/software/SolexaQA_1.12/LengthSort.pl $tem1.trimmed $tem2.trimmed");
    open FA,"+>$out_fa1" or die "$!";
    open TRIM,"$tem1.trimmed.paired1" or die "$!";
    while(my $id = <TRIM>){
        my $seq = <TRIM>;
        <TRIM>;<TRIM>;
        print FA ">$id"."$seq";
    }
    close FA;
    close TRIM;

    open FA,"+>$out_fa2" or die "$!";
    open TRIM,"$tem1.trimmed.paired2" or die "$!";
    while(my $id = <TRIM>){
        my $seq = <TRIM>;
        <TRIM>;<TRIM>;
        print FA ">$id"."$seq";
    }
    close FA;
    close TRIM;
#    system("rm *trimmed* $prefix*fq");
}

sub flager{
    my $bam_flag = shift @_;
    my $binary = dec2bin($bam_flag);
       $binary = reverse($binary);
    my @desc = (
       'The read is paired in sequencing',
       'The read is mapped in a proper pair',
	'The query sequence itself is unmapped',
	'The mate is unmapped',
	'strand of the query',
	'strand of the mate',
	'The read is the first read in a pair',
	'The read is the second read in a pair',
	'The alignment is not primery (a read having split hits may have multiple primary alignment records)',
	'The read fails quality checks',
	'The read is either a PCR duplicate or an optical duplicate',
	);
#     print "$binary\n";
     my ($pe_sin,$fir_sec,$rev_for) = (0,0,0);
     my $query_mapped = '0';
     my $mate_mapped = '0';
     my $proper_pair = '0';
     for (my $i=0; $i< length($binary); ++$i){
         my $flag = substr($binary,$i,1);
         #print "\$i = $i and \$flag = $flag\n";
         if ($i == 1){
             if ($flag == 1){
                 $proper_pair = '1';
             }
         }
         if ($i == 2){
             if ($flag == 0){
                  $query_mapped = '1';
             }
         }
         if ($i == 3){
             if ($flag == 0){
                 $mate_mapped = '1';
             }
         } 
         if ($i == 4){
             next if $query_mapped == 0;
             if ($flag == 0){
#                 print "The read is mapped on the forward strand\n";
                 $rev_for = "The read is mapped on the forward strand\n";
             } else {
#                 print "The read is mapped on the reverse strand\n";
                 $rev_for = "The read is mapped on the reverse strand\n";
             }
         } elsif ($i == 5){
             next if $mate_mapped == 0;
             next if $proper_pair == 0;
             if ($flag == 0){
#                 print "The mate is mapped on the forward strand\n";
             } else {
#                 print "The mate is mapped on the reverse strand\n";
             }
        } else {
             if ($flag == 1){
#                 print "$desc[$i]\n";
                 $pe_sin = $desc[$i] if $i == 0;
                 $fir_sec = $desc[$i] if $i == 6;
                 $fir_sec = $desc[$i] if $i == 7;
             }
        }
    }
    return ($pe_sin,$fir_sec,$rev_for);
}

#from The Perl Cookbook
sub dec2bin {
   my $str = unpack("B32", pack("N", shift));
   $str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
   return $str;
}

sub usage{
    my $die =<<DIE;
    perl *.pl  <clust>  <percentage cutoff> <gene> <gene position> <bam file dir>
DIE
}
