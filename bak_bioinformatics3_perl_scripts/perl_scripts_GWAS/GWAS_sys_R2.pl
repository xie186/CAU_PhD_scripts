#!/usr/bin/perl -w
die usage() unless @ARGV == 8;
my ($pheno_dir,$res_dir,$data_path,$prefix,$sufix,$kinship,$pca,$num_file) = @ARGV;
my @file = glob("$pheno_dir/*.pheno");
foreach (@file){
    print "## $_\n";
    my @tem_pwd = (split/\//,$_);
    system "mkdir $res_dir" if !-e $res_dir;
    system "mkdir $res_dir/$tem_pwd[-1]" if !-e "$res_dir/$tem_pwd[-1]";
    open R, "+>$_.R2";
    print R "setwd(\"/NAS2/jiaoyp/GWAS/GAPIT\")\n";
    print R "library('MASS')\n";
    print R "library(multtest)\n";
    print R "source(\"emma.R\")\n";
    print R "source(\"GAPIT_Functions_V1.23.r\")\n";
 
    print R "myY <- read.table(\"$_\",sep=\"\", head = TRUE)\n";
    print R "myGFile <-\"$prefix\"\n";  ## 628lines.non_imputation- 
    print R "myGFileExt <- \"$sufix\"\n";  ## hapmap
    print R "myKI <- read.table(\"$kinship\",sep=\"\", head = FALSE)\n";  
    ### /NAS2/zeamxie/jiaoyp/GWAS_un_impute/628lines.pca 
    print R "myCV <- read.table(\"$pca\",sep=\"\", head = TRUE)\n";  

    print R "setwd(\"$res_dir/$tem_pwd[-1]\")\n";
    print R "myGAPIT <- GAPIT(Y=myY,GFile=myGFile,GFileExt=myGFileExt,dataPath=\"$data_path/\",numFile=$num_file,KI=myKI,CV=myCV,turnOnEMMAxP3D=TRUE)\n";
    close R;
    print "/NAS2/jiaoyp/software/R-2.15.1/bin/R --vanilla --slave < $_.R2 > $_.GAPIT.nohup\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <pheno dir> <Result dir> <hapmap pwd> <hapmap_prefix> <hapmap_sufix> <kinship> <pca> <# of hapmap file>
DIE
}
