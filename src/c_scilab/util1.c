/* util1.f -- translated by f2c (version 20060506).
   You must link the resulting object file with libf2c:
	on Microsoft Windows system, link with libf2c.lib;
	on Linux or Unix systems, link with .../path/to/libf2c.a -lm
	or, if you install libf2c.a in a standard place, with -lf2c -lm
	-- in that order, at the end of the command line, as in
		cc *.o -lf2c -lm
	Source for libf2c is in /netlib/f2c/libf2c.zip, e.g.,

		http://www.netlib.org/f2c/libf2c.zip
*/

#include "f2c.h"

/* Table of constant values */

static integer c__1 = 1;

/* ----------------------------------------------------------------------- */
/* UTILITY */
/* ----------------------------------------------------------------------- */
/* This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox ) */
/* Copyright (C) @YEARS@ Jaime Urzua Grez */
/* mailto:jaime_urzua@yahoo.com */

/* Holger Nahrstaedt */
/* ----------------------------------------------------------------------- */
/* This program is free software; you can redistribute it and/or modify */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation; either version 2 of the License, or */
/* (at your option) any later version. */
/* ----------------------------------------------------------------------- */
/* CHANGES */
/* 2004-11-03 Change matrix initialization -> Unrolled */
/*            Fix isgn error */
/* 2004-11-04 Unroll getmr, optimize getmw, add dicopy, add idcopy, */
/*            Unroll dolinspa */
/* 2006-08-28 Add repvec function */
/* 2006-09-03 Add repvecc function */
/* 2006-09-06 Change dcopy by fltcd */
/* ----------------------------------------------------------------------- */
/* -------------------------------------------------- */
/* Repeat a column vector y(:,1:n)=x */
/* -------------------------------------------------- */
/* Subroutine */ int repvecc_(doublereal *y, doublereal *x, integer *m, 
	integer *n)
{
    /* System generated locals */
    integer y_dim1, y_offset, i__1;

    /* Local variables */
    static integer j;
    extern /* Subroutine */ int dcopy_(integer *, doublereal *, integer *, 
	    doublereal *, integer *);

    /* Parameter adjustments */
    --x;
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;

    /* Function Body */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	dcopy_(m, &x[1], &c__1, &y[j * y_dim1 + 1], &c__1);
/*        call fltcd(y(1,j),x,m) */
/* L10: */
    }
    return 0;
} /* repvecc_ */

/* -------------------------------------------------- */
/* Repeat a row vector y(1:m,:)=x */
/* -------------------------------------------------- */
/* Subroutine */ int repvec_(doublereal *y, doublereal *x, integer *m, 
	integer *n)
{
    /* System generated locals */
    integer y_dim1, y_offset, i__1;

    /* Local variables */
    static integer j;
    extern /* Subroutine */ int uinival_(doublereal *, integer *, doublereal *
	    );

    /* Parameter adjustments */
    --x;
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;

    /* Function Body */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	uinival_(&y[j * y_dim1 + 1], m, &x[j]);
/* L10: */
    }
    return 0;
} /* repvec_ */

/* -------------------------------------------------- */
/* Unrolled matrix initialization */
/* -------------------------------------------------- */
/* Subroutine */ int uinival_(doublereal *x, integer *sz, doublereal *va)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, m;

    /* Parameter adjustments */
    --x;

    /* Function Body */
    m = *sz % 5;
    if (m == 0) {
	goto L20;
    }
    i__1 = m;
    for (i__ = 1; i__ <= i__1; ++i__) {
	x[i__] = *va;
/* L10: */
    }
    if (*sz < 5) {
	return 0;
    }
L20:
    ++m;
    i__1 = *sz;
    for (i__ = m; i__ <= i__1; i__ += 5) {
	x[i__] = *va;
	x[i__ + 1] = *va;
	x[i__ + 2] = *va;
	x[i__ + 3] = *va;
	x[i__ + 4] = *va;
/* L30: */
    }
    return 0;
} /* uinival_ */

/* -------------------------------------------------- */
/* INTEGER SIGN */
/* -------------------------------------------------- */
integer isgn_(integer *n)
{
    /* System generated locals */
    integer ret_val;

    if (*n > 0) {
	ret_val = 1;
    } else if (*n == 0) {
	ret_val = 0;
    } else {
	ret_val = -1;
    }
    return ret_val;
} /* isgn_ */

/* -------------------------------------------------- */
/* INTEGER SIGN */
/* -------------------------------------------------- */
doublereal hedge_(doublereal *n)
{
    /* System generated locals */
    doublereal ret_val, d__1, d__2;

    /* Builtin functions */
    double d_int(doublereal *), d_nint(doublereal *);

    d__2 = abs(*n);
    d__1 = (abs(*n) - d_int(&d__2)) * 100.;
    ret_val = d_nint(&d__1) / 10.;
    return ret_val;
} /* hedge_ */

