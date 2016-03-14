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
// #include "cvstr.h"
// #include "core_math.h"

//#include "sciFLT.h"

#define sign(a) ((a) < 0 ? -1 : 1)
#define SCIFLT_MAXNPEV 1001
#define FLT_USESCIALLOC
/* -------------------------------------------------------------------------------------------------------- */
/* EXTERNAL                                                                                                 */
/* -------------------------------------------------------------------------------------------------------- */
extern int *listentry(int *header, int i);
//extern int MlistGetFieldNumber(int *ptr, const char *string);	


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
 
 /*******************************************************/
// Help functions

int find_label(char **LabelList, int nblabels, const char *LabelToFind)
{
 int Pos = -1, i;

 for(i=0; i<nblabels; i++)
   {
     if (strcmp(LabelList[i],LabelToFind)==0)
    {
     Pos = i;
     //printf("found label %s at %d\n",LabelToFind,Pos);
     return Pos;
    }
   }
  
 return Pos;
}

// int read_string(char **pstData, int* _piParent, int _iItemPos)
// {
// SciErr sciErr;
// 	int i;
// 	int iRows       = 0;
// 	int iCols       = 0;
// 	int* piLen      = NULL;
// 
// 	//pstData  = NULL;
//            sciErr = getMatrixOfStringInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, NULL, NULL);
// 		if(sciErr.iErr)
// 		{
// 			printError(&sciErr, 0);
// 			return 0;
// 		}
// 
// 		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
// 		sciErr = getMatrixOfStringInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, piLen, NULL);
// 		if(sciErr.iErr)
// 		{
// 			printError(&sciErr, 0);
// 			return 0;
// 		}
// 
// 		pstData = (char**)malloc(sizeof(char*) * iRows * iCols);
// 		for(i = 0 ; i < iRows * iCols ; i++)
// 		{
// 			pstData[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
// 		}
// 
// 		sciErr = getMatrixOfStringInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, piLen, pstData);
// 		if(sciErr.iErr)
// 		{
// 			printError(&sciErr, 0);
// 			return 0;
// 		}
// 		free(piLen);
// 		
// 
// 		  printf("string: %s \n",pstData[0]);
//  return 0;
// }



/* ---------------------------------------------------------------- */
/* INTERFACE TO flsencode                                           */
/* ---------------------------------------------------------------- */
int inter_flsencode(char * fname)
{
	CheckRhs(1,1);
	//CheckLhs(7,7);
	CheckLhs(1,7);
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
	CheckLhs(1,2);
	/* flsencode routine have all */
	flsencode(1);
	return (0);
}

/* -------------------------------------------------------------------------------------------------------- */
/* ENCODE ROUTINE                                                                                           */
/* -------------------------------------------------------------------------------------------------------- */

int flsencode(int mode)
{
	char** chelem;
	int *header1,*element1,*header2,*header3,*element3,*element4,*element5;
	int field_num;

	double *mfpar, *range;
	int mdum,ndum,ncolmparo,i,j,k,one=1,nelem,ninputs,noutputs,nrules;
	double *mpari,*mparo;
	int nmf,nmfio,io,pt,pt2,idx1,idx2;
	int mfid[2],field_number;
	int tofree[10];
	
	int mid1[7],*mrule;
	double mid2[3],*mdomo,*mwe;
	int lmid1,lmid2,lmwe,lmrule,lmdomo,lmpari,lmparo;

	int npoints,nio,x,y,maxnpev,*npev,pevt,m1,n1,doal,cvy,ierr;
	double *tmp1,*tmp2,*tmp3,*tmp4;	
	int otmp2y,notmp2y;

	double dcero=0.0;
	int sz;
	char ** LabelList = NULL;
	
	char ** LabelListout = NULL;
	char ** LabelListin = NULL;
	char ** LabelListrules = NULL;

	int     m_param2, m_param3;	
	int     m_param, n_param, l_param;
        int     m_label, n_label, pos_label;
        int     m_tmp,   n_tmp,   l_tmp;
	int ListPos=0;
	double *dtmp;
	int * scilab_struct = NULL;
	int * input_struct = NULL;
	int * output_struct = NULL;
	int * inout_struct = NULL;
	int * rules_struct = NULL;
	int * p_x = NULL;
	int m_paramin,m_paramout,m_paramrules;
	int type;
	SciErr _SciErr;
	int iRows       = 0;
	int iCols       = 0;
	int* piLen      = NULL;
	double *ptr,*out1,*out2,*out3,*out4,*out5,*out6,*out7,*out8;
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
		//header1=(int*) GetData(1);
		ListPos=1;
             // GetRhsVar(1, MATRIX_ORIENTED_TYPED_LIST_DATATYPE, &m_param,&n_param, &l_param);
             // GetListRhsVar(1, 1, MATRIX_OF_STRING_DATATYPE, &m_label,&n_label, &LabelList);
	} else if (mode==1) {
		//header1=(int*) GetData(2);
		ListPos=2;
		//GetRhsVar(2, MATRIX_ORIENTED_TYPED_LIST_DATATYPE, &m_param,&n_param, &l_param);
               // GetListRhsVar(2, 1, MATRIX_OF_STRING_DATATYPE, &m_label,&n_label, &LabelList);
	} else {
		sciFLT_doerror(0); goto goout;
	}
	_SciErr = getVarAddressFromPosition(pvApiCtx, ListPos, &scilab_struct);
		  if(_SciErr.iErr)
		      {
			printError(&_SciErr, 0);
			return 0;
		      } 
                _SciErr = getVarType(pvApiCtx, scilab_struct, &type);
		  if(_SciErr.iErr)
		      {
			printError(&_SciErr, 0);
			return 0;
		      } 
