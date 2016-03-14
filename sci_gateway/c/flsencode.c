/* ------------------------------------------------------------------------
 * This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
 * Copyright (C) @YEARS@ Jaime Urzua Grez
 * mailto:jaime_urzua@yahoo.com
 * 
 * 2011 Holger Nahrstaedt
 * ------------------------------------------------------------------------
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * ------------------------------------------------------------------------
 * CHANGES:
 * 2004-11-04 Delete some variable initialization, clean code
 *            Use more optimized memory subroutines
 * 2006-08-28 Use SCILAB memory allocation
 * ------------------------------------------------------------------------
 */

/*  
 * ------------------------------------------------------------------------
 * DESCRIPTION:
 * This routine is the computational part of:
 * (1) return an internal representation of a fls structure 
 * [mid1,mid2,mew,mrule,mdomo,mpari,mparo]=flsencode(fls)
 * (2) evaluate a fls
 * [y,tmp2]=evalfls(x,fls)
 * 
 * TYPE      DESCRIPTION
 * --------- -----------------------------------------
 * (double ) mdomo=matrix [nouputs,2] -> domain of outputs variables -> used in Mamdani case
 * (integer) mrule=matrix [nrules,ninputs+noutputs+1] -> fls.rule(:,1:(ninputs+noutputs+1)) but with member function id
 * (double ) mpari=matrix [4,ninputs*nrules] -> input member functions parameters
 * (double ) mparo=matrix [q,noutputs*nrules] q=4 if is mamdani or q=ninputs+1 if is takagi-sugeno
 * (double ) mew=matrix[nrules,1] -> fls.rule(:,$+1)
 * (integer) mid1=matrix [7,1]
 * (double ) mid2=matrix [3,1]
 * 
 * mid1(1)= { 0=m , 1=ts } -> fls.type
 * mid1(2)= { 0=dubois , 1=yager, 2=dsum , 3=esum  , 4=asum , 5=max } -> fls.SNorm
 * mid1(3)= { 0=dubois , 1=yager, 2=dprod, 3=eprod , 4=aprod, 5=min } -> fls.TNorm
 * mid1(4)= { 0=one, 1=yager, 2=sugeno } -> fls.Comp
 * mid1(5)= { 0=min, 1=prod } -> fls.ImpMethod
 * mid1(6)= { 0=max, 1=sum, 2=probor } -> fls.AggMethod
 * mid1(7)= { 0=centroide, 1=bisector, 2=mom, 3=som, 4=lom, 5=wtaver, 6=wtsum } -> fls.defuzzMethod
 * 
 * mid2(1) = fls.SNormPar;
 * mid2(2) = fls.TNormPar;
 * mid2(3) = fls.CompPar;
 * ------------------------------------------------------------------------ 
 */

#include <string.h>
#include "stack-c.h"
#include "api_scilab.h"
#include "Scierror.h"
#include "MALLOC.h"
#include <Scierror.h>
#include <sciprint.h>

#define sign(a) ((a) < 0 ? -1 : 1)
#define SCIFLT_DEFAULT_MAXNPEV 101
#define FLT_USESCIALLOC
/* -------------------------------------------------------------------------------------------------------- */
/* EXTERNAL                                                                                                 */
/* -------------------------------------------------------------------------------------------------------- */
extern int *listentry(int *header, int i);
//extern int MlistGetFieldNumber(int *ptr, const char *string);	


#define TRUE_ 1
#define FALSE_ 0

/* Table of constant values */

static int cx1 = 1;
static int c_n1 = -1;

int C2F(getfastcode)(unsigned char *c, unsigned long c_len) ;

/*------------------------------------------------
 *   converts from ascii to Scilab internal coding 
 *   call cvstr(n,line,str,job) 
 *   n: integer, length of the string to be converted entier 
 *   line: integer array (where Scilab coded string are stored ) 
 *   string: string 
 *   job: integer flag 
 *       1: code-->ascii 
 *       0: ascii-->code 
 *   Copyright INRIA/ENPC 
 ------------------------------------------------ */

int C2F(cvstr)(int * n,int * line,char * str,int * job,
	       unsigned long str_len)
{
  if (*job == 0) 
    C2F(asciitocode)(n, line, str, &cx1, str_len);
  else 
    C2F(codetoascii)(n, line, str, str_len);
  return 0;
} 

/*------------------------------------------------
 * very similar to cvstr but the conversion 
 * ascii->code is performed from end to the begining 
 ------------------------------------------------ */

int C2F(cvstr1)(int *n,int * line,char * str,int * job,
		unsigned long  str_len)
{
  if (*job == 0) 
    C2F(asciitocode)(n, line, str, &c_n1, str_len);
  else 
    C2F(codetoascii)(n, line, str, str_len);
  return 0;
} 

/*--------------------------------------------- 
 *   converts from Scilab internal coding to ascii 
 *   Copyright INRIA/ENPC 
 --------------------------------------------- */

