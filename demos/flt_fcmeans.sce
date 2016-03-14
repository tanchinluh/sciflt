mode(-1);
// ----------------------------------------------------------------------
// Fuzzy C-Means example
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
// CHANGES
// 2006-08-26 Spell check and better graphics presentation

// Load dataset
dta=fscanfMat(flt_path()+"demos/iris.txt");

// Extract type
idx1=find(dta(:,$)==1);
idx2=find(dta(:,$)==2);
idx3=find(dta(:,$)==3);

// Find Clusters
[centers,U,ofun,ofunk,em]=fcmeans(dta(:,1:4),3,2,50,1e-3);

// Plot Data
g1=[1 2;1 3;1 4; 2 3; 2 4; 3 4];
scf();clf();
subplot(4,1,1)
xstring(0,0.8,"Fuzzy C-Means Example");
xstring(0,0.6,"Iris example");
subplot(4,2,2);
plot(ofunk,'r-');
xtitle("Objetive function","k");
mm=[min(dta,'r');max(dta,'r')];
for j=1:6,
	subplot(4,2,j+2);
	plot(dta(idx1,g1(j,1)),dta(idx1,g1(j,2)),'rd');
	plot(dta(idx2,g1(j,1)),dta(idx2,g1(j,2)),'bd');
	plot(dta(idx3,g1(j,1)),dta(idx3,g1(j,2)),'gd');
	xtitle("","x"+string(g1(j,1)),"x"+string(g1(j,2)));
	for t=1:3,
		plot(centers(t,g1(j,1)),centers(t,g1(j,2)),'k.');
	end
end