//         if (type!=sci_mlist && type!=sci_list)
// 		{
// 		  sciprint("Error:  must be a list\n");	
// 		  sciFLT_doerror(1); goto goout;
// 		  return 0;
// 		}
	//if (header1[0]!=16) { sciFLT_doerror(1); goto goout; }
	
	_SciErr = getListItemNumber(pvApiCtx, scilab_struct, &m_param);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return NULL;
	}
	printf("List has %d items\n",m_param);
	
	        _SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, 1, &iRows, &iCols, NULL, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, 1, &iRows, &iCols, piLen, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		LabelList = (char**)malloc(sizeof(char*) * iRows * iCols);
		for(i = 0 ; i < iRows * iCols ; i++)
		{
			LabelList[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, 1, &iRows, &iCols, piLen, LabelList);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}
		free(piLen);
		for (i=0;i<m_param;i++)
		  printf("%d: %s ",i,LabelList[i]);
		printf("\n");
	
	/* ---------------------------------------------------------------------------- */
	/* GET THE TYPE                                                                 */
	/* ---------------------------------------------------------------------------- */
	//field_num=MlistGetFieldNumber(header1,"type\0");
	field_num=find_label(LabelList, m_param, "type");
	
	if (field_num<0) { sciFLT_doerror(1); return 0; }
	
	_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, NULL, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		chelem = (char**)malloc(sizeof(char*) * iRows * iCols);
		for(i = 0 ; i < iRows * iCols ; i++)
		{
			chelem[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, chelem);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}
		free(piLen);
		
	//read_string(chelem, scilab_struct, field_num+1);
	//printf("read_string ok %s\n",chelem[0]);
	//element1=(int*) listentry(header1,field_num);
	//GetListRhsVar(PARAM_IN, field_num+1, "c",&m_tmp, &n_tmp, &l_tmp);
	 //chelem=cstk(l_tmp);
	//if (element1[0]!=10) { sciFLT_doerror(11); return 0; }
	//nelem=element1[5]-1;
	//C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem[0],"m",1)==0) {
		/* MAMDANI */
		mid1[0]=0;		
	} else if (strncmp(chelem[0],"ts",2)==0) {
		/* TAKAGI-SUGENO */
		mid1[0]=1;
	} else {
		sciFLT_doerror(10);
		goto goout;
	}
	//printf("type %d\n",mid1[0]);
	free(chelem[0]);
	free(chelem);
	//printf("test\n");
	/* ---------------------------------------------------------------------------- */
	/* GET THE S-NORM                                                               */
	/* ---------------------------------------------------------------------------- */
	//field_num=MlistGetFieldNumber(header1,"SNorm\0");
	field_num=find_label(LabelList, m_param, "SNorm");
	if (field_num<0) { sciFLT_doerror(1); return 0; }
// 	GetListRhsVar(PARAM_IN, field_num+1, "c",&m_tmp, &n_tmp, &l_tmp);
// 	 chelem=cstk(l_tmp);
	 //read_string(chelem, scilab_struct, field_num+1);
	 	_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, NULL, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		chelem = (char**)malloc(sizeof(char*) * iRows * iCols);
		for(i = 0 ; i < iRows * iCols ; i++)
		{
			chelem[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, chelem);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}
		free(piLen);
// 	element1=(int*) listentry(header1,field_num);
// 	if (element1[0]!=10) { sciFLT_doerror(21); return 0; }
// 	nelem=element1[5]-1;
// 	C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem[0],"dubois",6)==0) {
		/* DUBOIS-PRADE */
		mid1[1]=0;
	} else if (strncmp(chelem[0],"yager",5)==0) {
		/* YAGER */
		mid1[1]=1;
	} else if (strncmp(chelem[0],"dsum",4)==0) {
		/* DRASTIC SUM */
		mid1[1]=2;
	} else if (strncmp(chelem[0],"esum",4)==0) {
		/* EINSTEIN SUM */
		mid1[1]=3;
	} else if (strncmp(chelem[0],"asum",4)==0) {
		/* ALGEBRAIC SUM */
		mid1[1]=4;
	} else if (strncmp(chelem[0],"max",3)==0) {
		/* MAXIMUM */
		mid1[1]=5;
	} else {
		sciFLT_doerror(20);
		goto goout;
	}
	free(chelem[0]);
	free(chelem);

	/* ---------------------------------------------------------------------------- */
	/* GET THE S-NORM PARAMETER                                                     */
	/* NEEDED IF S-NORM IS DUBOIS OR YAGER -> NO PARAMETER CHECK HERE               */
	/* ---------------------------------------------------------------------------- */
	if ((mid1[1]==0)|(mid1[1]==1)) {
		//field_num=MlistGetFieldNumber(header1,"SNormPar\0");
		field_num=find_label(LabelList, m_param, "SNormPar");
		if (field_num<0) { sciFLT_doerror(1); return 0; }
		_SciErr = getMatrixOfDoubleInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, &ptr);
	    if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
// 		GetListRhsVar(PARAM_IN, field_num+1, MATRIX_OF_DOUBLE_DATATYPE, &m_tmp, &n_tmp, &l_tmp);
// 		dtmp = *stk(l_tmp); 
		
		//element1=(int*) listentry(header1,field_num);
// 		if (element1[0]!=1) { sciFLT_doerror(30); return 0; }
// 		/* IN CASE [] TAKE 0.0 as default */
// 		if (element1[1]>0) {
// 			mid2[0]=*((double*) (element1+4));
// 		} else {
// 			mid2[0]=0.0;
// 		}
	    if (iRows*iCols!=0)
		mid2[0]=ptr[0];
		  
	}

	/* ---------------------------------------------------------------------------- */
	/* GET THE T-NORM                                                               */
	/* ---------------------------------------------------------------------------- */
	//field_num=MlistGetFieldNumber(header1,"TNorm\0");
	field_num=find_label(LabelList, m_param, "TNorm");
	if (field_num<0) { sciFLT_doerror(1); return 0; }
	 //read_string(chelem, scilab_struct, field_num+1);
	 	_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, NULL, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		chelem = (char**)malloc(sizeof(char*) * iRows * iCols);
		for(i = 0 ; i < iRows * iCols ; i++)
		{
			chelem[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, chelem);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}
		free(piLen);
