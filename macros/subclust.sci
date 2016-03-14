function centers=subclust(X,r,opt)
//Find cluster centers with substractive clustering.
//Calling Sequence
//[centers,sigmas]=subclust(X [,r [, opt ]])
//Parameters
//X:matrix of reals.The pairs of inputs points.
// r:real vector of real.
// opt:[1x3] vector of real.
// centers:integer, maximum number of iterations. The defaul value is 100
// sigmas:scalar, minimum change value between two consecutive iterations. The default value is 0.001
//Description
//
//          <emphasis role="bold">subclust</emphasis> find cluster centers with substractive clustering for
//     a matrix <emphasis role="bold">X</emphasis> in which each row contains a data point. r is a vector
//     that specifies a cluster center's range of influence in each of the data
//     dimensions, assuming the data falls within a unit hyperbox (internalli
//     relized).
//
//          <emphasis role="bold">opt=[ACCEPT_RATIO, REJECT_RATIO, REDUCTION_RATIO]</emphasis>. If opt is
//     not provided, then the routine use the followings: ACCEPT_RATIO=0.5,
//     REJECT_RATIO=0.15, REDUCTION_RATIO=1.5.
//Examples
// // Take 400 random pairs of points centered at (0,0), (3,3), (7,7) and (10,10)
//Xin=[rand(100,2);3+rand(100,2);7+rand(100,2);10+rand(100,2)];
// // Find clusters
//centers=subclust(Xin);
//See also
//fcmeans
//inwichclust
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

// ----------------------------------------------------------------------
// Subtractive Clustering
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
// NOTES:
// (1) The routine was developed using high vectorized forms
// ----------------------------------------------------------------------

// Check RHS
rhs=argn(2);

if (rhs<1)|(rhs>3) then
	error("Incorret number of parameters.");
end

ACCEPT_RATIO=0.5;
REJECT_RATIO=0.15;
REDUCTION_RATIO=1.5;
ra=0.5*ones(1,size(X,2));


if (rhs==2) then
	if (length(r)==1) then
		ra=r*ones(1,size(X,2));
	elseif (length(r)~=size(X,2)) then
		error("Incompatible size for parameter r");
	else
		ra=r;
	end
end
	
if (rhs==3) then
	if length(opt)~=3 then
		error("Incompatible size for parameter opt");
	else
		ACCEPT_RATIO=opt(1);
		REJECT_RATIO=opt(2);
		REDUCTION_RATIO=opt(3);		
	end
end


// Normalize data in a hypercube
npt=size(X,1);
p1=ones(npt,1).*.min(X,'r');
p2=ones(npt,1).*.max(X,'r');
dp=p2-p1;
dp(dp==0)=1;
Y=(X-p1)./dp;
Y=min(max(Y,0),1);
RA2=repvec(npt,(ra/2).^2);
rb=ra*REDUCTION_RATIO;
RB2=repvec(npt,(rb/2).^2)
// Find the first center taking in count the maximum density
D=[];
for i=1:npt,
	D=[D;sum(exp(-sum(((repvec(npt,Y(i,:))-Y).^2) ./ RA2,'c')))];
end
[Dmax,idx]=max(D);
centers=X(idx,:);
D1=Dmax;

// Find more centers using reduced density
goon=%t;
while goon
	Dt=D-Dmax*exp(-sum(((repvec(npt,Y(idx,:))-Y).^2) ./ RB2 ,'c'));
	Dt=max(Dt,0);
	[Dmax,idx]=max(Dt);
	goon=%f;
	if (Dmax/D1)>(ACCEPT_RATIO) then
		centers=[centers;X(idx,:)];
		D=Dt;
		goon=%t;
	elseif (REJECT_RATIO)<(Dmax/D1) then
		npt2=size(centers,1);
		dmin=min(sqrt(sum((repvec(npt2,Y(idx,:))-centers).^2,'c')));
		if ((dmin/ra)+(Dmax/D1))>1 then
			centers=[centers;X(idx,:)];
			D=Dt;
			goon=%t;			
		else
			D(idx)=0;
			goon=%t;
		end
	end
end

endfunction
