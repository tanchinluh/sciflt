mode(-1);
// ----------------------------------------------------------------------
// TUNE CONSECUENTS EXAMPLE
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

function xdot=chao1(t,x)
xdot=zeros(x);
xdot(1)=x(2);
xdot(2)=6*sin(t)-0.1*x(2)-x(1)^5;
endfunction
t=(0:0.1:50)';
x1=ode([2;1],0,t,chao1)';
// CREATE TRAINIG DATA SET AS [x(k) x(k-1)]
idata1=[x1(2:$-1,1) x1(1:$-2,1)];
odata1=x1(3:$,1);
// NOW I CREATE A INITIAL FLS TO TRAIN IT
fls=initialfls(2,[-3 3;-3 3],[-3 3],[3;3])
[fls,merr]=tunecon(fls,idata1,odata1,1);

// CREATE COMPARATION SET
x1=ode([1.5;1.5],0,t,chao1)';
idata2=[x1(2:$-1,1) x1(1:$-2,1)];
odata2=x1(3:$,1);

t=t(3:$);
scf();clf();
subplot(2,2,1);
x_f1=evalfls(idata1,fls);
plot2d(t,[odata1 x_f1],leg="real@approx");
xtitle("TRAINING INFORMATION","t","x(t)");
subplot(2,2,3);
plot2d(t,abs(odata1-x_f1));
xtitle("","t","error(t)");
subplot(2,2,2);
x_f2=evalfls(idata2,fls);
plot2d(t,[odata2 x_f2],leg="real@approx");
xtitle("COMPARATION SET","t","x(t)");
subplot(2,2,4);
plot2d(t,abs(odata2-x_f2));
xtitle("","t","error(t)");