// 	GetListRhsVar(PARAM_IN, field_num+1, "c",&m_tmp, &n_tmp, &l_tmp);
// 	chelem=cstk(l_tmp);
	
// 	element1=(int*) listentry(header1,field_num);
// 	if (element1[0]!=10) { sciFLT_doerror(41); return 0; }
// 	nelem=element1[5]-1;
// 	C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem[0],"dubois",6)==0) {
		/* DUBOIS-PRADE */
		mid1[2]=0;
	} else if (strncmp(chelem[0],"yager",5)==0) {
		/* YAGER */
		mid1[2]=1;
	} else if (strncmp(chelem[0],"dprod",5)==0) {
		/* DRASTIC PRODUCT */
		mid1[2]=2;
	} else if (strncmp(chelem[0],"eprod",5)==0) {
		/* EINSTEIN PRODUCT */
		mid1[2]=3;
	} else if (strncmp(chelem[0],"aprod",5)==0) {
		/* ALGEBRAIC PRODUCT */
		mid1[2]=4;
	} else if (strncmp(chelem[0],"min",3)==0) {
		/* MINIMUM */
		mid1[2]=5;
	} else {
		sciFLT_doerror(40);
		goto goout;
	}
	free(chelem[0]);
	free(chelem);

	/* ---------------------------------------------------------------------------- */
	/* GET THE T-NORM PARAMETER                                                     */
	/* NEEDED IF T-NORM IS DUBOIS OR YAGER -> NO PARAMETER CHECK HERE               */
	/* ---------------------------------------------------------------------------- */
	if ((mid1[2]==0)|(mid1[2]==1)) {
		//field_num=MlistGetFieldNumber(header1,"TNormPar\0");
		field_num=find_label(LabelList, m_param, "TNormPar");
		if (field_num<0) { sciFLT_doerror(1); return 0; }
		_SciErr = getMatrixOfDoubleInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, &ptr);
	    if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
// 		GetListRhsVar(PARAM_IN, field_num+1, MATRIX_OF_DOUBLE_DATATYPE, &m_tmp, &n_tmp, &l_tmp);
// 		dtmp = *stk(l_tmp); 
// 		element1=(int*) listentry(header1,field_num);
// 		if (element1[0]!=1) { sciFLT_doerror(50); return 0; }
// 		/* IN CASE [] TAKE 0.0 as default */
// 		if (element1[1]>0) {
// 			mid2[1]=*((double*) (element1+4));
// 		} else {
// 			mid2[1]=0.0;
// 		}
             if (iRows*iCols!=0)
		mid2[1]=ptr[0];
	}	

	/* ---------------------------------------------------------------------------- */
	/* GET THE COMPLEMENT                                                           */
	/* ---------------------------------------------------------------------------- */
	//field_num=MlistGetFieldNumber(header1,"Comp\0");
	field_num=find_label(LabelList, m_param, "Comp");
	if (field_num<0) { sciFLT_doerror(1); return 0; }
	//read_string(chelem, scilab_struct, field_num+1);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, NULL, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		chelem = (char**)malloc(sizeof(char*) * iRows * iCols);
		for(i = 0 ; i < iRows * iCols ; i++)
		{
			chelem[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, chelem);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}
		free(piLen);
	//GetListRhsVar(PARAM_IN, field_num+1, "c",&m_tmp, &n_tmp, &l_tmp);
	// chelem=cstk(l_tmp);
// 	element1=(int*) listentry(header1,field_num);
// 	if (element1[0]!=10) { sciFLT_doerror(61); return 0; }
// 	nelem=element1[5]-1;
// 	C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem[0],"one",3)==0) {
		/* ONE -> CLASSIC */
		mid1[3]=0;
	} else if (strncmp(chelem[0],"yager",5)==0) {
		/* YAGER */
		mid1[3]=1;
	} else if (strncmp(chelem[0],"sugeno",6)==0) {
		/* SUGENO */
		mid1[3]=2;
	} else {
		sciFLT_doerror(60);
		goto goout;
	}
        free(chelem[0]);
	free(chelem);

	/* ---------------------------------------------------------------------------- */
	/* GET THE COMPLEMENT PARAMETER                                                 */
	/* NEEDED IF COMPLEMENT IS YAGER OR SUGENO -> NO PARAMETER CHECK HERE           */
	/* ---------------------------------------------------------------------------- */
	if ((mid1[3]==1)|(mid1[3]==2)) {
		//field_num=MlistGetFieldNumber(header1,"CompPar\0");
		field_num=find_label(LabelList, m_param, "CompPar");
		if (field_num<0) { sciFLT_doerror(1); return 0; }
		_SciErr = getMatrixOfDoubleInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, &ptr);
	    if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
/*		GetListRhsVar(PARAM_IN, field_num+1, MATRIX_OF_DOUBLE_DATATYPE, &m_tmp, &n_tmp, &l_tmp);
		dtmp = *stk(l_tmp);*/ 
