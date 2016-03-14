mode(-1);
// ----------------------------------------------------------------------
// AND operation example (T-Norm)
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

x=[0:0.1:10]';
y1=gaussmf(x,[3 1.2]);
y2=gaussmf(x,[7 1]);
yy1=tnorm([y1 y2],'min');
yy2=tnorm([y1 y2],'aprod');
yy3=tnorm([y1 y2],'dprod');
yy4=tnorm([y1 y2],'eprod');
scf();clf();
subplot(2,1,1);
plot2d(x,[y1 y2],leg='mf1@mf2',rect=[0 -0.1 10 1.1]);
xtitle('Member Function Evaluation','x','mu(x)');
subplot(2,1,2);
plot2d(x,[yy1 yy2 yy3 yy4],leg='min@prod@dprod@eprod',rect=[0 -0.1 10 1.1]);
xtitle('AND OPERATION','x','and(mf1,mf2)');
