mode(-1);
// ----------------------------------------------------------------------
// T-NORM GALLERY
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

nx=20;
ny=20;
x=linspace(0,1,nx)';
y=linspace(0,1,ny)';
XY=genspace(x,y);
L1=list();
L1($+1)=list("min",[]);
L1($+1)=list("aprod",[]);
L1($+1)=list("eprod",[]);
L1($+1)=list("dprod",[]);
L1($+1)=list("yager",1);
L1($+1)=list("dubois",0.5);

scf();clf();
h=gcf();
h.visible="off";
for j=1:length(L1),
	class1=L1(j)(1);
	par=L1(j)(2);
	if (par==[])
		z=tnorm(XY,class1);
	else
		z=tnorm(XY,class1,par);
	end
	z=matrix(z,ny,nx)';
	subplot(3,2,j);
	plot3d(x,y,z,leg="x@y@tnorm([x y])",theta=230,alpha=30);
	f=get("current_figure");
	g=get("hdl");
	f.color_map=jetcolormap(128);
	g.color_flag=1;
	xtitle(class1+" T-Norm Class")
end
h.visible="on";