// 		element1=(int*) listentry(header1,field_num);
// 		if (element1[0]!=1) { sciFLT_doerror(70); return 0; }
// 		/* IN CASE [] TAKE 0.0 as default */
// 		if (element1[1]>0) {
// 			mid2[2]=*((double*) (element1+4));
// 		} else {
// 			mid2[2]=0.0;
// 		}
             if (iRows*iCols!=0)
		mid2[2]=ptr[0];
	}	

	/* ---------------------------------------------------------------------------- */
	/* GET THE IMPLICATION                                                          */
	/* NEEDED IF IS MAMDANI                                                         */
	/* ---------------------------------------------------------------------------- */
	if ( mid1[0]==0 ) {
		//field_num=MlistGetFieldNumber(header1,"ImpMethod\0");
		field_num=find_label(LabelList, m_param, "ImpMethod");
 		if (field_num<0) { sciFLT_doerror(1); return 0; }
 		//read_string(chelem, scilab_struct, field_num+1);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, NULL, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		chelem = (char**)malloc(sizeof(char*) * iRows * iCols);
		for(i = 0 ; i < iRows * iCols ; i++)
		{
			chelem[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, chelem);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}
		free(piLen);
// 		GetListRhsVar(PARAM_IN, field_num+1, "c",&m_tmp, &n_tmp, &l_tmp);
// 		 chelem=cstk(l_tmp);
// 		element1=(int*) listentry(header1,field_num);
// 		if (element1[0]!=10) { sciFLT_doerror(81); return 0; }
// 		nelem=element1[5]-1;
// 		C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
		if (strncmp(chelem[0],"min",3)==0) {
			/* MINIMUM */
			mid1[4]=0;
		} else if (strncmp(chelem[0],"prod",4)==0) {
			/* PRODUCT */
			mid1[4]=1;
		} else {
			sciFLT_doerror(80);
			goto goout;
		}
		free(chelem[0]);
	        free(chelem);
	}

	/* ---------------------------------------------------------------------------- */
	/* GET THE AGGREGATION                                                          */
	/* NEEDED IF IS MAMDANI                                                         */
	/* ---------------------------------------------------------------------------- */
	if ( mid1[0]==0 ) {
		//field_num=MlistGetFieldNumber(header1,"AggMethod\0");
		field_num=find_label(LabelList, m_param, "AggMethod");
		if (field_num<0) { sciFLT_doerror(1); return 0; }
		//read_string(chelem, scilab_struct, field_num+1);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, NULL, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		chelem = (char**)malloc(sizeof(char*) * iRows * iCols);
		for(i = 0 ; i < iRows * iCols ; i++)
		{
			chelem[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, chelem);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}
		free(piLen);
// 		GetListRhsVar(PARAM_IN, field_num+1, "c",&m_tmp, &n_tmp, &l_tmp);
// 		 chelem=cstk(l_tmp);
// 		element1=(int*) listentry(header1,field_num);
// 		if (element1[0]!=10) { sciFLT_doerror(91); return 0; }
// 		nelem=element1[5]-1;
// 		C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
		if (strncmp(chelem[0],"max",3)==0) {
			/* MAXIMUM */
			mid1[5]=0;
		} else if (strncmp(chelem[0],"sum",3)==0) {
			/* SUM */
			mid1[5]=1;
		} else if (strncmp(chelem[0],"probor",6)==0) {
			/* PROBABILISTIC OR */
			mid1[5]=3;
		} else {
			sciFLT_doerror(90);
			goto goout;
		}
		free(chelem[0]);
	        free(chelem);
	}

	/* ---------------------------------------------------------------------------- */
	/* GET THE DEFUZZIFICATION                                                      */
	/* ---------------------------------------------------------------------------- */
	//field_num=MlistGetFieldNumber(header1,"defuzzMethod\0");
	field_num=find_label(LabelList, m_param, "defuzzMethod");
 	if (field_num<0) { sciFLT_doerror(1); return 0; }
 	_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, NULL, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, NULL);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}

		chelem = (char**)malloc(sizeof(char*) * iRows * iCols);
		for(i = 0 ; i < iRows * iCols ; i++)
		{
			chelem[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		_SciErr = getMatrixOfStringInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, piLen, chelem);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}
		free(piLen);
 	//read_string(chelem, scilab_struct, field_num+1);
