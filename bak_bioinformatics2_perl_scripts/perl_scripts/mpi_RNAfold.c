/* This program needs at least 2 cores */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#define MPI
#ifdef MPI
#include "mpi.h"
#define comm MPI_COMM_WORLD
#endif

static char workdir[100]="/home/bioinformatics2/zeamxie/bismark_map/smRNA/RNAfold/";
static char queryname[50]="test.forRNAfold";
/*static char libname[50]="";*/
static char outname[50]="test.forRNAfold.res";
static char num[50]="sequence.num";

int main(int argc, char *argv[])
{  
	char cmd[200],inquery[100],indb[100],output[100],line[200],temp[100],rankfilename[100],rankoutname[100];
	int i,j,seqnum,ss,resd,rankshare[9999];
	FILE *Infile;
    FILE *Numfile;
	FILE *Rankfile;

	/* for MPI */
    int np,rank;
	double start,end;

    /* MPI init */
    MPI_Init(&argc,&argv);
    MPI_Comm_size(comm, &np);
    MPI_Comm_rank(comm, &rank);
		
    start=MPI_Wtime();
	strcpy(inquery,workdir);
	strcat(inquery,queryname);
//	strcpy(indb,workdir);
//	strcat(indb,libname);
	strcpy(output,workdir);
	strcat(output,outname);
	
	if(rank==0)
    {
		/* get number of sequences in queryfile */
	    sprintf(cmd,"grep -c '>' %s > %s",inquery,num);
		system(cmd);
	    Numfile=fopen(num,"r");
        fgets(line,100,Numfile);
	    sscanf(line,"%d",&seqnum);
        fclose(Numfile);
        sprintf(cmd,"rm %s",num);
        system(cmd);

        /* how many sequences will be distributed for each processor */
		ss=seqnum/np;
		resd=seqnum%np;
        for(i=0;i<np;i++)
		{
			if(i<resd)
				rankshare[i] = ss+1;
			else
				rankshare[i] = ss;
		}

		/* partition sequences of query file into np sub-files */
		Infile=fopen(inquery,"r");
		for(i=0;i<np;i++)
		{
			sprintf(temp,"%d",i);
            strcpy(rankfilename,inquery);
			strcat(rankfilename,".");
			strcat(rankfilename,temp);
            printf("Rank:%d.....file name:%s\n",i,rankfilename);
        
            Rankfile=fopen(rankfilename,"w");
            for(j=1;j<=rankshare[i]*2;j++)
          	{
			   fgets(line,200,Infile);
			   fputs(line,Rankfile);		           
			}
    	}   
        fclose(Infile);
		fclose(Rankfile);
		printf("processor 0 finishes partition\n");
	}

	MPI_Barrier(comm);
    
	/* each processor gets its infile and outfile names after partition */
	sprintf(temp,"%d",rank);
    strcpy(rankfilename,inquery);
	strcat(rankfilename,".");
	strcat(rankfilename,temp);
    strcpy(rankoutname,rankfilename);
	strcat(rankoutname,".out");


    /* each processor executes */
    sprintf(cmd,"RNAfold --noPS < %s > %s",rankfilename,rankoutname);
	printf("processor %d... %s",rank,cmd);
	system(cmd);
    sprintf(cmd,"rm %s",rankfilename);
    system(cmd);

    MPI_Barrier(comm);

    if(rank==0)
	{
		for(i=0;i<np;i++)
		{
			sprintf(temp,"%d",i);
			strcpy(rankoutname,inquery);
			strcat(rankoutname,".");
			strcat(rankoutname,temp);
			strcat(rankoutname,".out");
			sprintf(cmd,"cat %s >> %s",rankoutname,output);
			system(cmd);
			sprintf(cmd,"rm %s",rankoutname);  
			system(cmd);
		}
	}

    end=MPI_Wtime();
	MPI_Finalize();
	printf("\nProcessor %d, total processing time=%f \n",rank,end-start);
	return 0;
}