int C2F(codetoascii)(int *n,int * line,char * str,
		     unsigned long str_len)
{
  static int eol = 99;
  int j, m;
  /*     conversion code ->ascii */
  for (j = 0; j < *n; ++j) {
    m = line[j];
    if (m == eol) 
      {
	str[j] = '!';
      } 
    else if (Abs(m) > csiz) 
      {
	if (m > eol) {
	  str[j] = (m - (eol + 1));
	} else {
	  str[j] = '!';
	}
      } 
    else if (m < 0) 
      {
	str[j] = C2F(cha1).alfb[Abs(m)];
      } 
    else
      {
	str[j] = C2F(cha1).alfa[m];
      }
  }
  return 0;
} 

/*--------------------------------------------- 
 *   converts from ascii to  Scilab internal coding 
 *   flag can be 1 or -1 and this is used when the 
 *   conversion is made with line and str stored at overlapping 
 *   memory zone 
 *   Copyright INRIA/ENPC 
 *--------------------------------------------- */

int C2F(asciitocode)(int * n,int * line,char * str,int * flagx,
		     unsigned long  str_len)
{
  int j;
  if (*flagx == 1) {
    for (j = 0; j < *n ; ++j) {
      line[j] = C2F(getfastcode)(str+j, 1L);
    }
  } else {
    for (j = *n -1 ; j >= 0; --j) {
      line[j] = C2F(getfastcode)(str+j, 1L);
    }
  }
  return 0;
} 

/*--------------------------------------------- 
 *   converts one ascii to Scilab internal code 
 *   Copyright INRIA/ENPC 
 *   Obsolete replaced by getfascode 
 *--------------------------------------------- */

int C2F(getcode)(unsigned char * mc,unsigned long mc_len)
{
  static int eol = 99;
  static int blank = 40;
  int k;
  for (k = 0 ; k < csiz; ++k) {
    if ( *mc == C2F(cha1).alfa[k]) 
      {
	return k ;
      }
    else if ( *mc == C2F(cha1).alfb[k]) {
      return - k;
    }
  }
  /*     special characters */
  switch ( *mc ) {
  case 0:  return  100; break; 
  case 9:  return 109; break; 
  case 10: return 110 ; break; 
  default : 
    return  *mc + eol + 1;
  }
} 



static int taba2s[128] = 
{ 100,101,102,103,104,105,106,107,108,-40,
  110,111,112,113,114,115,116,117,118,119,
 120,121,122,123,124,125,126,127,128,129,
 130,131, 40, 38,-53, 37, 39, 56, 58, 53,
  41, 42, 47, 45, 52, 46, 51, 48,  0,  1,
   2,  3,  4,  5,  6,  7,  8,  9, 44, 43,
  59, 50, 60,-38,-61,-10,-11,-12,-13,-14,
 -15,-16,-17,-18,-19,-20,-21,-22,-23,-24,
 -25,-26,-27,-28,-29,-30,-31,-32,-33,-34,
 -35, 54, 49, 55, 62, 36,-59, 10, 11, 12,
  13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
  23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
  33, 34, 35,-54, 57,-55, 61,227 };

/*--------------------------------------------------
 * Convert one ascii char to Scilab internal code 
 *     Copyright INRIA/ENPC 
 *      Modified by Bruno Pincon 
 *     the big table (pure) ascii -> scilab code 
 *--------------------------------------------------*/

int C2F(getfastcode)(unsigned char *c, unsigned long c_len) 
{
  int k = *c ;
  if (k <= 127) {
    return taba2s[*c];
  } else {
    return k + 100;
  }
} 


 int MlistGetFieldNumber(int *ptr, const char *string)
 {
         int nf = 0, longueur = 0, istart = 0, k = 0, ilocal = 0, retval = 0;
         int *headerstr = NULL;
         static char str[24];
 
         headerstr = listentry(ptr ,1);
         nf = headerstr[1] * headerstr[2] - 1;  /* number of fields */
         retval = -1;
         for (k=0; k<nf; k++) 
         {
                 longueur = Min( headerstr[6+k] - headerstr[5+k] , 24);  /* size of kth fieldname */
                 istart = 5 + nf + headerstr[5+k];    /* start of kth fieldname code */
 
                 C2F(cvstr)(&longueur, &headerstr[istart], str, (ilocal=1, &ilocal),longueur);
                 str[longueur] = '\0';
                 if (strcmp(string, str) == 0) 
                 {
                         retval = k + 2;
                         break;
                 }
         }
         return retval;
 }
 
 /* ---------------------------------------------------------------- */
