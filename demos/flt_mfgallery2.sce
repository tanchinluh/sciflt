mode(-1)
// ----------------------------------------------------------------------
// Member Function Gallery
// ----------------------------------------------------------------------
// This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
// Copyright (C) @YEARS@ Jaime Urzua Grez
// mailto:jaime_urzua@yahoo.com
// 
// 2011 Holger Nahrstaedt
// ----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// ----------------------------------------------------------------------

scf();clf();
x=linspace(-1,1,50)';
x1=gaussmf(x,[0.3,0]);
x2=gaussmf(x,[1,0]);
z=matrix(tnorm(genspace(x1,x2),'aprod'),length(x),-1);
plot3d(x,x,z);




//mf($+1)=list('gaussmf',1,0);
//mf2($+1)=list('smf',[-8 -6]);
//mf2($+1)=list('zmf',[9 6]);
// Create an internal first-part list
//mf1=list();
//mf1($+1)=list('dsigmf',[-6 0.5 -4 1]);

//mf1($+1)=list('gbellmf',[-2 2 -4]);
//mf1($+1)=list('pimf',[3 4 7 8]);
//mf1($+1)=list('psigmf',[4 4.5 6 8]);

// Create an internal second-part list
//mf2=list();
//mf2($+1)=list('sigmf',[-1 0]);

//mf2($+1)=list('trapmf',[-3 -1 1 3]);
//mf2($+1)=list('trimf',[1 3 5]);


// Display
//xbasc();
//X=linspace(-10, 10, 200)';
//mfx='['+strcat(string(X),';')+']';

// First part
//Y=[];
//LEG="";
//for j=1:length(mf1);
//	Y=[Y mfeval(X,mf1(j)(1),mf1(j)(2))];
//	LEG=LEG+mf1(j)(1)+'@';
//end
//subplot(2,1,1);
//plot2d(X,Y,leg=LEG,rect=[-10,-0.1,10,1.1])
//xtitle('Member Function Evaluation','x','mu(x)');

// Second part
//Y=[];
//LEG="";
//for j=1:length(mf2);
//	Y=[Y mfeval(X,mf2(j)(1),mf2(j)(2))];
//	LEG=LEG+mf2(j)(1)+'@';
//end
//subplot(2,1,2);
//plot2d(X,Y,leg=LEG,rect=[-10,-0.1,10,1.1])
//xtitle('Member Function Evaluation','x','mu(x)');


