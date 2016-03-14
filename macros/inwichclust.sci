function [pos,dis]=inwichclust(X,centers)
//Find associated cluster
//Calling Sequence
//po=inwichclust(X,centers)
//Parameters
//X:matrix of real. Data points.
// centers:matrix of real. Cluster centers.
// po:matrix of integers. Associated cluster of each point
//Description
//          <literal>inwichclust </literal> return the nearest cluster's center position
//     of the pair of data <emphasis role="bold">X</emphasis>.
//Examples
// // Generate 10 points centered in (1,1) (2,2) and (5,5)
//X=[1+rand(10,2);2+rand(10,2);5+rand(10,2)];
//centers=subclust(X);
//po=inwichclust(X,centers);
//See also
//fcmeans
//subclust
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Find inf wich cluster is X(i,:) in centers of clusters
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

// Check RHS
rhs=argn(2);

if (rhs~=2) then
	error("Incorret number of parameters.");
end

if (size(X,2)~=size(centers,2)) then
	error('Incompatible dimensions');
end

pos=[];dis=[];
npt=size(centers,1);
for i=1:size(X,1),
	[v,p]=min(sqrt(sum(repvec(npt,X(i,:))-centers,'c').^2));	
	pos=[pos;p];
	dis=[dis;v];
end

endfunction