//  	GetListRhsVar(PARAM_IN, field_num+1, "c",&m_tmp, &n_tmp, &l_tmp);
// 		 chelem=cstk(l_tmp);
// 	element1=(int*) listentry(header1,field_num);
// 	if (element1[0]!=10) { sciFLT_doerror(101); return 0; }
// 	nelem=element1[5]-1;
// 	C2F(cvstr)(&nelem,&element1[6],chelem,&one,nelem);
	if (strncmp(chelem[0],"centroide",9)==0) {
		/* CENTROIDE */
		mid1[6]=0;
	} else if (strncmp(chelem[0],"bisector",8)==0) {
		/* BISECTOR */
		mid1[6]=1;
	} else if (strncmp(chelem[0],"mom",3)==0) {
		/* MEAN OF MAXIMUM */
		mid1[6]=2;
	} else if (strncmp(chelem[0],"som",3)==0) {
		/* SHORTEST OF MAXIMUM */
		mid1[6]=3;
	} else if (strncmp(chelem[0],"lom",3)==0) {
		/* LARGEST OF MAXIMUM */
		mid1[6]=4;
	} else if (strncmp(chelem[0],"wtaver",5)==0) {
		/* WEIGTHED AVERAGE */
		mid1[6]=5;
	} else if (strncmp(chelem[0],"wtsum",4)==0) {
		/* WEIGTHED SUM */
		mid1[6]=6;
	} else {
		sciFLT_doerror(100);
		goto goout;
	}
	free(chelem[0]);
        free(chelem);
	/* CHECK DEFUZZIFICATION DUE THE FLS TYPE */
	if ((mid1[6]>4)&(mid1[0]==0)) { sciFLT_doerror(102); return 0; }
	if ((mid1[6]<5)&(mid1[0]==1)) { sciFLT_doerror(102); return 0; }


	/* ---------------------------------------------------------------------------- */
	/* GET THE NUMBER OF INPUTS AND OUTPUTS                                         */
	/* ---------------------------------------------------------------------------- */
	//field_num=MlistGetFieldNumber(header1,"input\0");
	field_num=find_label(LabelList, m_param, "input");
	if (field_num<0) { sciFLT_doerror(1); return 0; }

        _SciErr = getListItemAddress(pvApiCtx,scilab_struct, field_num+1, &input_struct);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	_SciErr = getListItemNumber(pvApiCtx, input_struct, &ninputs);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	printf("Input List has %d items\n",ninputs);
	
	_SciErr = getListItemAddress(pvApiCtx,input_struct, 1, &input_struct);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	
	_SciErr = getListItemNumber(pvApiCtx, input_struct, &m_paramin);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	//printf("Input List has %d items\n",ninputs);
	
	_SciErr = getMatrixOfStringInList(pvApiCtx, input_struct, 1, &iRows, &iCols, NULL, NULL);
	if(_SciErr.iErr)
	{
	  printf("error\n");
		printError(&_SciErr, 0);
		return 0;
	}

	piLen = (int*)malloc(sizeof(int) * iRows * iCols);
	_SciErr = getMatrixOfStringInList(pvApiCtx, input_struct, 1, &iRows, &iCols, piLen, NULL);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}

	LabelListin = (char**)malloc(sizeof(char*) * iRows * iCols);
	for(i = 0 ; i < iRows * iCols ; i++)
	{
		LabelListin[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
	}

	_SciErr = getMatrixOfStringInList(pvApiCtx, input_struct, 1, &iRows, &iCols, piLen, LabelListin);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	free(piLen);
	for (i=0;i<m_paramin;i++)
	  printf("%d: %s ",i,LabelListin[i]);
	printf("\n");
	
	
	//GetListRhsVar(1, field_num+1, MATRIX_ORIENTED_TYPED_LIST_DATATYPE,&m_tmp, &n_tmp, &l_tmp);
// 	element1=(int*) listentry(header1,field_num);
// 	if (element1[0]!=15) { sciFLT_doerror(1); return 0; }
// 	ninputs=element1[1];
	//ninputs=m_tmp;
	//field_num=MlistGetFieldNumber(header1,"output\0");
	field_num=find_label(LabelList, m_param, "output");
	if (field_num<0) { sciFLT_doerror(1); return 0; }
	_SciErr = getListItemAddress(pvApiCtx,scilab_struct, field_num+1, &output_struct);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	_SciErr = getListItemNumber(pvApiCtx, output_struct, &noutputs);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return NULL;
	}
	printf("Output List has %d items\n",noutputs);
	
	_SciErr = getListItemAddress(pvApiCtx,output_struct, 1, &output_struct);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	
	_SciErr = getListItemNumber(pvApiCtx, output_struct, &m_paramout);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	//printf("Output List has %d items\n",m_paramout);
	
	_SciErr = getMatrixOfStringInList(pvApiCtx, output_struct, 1, &iRows, &iCols, NULL, NULL);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}

	piLen = (int*)malloc(sizeof(int) * iRows * iCols);
	_SciErr = getMatrixOfStringInList(pvApiCtx, output_struct, 1, &iRows, &iCols, piLen, NULL);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	LabelListout = (char**)malloc(sizeof(char*) * iRows * iCols);
	for(i = 0 ; i < iRows * iCols ; i++)
	{
		LabelListout[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
	}
	_SciErr = getMatrixOfStringInList(pvApiCtx, output_struct, 1, &iRows, &iCols, piLen, LabelListout);
	if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return 0;
	}
	free(piLen);
	for (i=0;i<m_paramout;i++)
	  printf("%d: %s ",i,LabelListout[i]);
	printf("\n");
	
	
	//GetListRhsVar(1, field_num+1, MATRIX_ORIENTED_TYPED_LIST_DATATYPE,&m_tmp, &n_tmp, &l_tmp);
// 	element1=(int*) listentry(header1,field_num);
// 	if (element1[0]!=15) { sciFLT_doerror(1); return 0; }
// 	noutputs=element1[1];
        //noutputs=m_tmp;
	
	/* ---------------------------------------------------------------------------- */
	/* GET THE RULES AND TRANSFORM IT TO INTERNAL REPRESENTATION                    */
	/* ---------------------------------------------------------------------------- */	
	//field_num=MlistGetFieldNumber(header1,"rule\0");
	field_num=find_label(LabelList, m_param, "rule");
	if (field_num<0) { sciFLT_doerror(1); return 0; }
	_SciErr = getMatrixOfDoubleInList(pvApiCtx, scilab_struct, field_num+1, &iRows, &iCols, &ptr);
	    if(_SciErr.iErr)
	{
		printError(&_SciErr, 0);
		return NULL;
	}
	nrules=iRows;
	printf("nrules %d\n",nrules);
	//GetListRhsVar(1, field_num+1, MATRIX_ORIENTED_TYPED_LIST_DATATYPE,&m_tmp, &n_tmp, &l_tmp);
// 	element1=(int*) listentry(header1,field_num);
// 	if (element1[0]!=1) { sciFLT_doerror(1); return 0; }
// 	nrules=element1[1];
	//nrules=m_tmp;
