mode(-1);
// ----------------------------------------------------------------------
// Fuzzy Optimization
// The function have 2 input and 1 output
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
write(%io(2),' Please wait... generating demo');

// Input Space
x1=linspace(-3,3,12)';
x2=linspace(0,6,12)';
Xp=genspace(x1,x2);

// Output
Y=sinc((Xp(:,1)+(Xp(:,2)-3).^2));

mj=[3 3]; // Number of partitions for each input components
epsilon=sqrt(%eps); // Minimum objetive function change
maxiter=10; // Maximum of iterations
verbose=%t; // Show information on screen
//console('on'); // Active console - Only information
// Compute values
[THETA,PSI,Ck,fls]=optfls01(Xp,Y,mj,epsilon,maxiter,verbose)

// Display information on screen
scf();clf();
nx1=length(x1);
nx2=length(x2);
Zf=matrix(evalfls(Xp,fls),nx1,nx2);
Zr=matrix(Y,nx1,nx2);

subplot(2,2,1);
plot3d(x1,x2,Zr,leg='x1@x2@y',theta=230,alpha=62);
h=get("hdl");
f=get("current_figure");
f.color_map=[linspace(0,1,128)' linspace(1,0,128)' ones(128,1)];
h.color_flag=1;
xtitle('Real function');

subplot(2,2,2);
plot3d(x1,x2,Zf,leg='x1@x2@y',theta=230,alpha=62);
h=get("hdl");
f=get("current_figure");
f.color_map=[linspace(0,1,128)' linspace(1,0,128)' ones(128,1)];
h.color_flag=1;
xtitle('Fuzzy approximation');

subplot(2,2,3);
plot3d(x1,x2,(Zf-Zr),leg='x1@x2@e',theta=230,alpha=65);
h=get("hdl");
f=get("current_figure");
f.color_map=[linspace(0,1,128)' linspace(1,0,128)' ones(128,1)];
h.color_flag=1;
xtitle('Approximation error');

subplot(2,2,4);
plot(Ck,'o-r');
xtitle('Iteration objetive function','k','Ck');