/* -------------------------------------------------- */
/* GET MATRIX OF WEIGTHS */
/* -------------------------------------------------- */
/* Subroutine */ int getmw_(doublereal *rule, integer *nrules, integer *
	ninputs, integer *noutputs, doublereal *mwe)
{
    /* System generated locals */
    integer rule_dim1, rule_offset;

    /* Local variables */
    extern /* Subroutine */ int dcopy_(integer *, doublereal *, integer *, 
	    doublereal *, integer *);

    /* Parameter adjustments */
    rule_dim1 = *nrules;
    rule_offset = 1 + rule_dim1;
    rule -= rule_offset;
    --mwe;

    /* Function Body */
    dcopy_(nrules, &rule[(*ninputs + *noutputs + 2) * rule_dim1 + 1], &c__1, &
	    mwe[1], &c__1);
    return 0;
} /* getmw_ */

/* -------------------------------------------------- */
/* Make x=int(y(1:sz)) */
/* -------------------------------------------------- */
/* Subroutine */ int dicopy_(doublereal *x, integer *y, integer *sz)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, m;

    /* Parameter adjustments */
    --y;
    --x;

    /* Function Body */
    m = *sz % 5;
    if (m == 0) {
	goto L20;
    }
    i__1 = m;
    for (i__ = 1; i__ <= i__1; ++i__) {
	y[i__] = (integer) x[i__];
/* L10: */
    }
    if (*sz < 5) {
	return 0;
    }
L20:
    ++m;
    i__1 = *sz;
    for (i__ = m; i__ <= i__1; i__ += 5) {
	y[i__] = (integer) x[i__];
	y[i__ + 1] = (integer) x[i__ + 1];
	y[i__ + 2] = (integer) x[i__ + 2];
	y[i__ + 3] = (integer) x[i__ + 3];
	y[i__ + 4] = (integer) x[i__ + 4];
/* L30: */
    }
    return 0;
} /* dicopy_ */

/* -------------------------------------------------- */
/* Make x=dble(y(1:sz)) */
/* -------------------------------------------------- */
/* Subroutine */ int idcopy_(integer *x, doublereal *y, integer *sz)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, m;

    /* Parameter adjustments */
    --y;
    --x;

    /* Function Body */
    m = *sz % 5;
    if (m == 0) {
	goto L20;
    }
    i__1 = m;
    for (i__ = 1; i__ <= i__1; ++i__) {
	y[i__] = (doublereal) x[i__];
/* L10: */
    }
    if (*sz < 5) {
	return 0;
    }
L20:
    ++m;
    i__1 = *sz;
    for (i__ = m; i__ <= i__1; i__ += 5) {
	y[i__] = (doublereal) x[i__];
	y[i__ + 1] = (doublereal) x[i__ + 1];
	y[i__ + 2] = (doublereal) x[i__ + 2];
	y[i__ + 3] = (doublereal) x[i__ + 3];
	y[i__ + 4] = (doublereal) x[i__ + 4];
/* L30: */
    }
    return 0;
} /* idcopy_ */

/* -------------------------------------------------- */
/* Make x=(y(1:sz)) */
/* -------------------------------------------------- */
/* Subroutine */ int ddcopy_(doublereal *x, doublereal *y, integer *sz)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, m;

    /* Parameter adjustments */
    --y;
    --x;

    /* Function Body */
    m = *sz % 5;
    if (m == 0) {
	goto L20;
    }
    i__1 = m;
    for (i__ = 1; i__ <= i__1; ++i__) {
	y[i__] = x[i__];
/* L10: */
    }
    if (*sz < 5) {
	return 0;
    }
L20:
    ++m;
    i__1 = *sz;
    for (i__ = m; i__ <= i__1; i__ += 5) {
	y[i__] = x[i__];
	y[i__ + 1] = x[i__ + 1];
	y[i__ + 2] = x[i__ + 2];
	y[i__ + 3] = x[i__ + 3];
	y[i__ + 4] = x[i__ + 4];
/* L30: */
    }
    return 0;
} /* ddcopy_ */

/* -------------------------------------------------- */
/* CREATE A LINEAR SPACE */
/* -------------------------------------------------- */
/* Subroutine */ int dolinspa_(doublereal *mindom, doublereal *maxdom, 
	integer *npart, doublereal *x)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, m;
    static doublereal dt;

    /* Parameter adjustments */
    --x;

    /* Function Body */
    dt = (*maxdom - *mindom) / (*npart - 1);
    m = *npart % 5;
    if (m == 0) {
	goto L20;
    }
    i__1 = m;
    for (i__ = 1; i__ <= i__1; ++i__) {
	x[i__] = *mindom + dt * (i__ - 1);
/* L10: */
    }
    if (*npart < 5) {
	return 0;
    }
L20:
    ++m;
    i__1 = *npart;
    for (i__ = m; i__ <= i__1; i__ += 5) {
	x[i__] = *mindom + dt * (i__ - 1);
	x[i__ + 1] = *mindom + dt * i__;
	x[i__ + 2] = *mindom + dt * (i__ + 1);
	x[i__ + 3] = *mindom + dt * (i__ + 2);
	x[i__ + 4] = *mindom + dt * (i__ + 3);
/* L30: */
    }
    return 0;
} /* dolinspa_ */

