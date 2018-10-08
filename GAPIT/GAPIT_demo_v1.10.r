# GAPIT - GWAS and Genomic-selection in R
# Designed by Zhiwu Zhang
# Written by Zhiwu Zhang, Alex Lipka and Feng Tian 
# Last update: April 30, 2011 

#Step 0: Set directory to load GAPIT source files (this step is omited for using package)
#######################################################################################
#setwd("\\\\Parviglumis\\d\\manuscripts\\Alex\\GAPIT\\R")
setwd("C:\\Current\\Paper\\Alex\\GAPIT\\R")
library('MASS')
library(multtest)
#library(emma)
source("emma.R")

source("GAPIT_Functions_V1.23.r")
#source("http://www.maizegenetics.net/images/stories/interests/statgen/gapit_functions.txt")



#Step 1: Set data directory and import files
#######################################################################################
mydataPath="C:\\Current\\Paper\\Alex\\GGiR\\data\\Maize\\"

#Phenotypic Data
#myY  <- read.table(paste(mydataPath,"Phenotype_dpoll.txt",sep=""), head = TRUE)
myY  <- read.table(paste(mydataPath,"mdp_traits.txt",sep=""), head = TRUE)
#myY  <- read.table(paste(mydataPath,"all_outrem_lineavg.txt",sep=""), head = TRUE)
#myY  <- read.table(paste(mydataPath,"tassel_trait38.txt",sep=""), head = TRUE)

#Choose genotype in Hapmap format or EMMA format
#HapMap format
#--------------------single HapMap file--------------------------------------------------
myG <- read.table(paste(mydataPath,"mdp_genotype_test.hmp.txt" ,sep=""), head = FALSE)
#myG <- read.table(paste(mydataPath,"HiSeq_55K282_110221_imp1.txt" ,sep=""), head = FALSE)
#--------------------OR multiple HapMap file (a series of files)-------------------------
myGFile <- "mdp_genotype_test" #Common name of genotypic data file
myGFileExt <- "hmp.txt" #Name extention of genotypic data file

#EMMA format
#--------------------A pair of Genotypic Data and map files-------------------------------
myGD <- read.table(paste(mydataPath,"X_3122_SNPs.txt",sep=""), head = TRUE)
myGM <- read.table(paste(mydataPath,"IMPORTANT_Chromosome_BP_Location_of_SNPs.txt" ,sep=""), head = TRUE)
#--------------------OR a multiple pairs of Genotypic Data and map--- --------------------
myGDFile="X_3122_SNPs" #Common name of genotypic data file
myGMFile="IMPORTANT_Chromosome_BP_Location_of_SNPs" #Common name of genotypic informaton file
myGDFileExt="txt" 		
myGMFileExt="txt" 

#Kinship matrix
#myKI <- read.table(paste(mydataPath,"Kinship_Matrix_from_Maize_55K_SNPs.txt",sep=""), head = FALSE)
myKI <- read.table(paste(mydataPath,"KSN.txt",sep=""), head = FALSE)

#covaraite variables (such as population structure represented by Q matrix or PC)
myCV <- read.table(paste(mydataPath,"Copy of Q_First_Three_Principal_Components.txt",sep=""), head = TRUE)

#Z matrix.
myZ <- read.table(paste(mydataPath,"Z_Matrix.txt",sep=""), head = FALSE)

#Step 2: Set result directory and run GAPIT
#######################################################################################
setwd("C:\\Current\\Paper\\Alex\\GAPIT\\Result")

myGAPIT <- GAPIT(
Y=myY[,1:2],				#This is phenotype data
G=myG,				#This is genotype data,set it to NULL with multiple genotype files
#GD=myGD,
#GM=myGM,

#numFiles=0,		#Number of Genotype files
#dataPath=mydataPath,		#The location of genotype files

#GFile=myGFile,			#Common file name (before the numerical part), set it to NULL if for single file
#GFileExt=myGFileExt, 		#Common file extention (after the numerical part), set it to NULL if for single file

#GDFile=myGDFile,
#GMFile=myGMFile,
#GDFileExt=myGDFileExt, 		
#GMFileExt=myGMFileExt, 		

#KI=myKI,				#This is kinship data, set it to NULL in case that geneotype files are used for estimation
#CV=myCV,				#This is the covariate variables of fixed effects, such as population structure
#Z=myZ,				#This is the customized Z matrix

groupFrom=240,			#Lower bound for number of group
groupTo=240,			#Upper bound for number of group
#groupBy=10,				#rang between 1 and number of individuals, smaller the finner optimization 
#CA=c("average"), 			#clustering method: "average", "complete", "ward", "single", "mcquitty", "median","centroid". Example: CA=c("complete","average")
#KT=c("Mean"),     		#Group kinship tppe:  "Mean", "Max", "Min", "Median". Example: KT=c("Mean","Max")
#turnOnEMMAxP3D=TRUE,		#This is the option to use P3D (TRUE) or not (FALSE)

#model="Add", 			#Genetic model for SNP effect: "Add" or "Dom"
#MAF.Filter.Rate = 0.00,	#The SNP below this rate will be removed from reports
#FDR.Rate = 0.05,			#Alex will add explainatino
#Kinship.Method="Loiselle",	#The method to estimate kinship from genotype files. Options are "EMMA", "Loiselle"
numPCs=3				#Numer of PCS derived from genotype as population structure
)


#For debug use only
Y=myY
G=myG
GD=NULL
GM=NULL
KI=myKI
Z=myZ
CV=NULL
ngrids=100	#should be larger than one. The higher the finner optimization 
llim=-10
ulim=10
esp=1e-10
turnOnEMMAxP3D = TRUE # TURE to use EMMAx/P3D, FALSE for not to use
FDR.Rate = 0.05
FDR.Procedure = "BH" # Options are "BH" for Benjamini-Hochberg, and "BY" for Benjamini-Yekutieli
MAF.Filter.Rate = 0.00
FDR.Filter.Rate = 1
CA=c("average")
KT=c("Mean")
ca=CA
kt=KT
name.of.trait="DPOLL"
turnOnEMMAxP3D=TRUE
groupFrom=240	
groupTo=240
groupBy=10
GN=groupFrom
group=GN
trait=1
numFiles=0				#Number of Genotype files
dataPath=mydataPath
#GFile="mdp_genotype_test"				#Common file name (before the numerical part), set it to NULL if for single file
#GFileExt="hmp.txt" 		#Common file extention (after the numerical part), set it to NULL if for single file

GFile=NULL
GFileExt=NULL

GDFile=NULL
GMFile=NULL
GDFileExt=NULL	
GMFileExt=NULL

model="Add"
numPCs=3
Kinship.Method="Loiselle"
seed=123
ratio=1


