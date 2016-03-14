mode(-1);
// ----------------------------------------------------------------------
// DEFUZZIFICATION GALLERY
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

l1=["centroide" "bisector" "mom" "som" "lom"];
x=linspace(-10,10,1001)';
scf();clf();

// FIRST EXAMPLE
subplot(2,1,1);
mf1=trapmf(x,[-10, -8, -2, 2]);
mf2=trapmf(x,[-5, -3, 2, 4]);
mf3=trapmf(x,[2, 3, 8, 9]);
y=max(0.5*mf2, max(0.9*mf1,0.1*mf3));
plot2d(x,y,rect=[-10 0 10 1]);
xtitle("Defuzzification Gallery","x","y");
for j=1:size(l1,"*");
	yr=defuzzm(x,y,l1(j));
	yy=1-j*0.15;
	plot2d3(yr,yy,rect=[-10 0 10 1],style=j+2);
	xstring(yr,yy,l1(j)+"="+string(yr));
end

// SECOND EXAMPLE
subplot(2,1,2);
mf1=gaussmf(x,[2,-5]);
mf2=trapmf(x,[-5, -3, 2, 4]);
mf3=gaussmf(x,[4,5]);
y=max(0.7*mf2, max(0.5*mf1,0.2*mf3));
plot2d(x,y,rect=[-10 0 10 1]);
xtitle("Defuzzification Gallery","x","y");
for j=1:size(l1,"*");
	yr=defuzzm(x,y,l1(j));
	yy=1-j*0.15;
	plot2d3(yr,yy,rect=[-10 0 10 1],style=j+2);
	xstring(yr,yy,l1(j)+"="+string(yr));
end