// 	if (element1[2]!=(ninputs+noutputs+2)) { sciFLT_doerror(111); return 0; }

	/* get the rules */

	#ifdef FLT_USESCIALLOC
	mrule=(int*)MALLOC(nrules*(ninputs+noutputs+1)*sizeof(int));
	#else
	mrule=(int*)malloc(nrules*(ninputs+noutputs+1)*sizeof(int));
	#endif
	if (mrule==NULL) {
		sciFLT_doerror(999);
		goto goout;
	}
	tofree[0]=1;
	C2F(dicopy)((double*)(ptr),mrule,(sz=(ninputs+noutputs+1)*nrules,&sz));

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
	C2F(getmw)((double*) (ptr),&nrules,&ninputs,&noutputs,mwe);

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
		   printf("input\n");
			//field_num=MlistGetFieldNumber(header1,"input\0");
			field_num=find_label(LabelList, m_param, "input");
			if (field_num<0) { sciFLT_doerror(1); return 0; }
			_SciErr = getListItemAddress(pvApiCtx,scilab_struct, field_num+1, &inout_struct);
			if(_SciErr.iErr)
			{
				printError(&_SciErr, 0);
				return 0;
			}
			nmfio=ninputs;
		} else {
		     printf("output\n");
			//field_num=MlistGetFieldNumber(header1,"output\0");
			field_num=find_label(LabelList, m_param, "output");
			if (field_num<0) { sciFLT_doerror(1); return 0; }
			_SciErr = getListItemAddress(pvApiCtx,scilab_struct, field_num+1, &inout_struct);
			if(_SciErr.iErr)
			{
				printError(&_SciErr, 0);
				return 0;
			}
			nmfio=noutputs;
		}
		//header2=(int*) listentry(header1,field_num);
		for (i=0;i<nmfio;i++) {
		    printf("i = %d until %d\n",i,nmfio);
			/* get the input/output number i+1 */
			//header3=(int*) listentry(header2,i+1);
			//if (header3[0]!=16) { sciFLT_doerror(1); goto goout; }
			if (io==0) {
				//field_num=MlistGetFieldNumber(header1,"input\0");
				field_num=find_label(LabelList, m_param, "input");
				if (field_num<0) { sciFLT_doerror(1); return 0; }
				_SciErr = getListItemAddress(pvApiCtx,scilab_struct, field_num+1, &inout_struct);
				if(_SciErr.iErr)
				{
					printError(&_SciErr, 0);
					return 0;
				}
			} else {
				//field_num=MlistGetFieldNumber(header1,"output\0");
				field_num=find_label(LabelList, m_param, "output");
				if (field_num<0) { sciFLT_doerror(1); return 0; }
				_SciErr = getListItemAddress(pvApiCtx,scilab_struct, field_num+1, &inout_struct);
				if(_SciErr.iErr)
				{
					printError(&_SciErr, 0);
					return 0;
				}
			}
			
			
			_SciErr = getListItemAddress(pvApiCtx,inout_struct, i+1, &inout_struct);
			if(_SciErr.iErr)
			{
				printError(&_SciErr, 0);
				return 0;
			}
		
			/* get the range --> only the outputs*/
			if (io==1) {				
				//field_num=MlistGetFieldNumber(header3,"range\0");
				field_num=find_label(LabelListout, m_paramout, "range");
				if (field_num<0) { sciFLT_doerror(1); goto goout; }
				//element3=(int*) listentry(header3,field_num);
				//if ((element3[0]!=1)|(element3[1]*element3[2]!=2)) { sciFLT_doerror(120); goto goout; }
				_SciErr = getMatrixOfDoubleInList(pvApiCtx, inout_struct, field_num+1, &iRows, &iCols, &range);
				if(_SciErr.iErr)
				{
					printError(&_SciErr, 0);
					return 0;
				}
				//range=((double*) (element3+4));
				mdomo[i*2]=range[0];
				mdomo[i*2+1]=range[1];
			}

			/* get the number of member functions */
			//field_num=MlistGetFieldNumber(header3,"mf\0");
			if (io==0)
			  field_num=find_label(LabelListin, m_paramin, "mf");
			else
			  field_num=find_label(LabelListout, m_paramout, "mf");
			if (field_num<0) { sciFLT_doerror(1); goto goout; }
			//element3=(int*) listentry(header3,field_num);
			//if ((element3[0]!=1)|(element3[1]*element3[2]!=2)) { sciFLT_doerror(120); goto goout; }

// 			if (field_num<1) { sciFLT_doerror(1); goto goout; }
// 			element3=(int*) listentry(header3,field_num);
// 			if (element3[0]!=15) { sciFLT_doerror(1); goto goout; }
// 			nmf=element3[1];
		      _SciErr = getListItemAddress(pvApiCtx,inout_struct, field_num+1, &rules_struct);
		      if(_SciErr.iErr)
		      {
			      printError(&_SciErr, 0);
			      return 0;
		      }
		      _SciErr = getListItemNumber(pvApiCtx, rules_struct, &nmf);
			if(_SciErr.iErr)
			      {
				      printError(&_SciErr, 0);
				      return NULL;
			      }
			      printf("rules List has %d items\n",nmf);
			
			_SciErr = getListItemAddress(pvApiCtx,rules_struct, 1, &rules_struct);
			if(_SciErr.iErr)
			{
				printError(&_SciErr, 0);
				return 0;
			}
			
			_SciErr = getListItemNumber(pvApiCtx, rules_struct, &m_paramrules);
			if(_SciErr.iErr)
			{
				printError(&_SciErr, 0);
				return 0;
			}
			//printf("rules List has %d items\n",m_paramrules);
			
			_SciErr = getMatrixOfStringInList(pvApiCtx, rules_struct, 1, &iRows, &iCols, NULL, NULL);
			if(_SciErr.iErr)
			{
			  printf("error\n");
				printError(&_SciErr, 0);
				return 0;
			}

			piLen = (int*)malloc(sizeof(int) * iRows * iCols);
			_SciErr = getMatrixOfStringInList(pvApiCtx, rules_struct, 1, &iRows, &iCols, piLen, NULL);
			if(_SciErr.iErr)
			{
				printError(&_SciErr, 0);
				return 0;
			}

			LabelListrules = (char**)malloc(sizeof(char*) * iRows * iCols);
			for(j = 0 ; j < iRows * iCols ; j++)
			{
				LabelListrules[j] = (char*)malloc(sizeof(char) * (piLen[j] + 1));//+ 1 for null termination
			}

			_SciErr = getMatrixOfStringInList(pvApiCtx, rules_struct, 1, &iRows, &iCols, piLen, LabelListrules);
			if(_SciErr.iErr)
			{
				printError(&_SciErr, 0);
				return 0;
			}
			free(piLen);
			for (j=0;j<m_paramrules;j++)
			  printf("%d: %s ",j,LabelListrules[j]);
			printf("\n");
			
			

			/* parse the rules and parse the member functions parameters */
			for (j=0;j<nrules;j++) {
				if (io==0) {
					pt=nrules*i+j;
				} else {
					pt=(nrules)*(i+ninputs)+j;
				}
				
				idx1=abs(mrule[pt]);
				idx2=sign(mrule[pt]);
				
				if (idx1>nmf) { sciFLT_doerror(112); goto goout; }				
				/* take the idx member function */
				if (idx1!=0) {

				  
				  
				      if (io==0)
					field_num=find_label(LabelListin, m_paramin, "mf");
				      else
					field_num=find_label(LabelListout, m_paramout, "mf");
				      if (field_num<0) { sciFLT_doerror(1); goto goout; }
				      _SciErr = getListItemAddress(pvApiCtx,inout_struct, field_num+1, &rules_struct);
				    if(_SciErr.iErr)
				    {
					    printError(&_SciErr, 0);
					    return 0;
				    }
			
					_SciErr = getListItemAddress(pvApiCtx,rules_struct, idx1, &rules_struct);
					if(_SciErr.iErr)
					{
						printError(&_SciErr, 0);
						return 0;
					}
				        field_num=find_label(LabelListrules, m_paramrules, "type");
					if (field_num<0) { sciFLT_doerror(1); goto goout; }
				      _SciErr = getMatrixOfStringInList(pvApiCtx, rules_struct, field_num+1, &iRows, &iCols, NULL, NULL);
				      if(_SciErr.iErr)
				      {
					      printError(&_SciErr, 0);
					      return 0;
				      }

				      piLen = (int*)malloc(sizeof(int) * iRows * iCols);
				      _SciErr = getMatrixOfStringInList(pvApiCtx, rules_struct, field_num+1, &iRows, &iCols, piLen, NULL);
				      if(_SciErr.iErr)
				      {
					      printError(&_SciErr, 0);
					      return 0;
				      }

				      chelem = (char**)malloc(sizeof(char*) * iRows * iCols);
				      for(k = 0 ; k < iRows * iCols ; k++)
				      {
					      chelem[k] = (char*)malloc(sizeof(char) * (piLen[k] + 1));//+ 1 for null termination
				      }

				      _SciErr = getMatrixOfStringInList(pvApiCtx, rules_struct, field_num+1, &iRows, &iCols, piLen, chelem);
				      if(_SciErr.iErr)
				      {
					      printError(&_SciErr, 0);
					      return 0;
				      }
				      free(piLen);
				      
// 					element4=(int*) listentry(element3,idx1);
// 					if (element4[0]!=16) { sciFLT_doerror(1); goto goout; }
// 					field_number=MlistGetFieldNumber(element4,"type\0");
// 					if (field_number<1) { sciFLT_doerror(1); goto goout; }
// 					element5=(int*) listentry(element4,field_number);
// 					if (element5[0]!=10) { sciFLT_doerror(130); goto goout; }
// 					nelem=element5[5]-1;

					/* check member function type */					
					//C2F(cvstr)(&nelem,&element5[6],chelem[0],&one,nelem);
					if (strncmp(chelem[0],"trimf",5)==0) {
						mfid[0]=1;mfid[1]=3;
					} else if (strncmp(chelem[0],"trapmf",6)==0) {
						mfid[0]=2;mfid[1]=4;
					} else if (strncmp(chelem[0],"gaussmf",7)==0) {
						mfid[0]=3;mfid[1]=2;
					} else if (strncmp(chelem[0],"gauss2mf",8)==0) {
						mfid[0]=4;mfid[1]=4;
					} else if (strncmp(chelem[0],"sigmf",5)==0) {
						mfid[0]=5;mfid[1]=2;
					} else if (strncmp(chelem[0],"psigmf",6)==0) {
						mfid[0]=6;mfid[1]=4;
					} else if (strncmp(chelem[0],"dsigmf",6)==0) {
						mfid[0]=7;mfid[1]=4;
					} else if (strncmp(chelem[0],"gbellmf",7)==0) {
						mfid[0]=8;mfid[1]=3;
					} else if (strncmp(chelem[0],"pimf",4)==0) {
						mfid[0]=9;mfid[1]=4;
					} else if (strncmp(chelem[0],"smf",3)==0) {
						mfid[0]=10;mfid[1]=2;
					} else if (strncmp(chelem[0],"zmf",3)==0) {
						mfid[0]=11;mfid[1]=2;
					} else if (strncmp(chelem[0],"constant",8)==0) {
						mfid[0]=12;mfid[1]=1;
					} else if (strncmp(chelem[0],"linear",6)==0) {
						mfid[0]=13;mfid[1]=ninputs+1;
					} else {
						sciFLT_doerror(131);
						goto goout;
					}
					free(chelem[0]);
					free(chelem);
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
					mrule[pt]=mfid[0]*idx2;
					//field_number=MlistGetFieldNumber(element4,"par\0");
					field_num=find_label(LabelListrules, m_paramrules, "par");
					if (field_num<0) { sciFLT_doerror(1); return 0; }
					_SciErr = getMatrixOfDoubleInList(pvApiCtx, rules_struct, field_num+1, &iRows, &iCols, &mfpar);
					 if(_SciErr.iErr)
					{
						printError(&_SciErr, 0);
						return 0;
					}
// 					if (field_number<1) { sciFLT_doerror(1); goto goout; }					
// 					element5=(int*) listentry(element4,field_number);
// 					if (element5[0]!=1) { sciFLT_doerror(140); goto goout; }
// 					if (element5[2]!=mfid[1]) { sciFLT_doerror(141); goto goout; }
// 					mfpar=((double*) (element5+4));
					

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
			for (k=0;k<m_paramrules;k++)
			  free(LabelListrules[k]);
			free(LabelListrules);
		}
	}
	printf("prepare output\n");
	
	/* ---------------------------------------------------------------------------- */
	/* MAKE THE REAL WORK                                                           */
	/* ---------------------------------------------------------------------------- */
	if (mode==0) {
		/* ---------------------------------------------------------------------------- */
		/* THIS IS THE CASE WHEN THE USER NEED THE INTERNAL REPRESENTATION              */
		/* ---------------------------------------------------------------------------- */
		
		/* mid1 */
		//CreateVar(2,"d",(mdum=7,&mdum),&one,&lmid1);
		//C2F(idcopy)(mid1,stk(lmid1),(sz=7,&sz));		
		_SciErr = allocMatrixOfDouble(pvApiCtx, Rhs + 1, 7, 1, &out1);
		if(_SciErr.iErr)
		 {
			    printError(&_SciErr, 0);
			    return 0;
		 }
		 for(i=0;i<7;i++)
		    out1[i]=mid1[i];
	

		/* mid2 */
		//CreateVar(3,"d",(mdum=3,&mdum),&one,&lmid2);
		//C2F(dcopy)((mdum=3,&mdum),mid2,&one,stk(lmid2),&one);
		_SciErr = allocMatrixOfDouble(pvApiCtx, Rhs + 2, 3, 1, &out2);
		if(_SciErr.iErr)
		 {
			    printError(&_SciErr, 0);
			    return 0;
		 }
		 for(i=0;i<3;i++)
		    out2[i]=mid2[i];
		/* mew */
		//CreateVar(4,"d",&nrules,&one,&lmwe);
		//C2F(dcopy)((mdum=nrules,&mdum),mwe,&one,stk(lmwe),&one);		
		_SciErr = createMatrixOfDouble(pvApiCtx, Rhs + 3, nrules, 1, mwe);
		if(_SciErr.iErr)
		 {
			    printError(&_SciErr, 0);
			    return 0;
		 }


		/* mrule */
		//CreateVar(5,"d",&nrules,(ndum=ninputs+noutputs+1,&ndum),&lmrule);
		//C2F(idcopy)(mrule,stk(lmrule),(sz=nrules*(ninputs+noutputs+1),&sz));
		_SciErr = allocMatrixOfDouble(pvApiCtx, Rhs + 4, nrules,(ninputs+noutputs+1), &out3);
		if(_SciErr.iErr)
		 {
			    printError(&_SciErr, 0);
			    return 0;
		 }
		 
		 for(i=0;i<nrules* (ninputs+noutputs+1);i++)
		    out3[i]=mrule[i];
	

		/* mdomo */
		//CreateVar(6,"d",&noutputs,(ndum=2,&ndum),&lmdomo);
		//C2F(dcopy)((mdum=noutputs*2,&mdum),mdomo,&one,stk(lmdomo),&one);
		_SciErr = createMatrixOfDouble(pvApiCtx, Rhs + 5, noutputs, 2,mdomo);
		if(_SciErr.iErr)
		 {
			    printError(&_SciErr, 0);
			    return 0;
		 }
	

		/* mpari */
		//CreateVar(7,"d",(mdum=4,&mdum),(ndum=ninputs*nrules,&ndum),&lmpari);
		//C2F(dcopy)((mdum=ninputs*nrules*4,&mdum),mpari,&one,stk(lmpari),&one);
		_SciErr = createMatrixOfDouble(pvApiCtx, Rhs + 6, ninputs*2,nrules*2 ,mpari);
		if(_SciErr.iErr)
		 {
			    printError(&_SciErr, 0);
			    return 0;
		 }
	

		/* mparo */
		//CreateVar(8,"d",&ncolmparo,(ndum=noutputs*nrules,&ndum),&lmparo);
		//C2F(dcopy)((mdum=ninputs*nrules*ncolmparo,&mdum),mparo,&one,stk(lmparo),&one);	
		_SciErr = createMatrixOfDouble(pvApiCtx, Rhs + 7, noutputs,nrules*ncolmparo, mparo);
		if(_SciErr.iErr)
		 {
			    printError(&_SciErr, 0);
			    return 0;
		 }
	
		LhsVar(1)=Rhs + 1;	
		LhsVar(2)=Rhs + 2;
		LhsVar(3)=Rhs + 3;
		LhsVar(4)=Rhs + 4;
		LhsVar(5)=Rhs + 5;
		LhsVar(6)=Rhs + 6;
		LhsVar(7)=Rhs + 7;

  PutLhsVar();
		
	} else {
		/* --------------------------------------------------------------------- */
		/* THIS IS THE FLS EVALUATION CASE                                       */
		/* --------------------------------------------------------------------- */

		/* get x from the first position in the stack */
		//GetRhsVar(1,"d",&npoints,&nio,&x)
		_SciErr = getVarAddressFromPosition(pvApiCtx, 1, &p_x);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return 0;
		}
		_SciErr = getMatrixOfDouble(pvApiCtx, p_x, &npoints, &nio, &x);
		if(_SciErr.iErr)
		{
			printError(&_SciErr, 0);
			return -1;
		}
		/* check size */
		if (nio!=ninputs) { sciFLT_doerror(200); goto goout; }
		
		/* if the system is mamdani the take the number of points to evaluate */
		/* from the third position in the stack                               */
		cvy=3;
		maxnpev=SCIFLT_MAXNPEV;
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
		//CreateVar(cvy,"d",&npoints,&noutputs,&y);
		_SciErr = allocMatrixOfDouble(pvApiCtx, Rhs + noutputs, npoints,noutputs, &y);
		if(_SciErr.iErr)
		 {
			    printError(&_SciErr, 0);
			    return 0;
		 }
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
		tmp2=(double*)MALLOC(npoints*nrules*sizeof(double));
		#else
		tmp2=(double*)malloc(npoints*nrules*sizeof(double));
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
		C2F(flsengine)(x,mid1,mid2,mwe,mrule,mdomo,mpari,mparo,&ncolmparo,npev,&ninputs,&noutputs,&nrules,&npoints,tmp1,tmp2,tmp3,tmp4,&maxnpev,stk(y),&ierr);
		if (ierr==0) {
			LhsVar(1)=cvy;
			if (Lhs==2) {
				CreateVar(cvy+1,"d",&npoints,&nrules,&otmp2y);
				C2F(dcopy)((notmp2y=npoints*nrules,&notmp2y),tmp2,&one,stk(otmp2y),&one);
				LhsVar(2)=cvy+1;
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

