mode(-1);
// ----------------------------------------------------------------------
// Example
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
fls=loadfls(flt_path()+"demos/fan1.fls");
nx1=150;
nx2=150;
x1=linspace(40,120,nx1)';
x2=linspace(20,100,nx2)';
X=genspace(x1,x2);
Y=evalfls(X,fls);
Y=matrix(Y,nx2,nx1)';
scf();clf();
plot3d(x1,x2,Y);
