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

#include "stack-c.h" 
#include "api_scilab.h"
#include "Scierror.h"
#include "MALLOC.h"



extern int F2C(complement) (char *class1, double *x, int *m, int *n, double *par, int *npar, double *y, int *ierr);

/* ---------------------------------------------------------------- */
/* INTERFACE TO complement                                          */
/* ---------------------------------------------------------------- */
int inter_complement(char *fname)
	
{
	int mx,nx,lx,mc,nc,lc,extra,ly,icero=0,mp,np,lp,ierr;
	double dcero=0.0;
	CheckRhs(2,3);
	CheckLhs(1,1);
	GetRhsVar(1,"d",&mx,&nx,&lx);
	GetRhsVar(2,"c",&mc,&nc,&lc);
	extra=0;
	if ((strncmp(cstk(lc),"sugeno",6)==0) | (strncmp(cstk(lc),"yager",5)==0)) {
		extra =1;
	}
	
	if (extra==0) {
		CreateVar(3,"d",&mx,&nx,&ly);
		F2C(complement)(cstk(lc),stk(lx),&mx,&nx,&dcero,&icero,stk(ly),&ierr);
	} else {
		mp=0;
		if (Rhs==3) {
			GetRhsVar(3,"d",&mp,&np,&lp);
		}

		if (mp!=1) {
			Scierror(999,"This complement class need a row vector of parameters.");
			ierr=1;
		} else {
			CreateVar(4,"d",&mx,&nx,&ly);
			F2C(complement)(cstk(lc),stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);
		}
	}

	if (ierr==0) {
		LhsVar(1)=3+extra;
	}
	return 0;
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO ANY REGISTERED MEMBER FUNCTION                      */
/* ---------------------------------------------------------------- */

int inter_anymf(char * fname)
{
	int mx,nx,lx,mp,np,lp,ly,ierr,one;
	CheckRhs(2,2);
	CheckLhs(1,1);
	GetRhsVar(1,"d",&mx,&nx,&lx);
	GetRhsVar(2,"d",&mp,&np,&lp);
	if (mp!=1) {
		Scierror(999,"This member function need a row vector parameters.");
		ierr=1;
	} else {
		if ((strncmp(fname,"linear",6)==0) | (strncmp(fname,"constant",8)==0)) {
			one=1;
		} else {
			one=nx;
		}
		CreateVar(3,"d",&mx,&one,&ly);
		F2C(mfeval)(fname,stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);		
	}

	if (ierr==0) {
		LhsVar(1)=3;
	}

	return 0;
}

extern int F2C(mfeval) (char *mfname, double *x, int *m, int *n, double *par, int *npar, double *y, int *ierr);

/* ---------------------------------------------------------------- */
/* INTERFACE TO mfeval                                              */
/* ---------------------------------------------------------------- */
int inter_mfeval(char * fname)

{
	int mx,nx,lx,mmf,nmf,lmf,mp,np,lp,ly,ierr,one,i;
	int m_hedge,n_hedge,l_hedge,m_not_flag,n_not_flag,l_not_flag;
	CheckRhs(3,5);
	CheckLhs(1,1);
	GetRhsVar(1,"d",&mx,&nx,&lx);
	GetRhsVar(2,"c",&mmf,&nmf,&lmf);
	GetRhsVar(3,"d",&mp,&np,&lp);
	if (Rhs>=4)
	  GetRhsVar(4,"d",&m_hedge,&n_hedge,&l_hedge);
	
	if (Rhs>=5)
	  GetRhsVar(5,"d",&m_not_flag,&n_not_flag,&l_not_flag);
	
	if (mp!=1) {
		Scierror(999,"This member function need a row vector parameters.");
		ierr=1;
	} else {
		if ((strncmp(cstk(lmf),"linear",6)==0) | (strncmp(cstk(lmf),"constant",8)==0)) {
			one=1;
		} else {
			one=nx;
		}
		CreateVar(Rhs+1,"d",&mx,&one,&ly);
		
		F2C(mfeval)(cstk(lmf),stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);
		if (strncmp(cstk(lmf),"linear",6)==0)  {
		  ;
		} else if (strncmp(cstk(lmf),"constant",8)==0) {
		  if (Rhs>=5 && m_not_flag==1 && n_not_flag==1 && stk(l_not_flag)[0])
		    for(i=0;i<mx*one;i++)
		      stk(ly)[i]=1.0 - stk(ly)[i];
			
		} else {
		  if (Rhs>=4 && m_hedge==1 && n_hedge==1 && stk(l_hedge)[0]>0.001 )
		    for(i=0;i<mx*one;i++)
		      stk(ly)[i]=pow(stk(ly)[i],stk(l_hedge)[0]);
		  
		  if (Rhs>=5 && m_not_flag==1 && n_not_flag==1 && stk(l_not_flag)[0])
		    for(i=0;i<mx*one;i++)
		      stk(ly)[i]=1.0 - stk(ly)[i];
		  
			
		}
	}

	if (ierr==0) {
		LhsVar(1)=Rhs+1;
	}

	return 0;
}


/* ---------------------------------------------------------------- */
/* INTERFACE TO tnorm                                               */
/* ---------------------------------------------------------------- */
extern int F2C(ctnorm) (char *class1, double *x, int *m, int *n, double *par, int *npar, double *y, int *ierr);

int inter_tnorm(char * fname)
{
	int mx,nx,lx,mc,nc,lc,extra,ly,icero=0,one=1,mp,np,lp,ierr;
	double dcero=0.0;
	CheckRhs(2,3);
	CheckLhs(1,1);
	GetRhsVar(1,"d",&mx,&nx,&lx);
	GetRhsVar(2,"c",&mc,&nc,&lc);
	extra=0;
	if ((strncmp(cstk(lc),"dubois",6)==0) | (strncmp(cstk(lc),"yager",5)==0)) {
		extra =1;
	}
	
	if (extra==0) {
		CreateVar(3,"d",&mx,&one,&ly);
		F2C(ctnorm)(cstk(lc),stk(lx),&mx,&nx,&dcero,&icero,stk(ly),&ierr);
	} else {
		mp=0;
		if (Rhs==3) {
			GetRhsVar(3,"d",&mp,&np,&lp);
		}

		if (mp!=1) {
			Scierror(999,"This t-norm class need a row vector of parameters.");
			ierr=1;
		} else {
			CreateVar(4,"d",&mx,&one,&ly);
			F2C(ctnorm)(cstk(lc),stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);
		}
	}

	if (ierr==0) {
		LhsVar(1)=3+extra;
	}
	return 0;
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO snorm                                               */
/* ---------------------------------------------------------------- */
extern int F2C(csnorm) (char *class1, double *x, int *m, int *n, double *par, int *npar, double *y, int *ierr);

int inter_snorm(char * fname)
{
	int mx,nx,lx,mc,nc,lc,extra,ly,icero=0,one=1,mp,np,lp,ierr;
	double dcero=0.0;
	CheckRhs(2,3);
	CheckLhs(1,1);
	GetRhsVar(1,"d",&mx,&nx,&lx);
	GetRhsVar(2,"c",&mc,&nc,&lc);
	extra=0;
	if ((strncmp(cstk(lc),"dubois",6)==0) | (strncmp(cstk(lc),"yager",5)==0)) {
		extra =1;
	}
	
	if (extra==0) {
		CreateVar(3,"d",&mx,&one,&ly);
		F2C(csnorm)(cstk(lc),stk(lx),&mx,&nx,&dcero,&icero,stk(ly),&ierr);
	} else {
		mp=0;
		if (Rhs==3) {
			GetRhsVar(3,"d",&mp,&np,&lp);
		}

		if (mp!=1) {
			Scierror(999,"This s-norm class need a row vector of parameters.");
			ierr=1;
		} else {
			CreateVar(4,"d",&mx,&one,&ly);
			F2C(csnorm)(cstk(lc),stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);
		}
	}

	if (ierr==0) {
		LhsVar(1)=3+extra;
	}
	return 0;
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO defuzzm                                             */
/* ---------------------------------------------------------------- */
extern int F2C(defuzzm) (char *method, double *x, int *m, double *y, double *ou, int *ierr);
int inter_defuzzm(char * fname)
{
	int mx,nx,lx;
	int my,ny,ly;
	int mmethod,nmethod,lmethod;
	int ione=1,lout;
	int ierr;
	CheckRhs(3,3);
	CheckLhs(1,1);
	GetRhsVar(1,"d",&mx,&nx,&lx);
	GetRhsVar(2,"d",&my,&ny,&ly);
	GetRhsVar(3,"c",&mmethod,&nmethod,&lmethod);
	if (mx!=my) {
		Scierror(999,"Column vector must have the same size!");
		ierr=1;
	} else {
		if ((nx!=1)|(ny!=1)) {
			Scierror(999,"The first two parameters must be a column vector");
			ierr=1;
		} else {
			CreateVar(4,"d",&ione,&ione,&lout);
			F2C(defuzzm)(cstk(lmethod),stk(lx),&mx,stk(ly),stk(lout),&ierr);
		}
	}	

	if (ierr==0) {
		LhsVar(1)=4;
	}
	return (0);
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO repvecc                                             */
/* ---------------------------------------------------------------- */
extern int F2C(repvecc) (double *y, double *x, int *m, int *n);
int inter_repvecc(char * fname)
{
	int d,m,n,x,y;
	CheckRhs(2,2);
	CheckLhs(1,1);
	GetRhsVar(1,"i",&d,&d,&n);
	GetRhsVar(2,"d",&m,&d,&x);
	CreateVar(3,"d",&m,istk(n),&y);
	F2C(repvecc)(stk(y),stk(x),&m,istk(n));
	LhsVar(1)=3;
	return(0);
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO repvec                                              */
/* ---------------------------------------------------------------- */
extern int F2C(repvec) (double *y, double *x, int *m, int *n);
int inter_repvec(char * fname)
{
	int d,m,n,x,y;
	CheckRhs(2,2);
	CheckLhs(1,1);
	GetRhsVar(1,"i",&d,&d,&m);
	GetRhsVar(2,"d",&d,&n,&x);
	CreateVar(3,"d",istk(m),&n,&y);
	F2C(repvec)(stk(y),stk(x),istk(m),&n);
	LhsVar(1)=3;
	return(0);
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO fltmulnor                                           */
/* ---------------------------------------------------------------- */
extern int F2C(fltmulnor) (double *x, int *m, int *n, double *y);
int inter_fltmulnor(char *fname)
{
	int m,n,one=1,x,y;
	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1,"d",&m,&n,&x);
	CreateVar(2,"d",&m,&one,&y);
	F2C(fltmulnor)(stk(x),&m,&n,stk(y));
	LhsVar(1)=2;
	return(0);
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO fltsumnor                                           */
/* ---------------------------------------------------------------- */
extern int F2C(fltsumnor) (double *x, int *m, int *n, double *y);
int inter_fltsumnor(char *fname)
{
	int m,n,one=1,x,y;
	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1,"d",&m,&n,&x);
	CreateVar(2,"d",&m,&one,&y);
	F2C(fltsumnor)(stk(x),&m,&n,stk(y));
	LhsVar(1)=2;
	return(0);
}



/* FOR TEST */
extern int F2C(fltcd) (double *destin, double *source, int* length);
int inter_sp01(char *fname)
{
	int m,n,z,x,y;
	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1,"d",&m,&n,&x);
	CreateVar(2,"d",&m,&n,&y);
	z=m*n;
	F2C(fltcd)(stk(y),stk(x),&z);
	LhsVar(1)=2;
	return(0);
}

// int inter_sp02(char *fname)
// {
// 	int m,n,z,x,y,one=1;
// 	CheckRhs(1,1);
// 	CheckLhs(1,1);
// 	GetRhsVar(1,"d",&m,&n,&x);
// 	CreateVar(2,"d",&m,&n,&y);
// 	z=m*n;
// 	//C2F(fltcd)(stk(y),stk(x),&z);
// 	F2C(dcopy)(&z,stk(x),&one,stk(y),&one);
// 	LhsVar(1)=2;
// 	return(0);
// }