/* INTERFACE TO flsencode                                           */
/* ---------------------------------------------------------------- */
int inter_flsencode(char * fname)
{
	CheckRhs(1,1);
	CheckLhs(7,7);
	/* flsencode routine have all */
	flsencode(0);
	return (0);
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO evalfls                                             */
/* ---------------------------------------------------------------- */
int inter_evalfls(char *fname)
{
	CheckRhs(2,3);
	CheckLhs(1,3);
	/* flsencode routine have all */
	flsencode(1);
	return (0);
}

/* -------------------------------------------------------------------------------------------------------- */
/* ENCODE ROUTINE                                                                                           */
/* -------------------------------------------------------------------------------------------------------- */

int flsencode(int mode)
{
	char chelem[50];
	int *header1,*element1,*header2,*header3,*element3,*element4,*element5;
	int field_num;

	double *mfpar, *range;
	int mdum,ndum,ncolmparo,i,j,k,one=1,nelem,ninputs,noutputs,nrules;
	double *mpari,*mparo;
	int nmf,nmfio,io,pt,pt2,idx1,idx2;
	double idx3=0.0;
	int mfid[2],field_number;
	int tofree[10];
	
	int mid1[7];
	double *mrule; //enable hedge
	double mid2[3],*mdomo,*mwe;
	int lmid1,lmid2,lmwe,lmrule,lmdomo,lmpari,lmparo;

	int npoints,nio,x,y,maxnpev,*npev,pevt,m1,n1,doal,cvy,ierr;
	double *tmp1,*tmp2,*tmp3,*tmp4;	
	int otmp2y,notmp2y;
	int otmp3y,notmp3y;
	int otmp4y,notmp4y;

	double dcero=0.0;
	int sz;
	
	/* ---------------------------------------------------------------------------- */
	/* INITIALIZE SOME VARIABLES                                                    */
	/* ---------------------------------------------------------------------------- */
	for (i=0;i<10;i++) { tofree[i]=0; }
	
	/* mid1 */
	for ( i=0;i<7; i++ ) { mid1[i]=0; }
	
	/* mid2 */
	for (i=0;i<3; i++ ) { mid2[i]=0.0; }

	/* ---------------------------------------------------------------------------- */
	/* GET THE STACK FLS INFORMATION                                                */
	/* ---------------------------------------------------------------------------- */
	if (mode==0) {		
		header1=(int*) GetData(1);
	} else if (mode==1) {
		header1=(int*) GetData(2);
	} else {
		sciFLT_doerror(0); goto goout;
	}
	if (header1[0]!=16) { sciFLT_doerror(1); goto goout; }
	
	/* ---------------------------------------------------------------------------- */
	/* GET THE TYPE                                                                 */
	/* ---------------------------------------------------------------------------- */
	field_num=MlistGetFieldNumber(header1,"type\0");
	if (field_num<1) { sciFLT_doerror(1); return 0; }
	element1=(int*) listentry(header1,field_num);
	if (element1[0]!=10) { sciFLT_doerror(11); return 0; }
	nelem=element1[5]-1;
	C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem,"m",1)==0) {
		/* MAMDANI */
		mid1[0]=0;		
	} else if (strncmp(chelem,"ts",2)==0) {
		/* TAKAGI-SUGENO */
		mid1[0]=1;
	} else {
		sciFLT_doerror(10);
		goto goout;
	}
	
	/* ---------------------------------------------------------------------------- */
	/* GET THE S-NORM                                                               */
	/* ---------------------------------------------------------------------------- */
	field_num=MlistGetFieldNumber(header1,"SNorm\0");
	if (field_num<1) { sciFLT_doerror(1); return 0; }
	element1=(int*) listentry(header1,field_num);
	if (element1[0]!=10) { sciFLT_doerror(21); return 0; }
	nelem=element1[5]-1;
	C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem,"dubois",6)==0) {
		/* DUBOIS-PRADE */
		mid1[1]=0;
	} else if (strncmp(chelem,"yager",5)==0) {
		/* YAGER */
		mid1[1]=1;
	} else if (strncmp(chelem,"dsum",4)==0) {
		/* DRASTIC SUM */
		mid1[1]=2;
	} else if (strncmp(chelem,"esum",4)==0) {
		/* EINSTEIN SUM */
		mid1[1]=3;
	} else if (strncmp(chelem,"asum",4)==0) {
		/* ALGEBRAIC SUM */
		mid1[1]=4;
	} else if (strncmp(chelem,"max",3)==0) {
		/* MAXIMUM */
		mid1[1]=5;
	} else {
		sciFLT_doerror(20);
		goto goout;
	}

	/* ---------------------------------------------------------------------------- */
	/* GET THE S-NORM PARAMETER                                                     */
	/* NEEDED IF S-NORM IS DUBOIS OR YAGER -> NO PARAMETER CHECK HERE               */
	/* ---------------------------------------------------------------------------- */
	if ((mid1[1]==0)|(mid1[1]==1)) {
		field_num=MlistGetFieldNumber(header1,"SNormPar\0");
		if (field_num<1) { sciFLT_doerror(1); return 0; }
		element1=(int*) listentry(header1,field_num);
		if (element1[0]!=1) { sciFLT_doerror(30); return 0; }
		/* IN CASE [] TAKE 0.0 as default */
		if (element1[1]>0) {
			mid2[0]=*((double*) (element1+4));
		} else {
			mid2[0]=0.0;
		}
	}

	/* ---------------------------------------------------------------------------- */
	/* GET THE T-NORM                                                               */
	/* ---------------------------------------------------------------------------- */
	field_num=MlistGetFieldNumber(header1,"TNorm\0");
	if (field_num<1) { sciFLT_doerror(1); return 0; }
	element1=(int*) listentry(header1,field_num);
	if (element1[0]!=10) { sciFLT_doerror(41); return 0; }
	nelem=element1[5]-1;
	C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem,"dubois",6)==0) {
		/* DUBOIS-PRADE */
		mid1[2]=0;
	} else if (strncmp(chelem,"yager",5)==0) {
		/* YAGER */
		mid1[2]=1;
	} else if (strncmp(chelem,"dprod",5)==0) {
		/* DRASTIC PRODUCT */
		mid1[2]=2;
	} else if (strncmp(chelem,"eprod",5)==0) {
		/* EINSTEIN PRODUCT */
		mid1[2]=3;
	} else if (strncmp(chelem,"aprod",5)==0) {
		/* ALGEBRAIC PRODUCT */
		mid1[2]=4;
	} else if (strncmp(chelem,"min",3)==0) {
		/* MINIMUM */
		mid1[2]=5;
	} else {
		sciFLT_doerror(40);
		goto goout;
	}

	/* ---------------------------------------------------------------------------- */
	/* GET THE T-NORM PARAMETER                                                     */
	/* NEEDED IF T-NORM IS DUBOIS OR YAGER -> NO PARAMETER CHECK HERE               */
	/* ---------------------------------------------------------------------------- */
	if ((mid1[2]==0)|(mid1[2]==1)) {
		field_num=MlistGetFieldNumber(header1,"TNormPar\0");
		if (field_num<1) { sciFLT_doerror(1); return 0; }
		element1=(int*) listentry(header1,field_num);
		if (element1[0]!=1) { sciFLT_doerror(50); return 0; }
		/* IN CASE [] TAKE 0.0 as default */
		if (element1[1]>0) {
			mid2[1]=*((double*) (element1+4));
		} else {
			mid2[1]=0.0;
		}
	}	

	/* ---------------------------------------------------------------------------- */
	/* GET THE COMPLEMENT                                                           */
	/* ---------------------------------------------------------------------------- */
	field_num=MlistGetFieldNumber(header1,"Comp\0");
	if (field_num<1) { sciFLT_doerror(1); return 0; }
	element1=(int*) listentry(header1,field_num);
	if (element1[0]!=10) { sciFLT_doerror(61); return 0; }
	nelem=element1[5]-1;
	C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem,"one",3)==0) {
		/* ONE -> CLASSIC */
		mid1[3]=0;
	} else if (strncmp(chelem,"yager",5)==0) {
		/* YAGER */
		mid1[3]=1;
	} else if (strncmp(chelem,"sugeno",6)==0) {
		/* SUGENO */
		mid1[3]=2;
	} else {
		sciFLT_doerror(60);
		goto goout;
	}

	/* ---------------------------------------------------------------------------- */
	/* GET THE COMPLEMENT PARAMETER                                                 */
	/* NEEDED IF COMPLEMENT IS YAGER OR SUGENO -> NO PARAMETER CHECK HERE           */
	/* ---------------------------------------------------------------------------- */
	if ((mid1[3]==1)|(mid1[3]==2)) {
		field_num=MlistGetFieldNumber(header1,"CompPar\0");
		if (field_num<1) { sciFLT_doerror(1); return 0; }
		element1=(int*) listentry(header1,field_num);
		if (element1[0]!=1) { sciFLT_doerror(70); return 0; }
		/* IN CASE [] TAKE 0.0 as default */
		if (element1[1]>0) {
			mid2[2]=*((double*) (element1+4));
		} else {
			mid2[2]=0.0;
		}
		
	}	

	/* ---------------------------------------------------------------------------- */
	/* GET THE IMPLICATION                                                          */
	/* NEEDED IF IS MAMDANI                                                         */
	/* ---------------------------------------------------------------------------- */
	if ( mid1[0]==0 ) {
		field_num=MlistGetFieldNumber(header1,"ImpMethod\0");
		if (field_num<1) { sciFLT_doerror(1); return 0; }
		element1=(int*) listentry(header1,field_num);
		if (element1[0]!=10) { sciFLT_doerror(81); return 0; }
		nelem=element1[5]-1;
		C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
		if (strncmp(chelem,"min",3)==0) {
			/* MINIMUM */
			mid1[4]=0;
		} else if (strncmp(chelem,"prod",4)==0) {
			/* PRODUCT */
			mid1[4]=1;
		} else if (strncmp(chelem,"eprod",5)==0) {
			/* PRODUCT */
			mid1[4]=2;
		} else {
			sciFLT_doerror(80);
			goto goout;
		}
	}

	/* ---------------------------------------------------------------------------- */
	/* GET THE AGGREGATION                                                          */
	/* NEEDED IF IS MAMDANI                                                         */
	/* ---------------------------------------------------------------------------- */
	if ( mid1[0]==0 ) {
		field_num=MlistGetFieldNumber(header1,"AggMethod\0");
		if (field_num<1) { sciFLT_doerror(1); return 0; }
		element1=(int*) listentry(header1,field_num);
		if (element1[0]!=10) { sciFLT_doerror(91); return 0; }
		nelem=element1[5]-1;
		C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
		if (strncmp(chelem,"max",3)==0) {
			/* MAXIMUM */
			mid1[5]=0;
		} else if (strncmp(chelem,"sum",3)==0) {
			/* SUM */
			mid1[5]=1;
		} else if (strncmp(chelem,"esum",4)==0) {
			/* Einstein SUM */
			mid1[5]=2;
		} else if (strncmp(chelem,"probor",6)==0) {
			/* PROBABILISTIC OR */
			mid1[5]=3;
		} else {
			sciFLT_doerror(90);
			goto goout;
		}
	}

	/* ---------------------------------------------------------------------------- */
	/* GET THE DEFUZZIFICATION                                                      */
	/* ---------------------------------------------------------------------------- */
	field_num=MlistGetFieldNumber(header1,"defuzzMethod\0");
	if (field_num<1) { sciFLT_doerror(1); return 0; }
	element1=(int*) listentry(header1,field_num);
	if (element1[0]!=10) { sciFLT_doerror(101); return 0; }
	nelem=element1[5]-1;
	C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem,"centroide",9)==0) {
		/* CENTROIDE */
		mid1[6]=0;
	} else if (strncmp(chelem,"bisector",8)==0) {
		/* BISECTOR */
		mid1[6]=1;
	} else if (strncmp(chelem,"mom",3)==0) {
		/* MEAN OF MAXIMUM */
		mid1[6]=2;
	} else if (strncmp(chelem,"som",3)==0) {
		/* SHORTEST OF MAXIMUM */
		mid1[6]=3;
	} else if (strncmp(chelem,"lom",3)==0) {
		/* LARGEST OF MAXIMUM */
		mid1[6]=4;
	} else if (strncmp(chelem,"wtaver",5)==0) {
		/* WEIGTHED AVERAGE */
		mid1[6]=5;
	} else if (strncmp(chelem,"wtsum",4)==0) {
		/* WEIGTHED SUM */
		mid1[6]=6;
	} else {
		sciFLT_doerror(100);
		goto goout;
	}
	/* CHECK DEFUZZIFICATION DUE THE FLS TYPE */
	if ((mid1[6]>4)&(mid1[0]==0)) { sciFLT_doerror(102); return 0; }
	if ((mid1[6]<5)&(mid1[0]==1)) { sciFLT_doerror(102); return 0; }


	/* ---------------------------------------------------------------------------- */
	/* GET THE NUMBER OF INPUTS AND OUTPUTS                                         */
	/* ---------------------------------------------------------------------------- */
	field_num=MlistGetFieldNumber(header1,"input\0");
	if (field_num<1) { sciFLT_doerror(1); return 0; }
	element1=(int*) listentry(header1,field_num);
	if (element1[0]!=15) { sciFLT_doerror(1); return 0; }
	ninputs=element1[1];
	field_num=MlistGetFieldNumber(header1,"output\0");
	if (field_num<1) { sciFLT_doerror(1); return 0; }
	element1=(int*) listentry(header1,field_num);
	if (element1[0]!=15) { sciFLT_doerror(1); return 0; }
	noutputs=element1[1];

	/* ---------------------------------------------------------------------------- */
	/* GET THE RULES AND TRANSFORM IT TO INTERNAL REPRESENTATION                    */
	/* ---------------------------------------------------------------------------- */	
	field_num=MlistGetFieldNumber(header1,"rule\0");
	if (field_num<1) { sciFLT_doerror(1); return 0; }
	element1=(int*) listentry(header1,field_num);
	if (element1[0]!=1) { sciFLT_doerror(1); return 0; }
	nrules=element1[1];
	if (element1[2]!=(ninputs+noutputs+2)) { sciFLT_doerror(111); return 0; }

	/* get the rules (hedges are supported now) */

	#ifdef FLT_USESCIALLOC
	mrule=(double*)MALLOC(nrules*(ninputs+noutputs+1)*sizeof(double));
	#else
	mrule=(double*)malloc(nrules*(ninputs+noutputs+1)*sizeof(double));
	#endif
	if (mrule==NULL) {
		sciFLT_doerror(999);
		goto goout;
	}
	tofree[0]=1;
	C2F(ddcopy)((double*)(element1+4),mrule,(sz=(ninputs+noutputs+1)*nrules,&sz));

	/* get the weigths */
	#ifdef FLT_USESCIALLOC	
	mwe=(double*)MALLOC(nrules*sizeof(double));
	#else
	mwe=(double*)malloc(nrules*sizeof(double));
	#endif
	if (mwe==NULL) {
		sciFLT_doerror(999);
		goto goout;
	}
	tofree[1]=1;
	C2F(getmw)((double*) (element1+4),&nrules,&ninputs,&noutputs,mwe);

	/* create matrix of input parameters and initializate */
	/* initialize because can appear some chunk when the user call to get the internal representation */
	#ifdef FLT_USESCIALLOC	
	mpari=(double*)MALLOC(ninputs*nrules*4*sizeof(double));
	#else
	mpari=(double*)malloc(ninputs*nrules*4*sizeof(double));
	#endif
	if (mpari==NULL) {
		sciFLT_doerror(999);
		goto goout;
	}
	tofree[2]=1;
	C2F(uinival)(mpari,(sz=ninputs*nrules*4,&sz),&dcero);
	
	/* create matrix of output parameters and initializate */
	/* initialize because can appear some chunk when the user call to get the internal representation */
	if (mid1[0]==0) {
		ncolmparo=4;
	} else {
		ncolmparo=ninputs+1;
	}
	#ifdef FLT_USESCIALLOC
	mparo=(double*)MALLOC(noutputs*nrules*ncolmparo*sizeof(double));
	#else
	mparo=(double*)malloc(noutputs*nrules*ncolmparo*sizeof(double));
	#endif
	if (mparo==NULL) {
		sciFLT_doerror(999);
		goto goout;
	}
	tofree[3]=1;
	C2F(uinival)(mparo,(sz=noutputs*nrules*ncolmparo,&sz),&dcero);

	/* create matrix for output domain */

	#ifdef FLT_USESCIALLOC
	mdomo=(double*)MALLOC(noutputs*2*sizeof(double));
	#else
	mdomo=(double*)malloc(noutputs*2*sizeof(double));
	#endif
	if (mdomo==NULL) {
		sciFLT_doerror(999);
		goto goout;
	}
	tofree[4]=1;

	/* work with the inputs and outputs */
	for (io=0;io<2;io++) {
		if (io==0) {
			field_num=MlistGetFieldNumber(header1,"input\0");
			nmfio=ninputs;
		} else {
			field_num=MlistGetFieldNumber(header1,"output\0");
			nmfio=noutputs;
		}
		header2=(int*) listentry(header1,field_num);
		for (i=0;i<nmfio;i++) {
			/* get the input/output number i+1 */
			header3=(int*) listentry(header2,i+1);
			if (header3[0]!=16) { sciFLT_doerror(1); goto goout; }
		
			/* get the range --> only the outputs*/
			if (io==1) {				
				field_num=MlistGetFieldNumber(header3,"range\0");
				if (field_num<1) { sciFLT_doerror(1); goto goout; }
				element3=(int*) listentry(header3,field_num);
				if ((element3[0]!=1)|(element3[1]*element3[2]!=2)) { sciFLT_doerror(120); goto goout; }
				range=((double*) (element3+4));
				mdomo[i]=range[0];
				mdomo[i+nmfio]=range[1];
			}

			/* get the number of member functions */
			field_num=MlistGetFieldNumber(header3,"mf\0");
			if (field_num<1) { sciFLT_doerror(1); goto goout; }
			element3=(int*) listentry(header3,field_num);
			if (element3[0]!=15) { sciFLT_doerror(1); goto goout; }
			nmf=element3[1];

			/* parse the rules and parse the member functions parameters */
			for (j=0;j<nrules;j++) {
				if (io==0) {
					pt=nrules*i+j;
				} else {
					pt=(nrules)*(i+ninputs)+j;
				}
				
				idx1=floor(abs(mrule[pt]));
				idx2=sign(mrule[pt]);
				 if (mrule[pt] < 0.0)
				  idx3=mrule[pt]-ceil( mrule[pt] );
				else
				  idx3=mrule[pt]-floor( mrule[pt] );
				
				if (idx1>floor(nmf)) { sciFLT_doerror(112); goto goout; }				
				/* take the idx member function */
				if (idx1!=0) {
					element4=(int*) listentry(element3,idx1);
					if (element4[0]!=16) { sciFLT_doerror(1); goto goout; }
					field_number=MlistGetFieldNumber(element4,"type\0");
					if (field_number<1) { sciFLT_doerror(1); goto goout; }
					element5=(int*) listentry(element4,field_number);
					if (element5[0]!=10) { sciFLT_doerror(130); goto goout; }
					nelem=element5[5]-1;

					/* check member function type */					
					C2F(cvstr)(&nelem,&element5[6],chelem,&one,nelem);
					if (strncmp(chelem,"trimf",5)==0) {
						mfid[0]=1;mfid[1]=3;
					} else if (strncmp(chelem,"trapmf",6)==0) {
						mfid[0]=2;mfid[1]=4;
					} else if (strncmp(chelem,"gaussmf",7)==0) {
						mfid[0]=3;mfid[1]=2;
					} else if (strncmp(chelem,"gauss2mf",8)==0) {
						mfid[0]=4;mfid[1]=4;
					} else if (strncmp(chelem,"sigmf",5)==0) {
						mfid[0]=5;mfid[1]=2;
					} else if (strncmp(chelem,"psigmf",6)==0) {
						mfid[0]=6;mfid[1]=4;
					} else if (strncmp(chelem,"dsigmf",6)==0) {
						mfid[0]=7;mfid[1]=4;
					} else if (strncmp(chelem,"gbellmf",7)==0) {
						mfid[0]=8;mfid[1]=3;
					} else if (strncmp(chelem,"pimf",4)==0) {
						mfid[0]=9;mfid[1]=4;
					} else if (strncmp(chelem,"smf",3)==0) {
						mfid[0]=10;mfid[1]=2;
					} else if (strncmp(chelem,"zmf",3)==0) {
						mfid[0]=11;mfid[1]=2;
					} else if (strncmp(chelem,"constant",8)==0) {
						mfid[0]=12;mfid[1]=1;
					} else if (strncmp(chelem,"linear",6)==0) {
						mfid[0]=13;mfid[1]=ninputs+1;
					} else {
						sciFLT_doerror(131);
						goto goout;
					}

					/* check if member function is good in the IF or THEN part */
					if ((io==0)&(mfid[0]>11)) {
						sciFLT_doerror(132);
						goto goout;
					}
					if ((io==1)&(mfid[0]<12)&(mid1[0]==1)) {
						sciFLT_doerror(132);
						goto goout;
					}

					/* parse member function and parameter */
					mrule[pt]=mfid[0]*idx2+idx3;
					field_number=MlistGetFieldNumber(element4,"par\0");
					if (field_number<1) { sciFLT_doerror(1); goto goout; }					
					element5=(int*) listentry(element4,field_number);
					if (element5[0]!=1) { sciFLT_doerror(140); goto goout; }
					if (element5[2]!=mfid[1]) { sciFLT_doerror(141); goto goout; }
					mfpar=((double*) (element5+4));

					if (io==0) {
						for (k=0; k<mfid[1]; k++) {
							pt2=(i*nrules+j)*4+k;
							mpari[pt2]=mfpar[k];
						}
					} else {
						for (k=0;k<mfid[1]; k++) {
							pt2=(i*nrules+j)*ncolmparo+k;
							mparo[pt2]=mfpar[k];
						}						
					}
					
				}
			}
		}
	}
	
	
	/* ---------------------------------------------------------------------------- */
	/* MAKE THE REAL WORK                                                           */
	/* ---------------------------------------------------------------------------- */
	if (mode==0) {
		/* ---------------------------------------------------------------------------- */
		/* THIS IS THE CASE WHEN THE USER NEED THE INTERNAL REPRESENTATION              */
		/* ---------------------------------------------------------------------------- */
		
		/* mid1 */
		CreateVar(2,"d",(mdum=7,&mdum),&one,&lmid1);
		C2F(idcopy)(mid1,stk(lmid1),(sz=7,&sz));		

		/* mid2 */
		CreateVar(3,"d",(mdum=3,&mdum),&one,&lmid2);
		C2F(dcopy)((mdum=3,&mdum),mid2,&one,stk(lmid2),&one);

		/* mew */
		CreateVar(4,"d",&nrules,&one,&lmwe);
		C2F(dcopy)((mdum=nrules,&mdum),mwe,&one,stk(lmwe),&one);		

		/* mrule */
		CreateVar(5,"d",&nrules,(ndum=ninputs+noutputs+1,&ndum),&lmrule);
		//C2F(idcopy)(mrule,stk(lmrule),(sz=nrules*(ninputs+noutputs+1),&sz));
		C2F(dcopy)((mdum=nrules*(ninputs+noutputs+1),&mdum),mrule,&one,stk(lmrule),&one);
		
		/* mdomo */
		CreateVar(6,"d",&noutputs,(ndum=2,&ndum),&lmdomo);
		C2F(dcopy)((mdum=noutputs*2,&mdum),mdomo,&one,stk(lmdomo),&one);

		/* mpari */
		CreateVar(7,"d",(mdum=4,&mdum),(ndum=ninputs*nrules,&ndum),&lmpari);
		C2F(dcopy)((mdum=ninputs*nrules*4,&mdum),mpari,&one,stk(lmpari),&one);

		/* mparo */
		CreateVar(8,"d",&ncolmparo,(ndum=noutputs*nrules,&ndum),&lmparo);
		C2F(dcopy)((mdum=ninputs*nrules*ncolmparo,&mdum),mparo,&one,stk(lmparo),&one);		

		LhsVar(1)=2;
		LhsVar(2)=3;
		LhsVar(3)=4;
		LhsVar(4)=5;
		LhsVar(5)=6;
		LhsVar(6)=7;
		LhsVar(7)=8;
		
	} else {
		/* --------------------------------------------------------------------- */
		/* THIS IS THE FLS EVALUATION CASE                                       */
		/* --------------------------------------------------------------------- */

		/* get x from the first position in the stack */
		GetRhsVar(1,"d",&npoints,&nio,&x);
		
		/* check size */
		if (nio!=ninputs) { sciFLT_doerror(200); goto goout; }
		
		/* if the system is mamdani the take the number of points to evaluate */
		/* from the third position in the stack                               */
		cvy=3;
		maxnpev=SCIFLT_DEFAULT_MAXNPEV;
		if (mid1[0]==0) {
			doal=1;
			#ifdef FLT_USESCIALLOC
			npev=(int*)MALLOC(noutputs*sizeof(int));
			#else
			npev=(int*)malloc(noutputs*sizeof(int));
			#endif
			if (npev==NULL) { sciFLT_doerror(999);	goto goout; }
			tofree[5]=1;
			
			if (Rhs>2) {
				cvy=4;
				GetRhsVar(3,"d",&m1,&n1,&pevt);
				if (m1*n1==1) {
					for (i=0;i<noutputs;i++) {
						npev[i]=(int)(*stk(pevt));
					}
				} else if (m1*n1!=noutputs) {
					sciFLT_doerror(210);
					goto goout;
				} else {
					for (i=0;i<noutputs;i++) {
						npev[i]=(int)(*stk(pevt+i));
					}
				}
			} else {
				for (i=0;i<noutputs;i++) {
					npev[i]=maxnpev;
				}
			}

			maxnpev=0;
			for (i=0;i<noutputs;i++) {
				if (npev[i]<1) {
					sciFLT_doerror(211);
					goto goout;
				}
				if (npev[i]>maxnpev) maxnpev=npev[i];
			}
		}

		/* CREATE THE OUTPUT */
		CreateVar(cvy,"d",&npoints,&noutputs,&y);

		/* CREATE SOME EXTRA VARS */
		
		/* tmp1 */
		#ifdef FLT_USESCIALLOC		
		tmp1=(double*)MALLOC(npoints*ninputs*sizeof(double));
		#else
		tmp1=(double*)malloc(npoints*ninputs*sizeof(double));
		#endif
		if (tmp1==NULL) { sciFLT_doerror(999);	goto goout; }
		tofree[6]=1;
		
		/* tmp2 */
		#ifdef FLT_USESCIALLOC
		tmp2=(double*)MALLOC(npoints*nrules*noutputs*sizeof(double));
		#else
		tmp2=(double*)malloc(npoints*nrules*noutputs*sizeof(double));
		#endif
		if (tmp2==NULL) { sciFLT_doerror(999); goto goout; }
		tofree[7]=1;

		/* tmp3 -> TAKAGI-SUGENO CASE IS RELEVANT */
		if (mid1[0]==1) {
			#ifdef FLT_USESCIALLOC
			tmp3=(double*)MALLOC(npoints*sizeof(double));
			#else
			tmp3=(double*)malloc(npoints*sizeof(double));
			#endif
			if (tmp3==NULL) { sciFLT_doerror(999);	goto goout; }
			tofree[8]=1;
			#ifdef FLT_USESCIALLOC
			tmp4=(double*)MALLOC(sizeof(double)); /* 1 DUMMY */
			#else
			tmp4=(double*)malloc(sizeof(double)); /* 1 DUMMY */
			#endif
			if (tmp4==NULL) { sciFLT_doerror(999);	goto goout; }
			tofree[9]=1;
		}
		
		/* tmp4 -> MAMDANI CASE IS RELEVANT */
		if (mid1[0]==0) {
			#ifdef FLT_USESCIALLOC
			tmp3=(double*)MALLOC(sizeof(double)); /* 1 DUMMY */
			#else
			tmp3=(double*)malloc(sizeof(double)); /* 1 DUMMY */
			#endif
			if (tmp3==NULL) { sciFLT_doerror(999);	goto goout; }
			tofree[8]=1;
			#ifdef FLT_USESCIALLOC
			tmp4=(double*)MALLOC(maxnpev*3*sizeof(double));
			#else
			tmp4=(double*)malloc(maxnpev*3*sizeof(double));
			#endif
			if (tmp4==NULL) { sciFLT_doerror(999);	goto goout; }
			tofree[9]=1;
		}
		
		/* NOW I CALL THE ROUTINE */
		C2F(flsengine)(stk(x),mid1,mid2,mwe,mrule,mdomo,mpari,mparo,&ncolmparo,npev,&ninputs,&noutputs,&nrules,&npoints,tmp1,tmp2,tmp3,tmp4,&maxnpev,stk(y),&ierr);
		if (ierr==0) {
			LhsVar(1)=cvy;
			if (Lhs>=2) {
			        int tmp=nrules*noutputs;
				CreateVar(cvy+1,"d",&npoints,&tmp,&otmp2y);
				C2F(dcopy)((notmp2y=npoints*nrules*noutputs,&notmp2y),tmp2,&one,stk(otmp2y),&one);
				LhsVar(2)=cvy+1;
			}
			
			if (Lhs>=3) {
			   if (mid1[0]==0) {
				int three=3;
				CreateVar(cvy+2,"d",&maxnpev,&three,&otmp4y);
				C2F(dcopy)((notmp4y=maxnpev*3,&notmp4y),tmp4,&one,stk(otmp4y),&one);
				LhsVar(3)=cvy+2;
			   }else {
				CreateVar(cvy+2,"d",&npoints,&one,&otmp3y);
				C2F(dcopy)((notmp3y=npoints,&notmp3y),tmp3,&one,stk(otmp3y),&one);
				LhsVar(3)=cvy+2;
			   }
			  
			}
		}				
	}

	/* FREE */
goout:
	#ifndef FLT_USESCIALLOC
	if (tofree[0]==1) {free(mrule); }
	if (tofree[1]==1) {free(mwe);   }
	if (tofree[2]==1) {free(mpari); }
	if (tofree[3]==1) {free(mparo); }
	if (tofree[4]==1) {free(mdomo); }
	if (tofree[5]==1) {free(npev);  }
	if (tofree[6]==1) {free(tmp1);  }
	if (tofree[7]==1) {free(tmp2);  }
	if (tofree[8]==1) {free(tmp3);  }
	if (tofree[9]==1) {free(tmp4);  }
	#else
	if (tofree[0]==1) {FREE(mrule); }
	if (tofree[1]==1) {FREE(mwe);   }
	if (tofree[2]==1) {FREE(mpari); }
	if (tofree[3]==1) {FREE(mparo); }
	if (tofree[4]==1) {FREE(mdomo); }
	if (tofree[5]==1) {FREE(npev);  }
	if (tofree[6]==1) {FREE(tmp1);  }
	if (tofree[7]==1) {FREE(tmp2);  }
	if (tofree[8]==1) {FREE(tmp3);  }
	if (tofree[9]==1) {FREE(tmp4);  }
	#endif

	return 0;				 
}

