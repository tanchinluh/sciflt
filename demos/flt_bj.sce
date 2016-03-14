mode(-1);
// ----------------------------------------------------------------------
// Box and Jenkins furnace data from:
// G.E.P. Box and G.M. Jenkins
// Time Series Analysis, Forecasting and Control
// San Francisco, Holden Day, 1970,  pp. 532-533
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

// GET DATA
M=fscanfMat(flt_path()+"demos/bj.txt");
y=M(:,1); // y(t)
x=[M(:,2) M(:,9)]; // take y(t-1) and u(t-4) -> CLASIC APROACH
domI=[min(x,'r')' max(x,'r')']; // detect the input domain
domO=[min(y) max(y)];
fls=initialfls(2,domI,domO,[5;5]);
[fls,merr]=tunecon(fls,x,y,1,%f);
y2=evalfls(x,fls);
scf();clf();
subplot(3,1,1);
ts=(1:size(x,1))';
plot2d(ts,[y y2],leg="real@fuzzy");
xtitle("Box and Jenkins Example","sample","output");
subplot(3,1,2);
plot2d(ts,M(:,6));
xtitle("","sample","u(t-1)");
subplot(3,1,3);
plot2d(ts,abs(y-y2));
xtitle("","sample","absolute error");

