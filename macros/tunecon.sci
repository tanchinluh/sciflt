function [fls,merr]=tunecon(fls,idata,odata,nout,verbose)
//
//Calling Sequence
//
//Parameters
//
//Description
//
//Examples
//
//See also
//
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Adapt Takagi-Sugeno Consecuents using Last Square
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

// CHECK RHS AND GET SOME IMPORTANT DATA
if (argn(2)<4) then
	error("tunecon need at least 4 parameters");
end

if (argn(2)==4) then
	verbose=%t;
end

if (typeof(fls)~="fls") then
	error("The first argument must be a fls structure.");
end

ninputs=length(fls.input);
noutputs=length(fls.output);
if (size(idata,2)~=ninputs) then
	error("Incorrect size of idata.");
end
if ((int(nout)~=nout)|(nout<1)|(nout>noutputs)) then
	error("Incorrect nout");
end

if ((size(odata,2)~=1)|(size(odata,1)~=size(idata,1))) then
	error("Incorrect size of odata");
end

npp=size(idata,1);
nrules=size(fls.rule,1);

// CALCULATE INITIAL INFORMATION ...
[Y1,tmp2]=evalfls(idata,fls);
Y1=Y1(:,nout);
E1=odata-Y1;
if (verbose) then
	m1=max(abs(E1));
	ms1=sqrt(sum(E1.^2)/size(E1,1));
	write(%io(2),"Initial information:");
	write(%io(2)," max error = "+string(m1));
	write(%io(2)," MSSE      = "+string(ms1));
end


// GET PARAMETER TO TUNE
if (verbose) then
	write(%io(2),"Getting parameters to tune");
end

A=[];nptt=0;
for rul=1:nrules,
	idx=abs(fls.rule(rul,ninputs+nout));
	if idx>0 then
		if (fls.output(nout).mf(idx).type=="linear") then
			for j=1:ninputs,
				A=[A idata(:,j).*tmp2(:,rul)];
			end
			nptt=nptt+ninputs;
		end
		A=[A ones(npp,1).*tmp2(:,rul)];
		nptt=nptt+1;
	end
end

if (verbose) then
	write(%io(2)," Parameter to tune="+string(nptt));
end

if (verbose) then
	write(%io(2),"CALCULATING....");
end

// TUNE PARAMETERS
if (fls.defuzzMethod=="wtaver") then
	tmp3=zeros(npp,1);
	for rul=1:nrules,
		if (fls.rule(rul,ninputs+nout)~=0) then
			tmp3=tmp3+tmp2(:,rul)*fls.rule(rul,$);
		end				
	end
	idx=find(tmp3~=0);
	if (length(idx)~=npp) then
		warning("To some pairs of inputs some rules was unfired... I discard this...");
	end
	pp1=lsq(A(idx,:),odata(idx).*tmp3(idx));
else
	pp1=lsq(A,odata);
end

// UPDATE FLS STRUCTURE

if (verbose) then
	write(%io(2),"Updating fls structure....");
end
for rul=1:nrules,
	idx=abs(fls.rule(rul,ninputs+nout));
	if idx>0 then
		if (fls.output(nout).mf(idx).type=="linear") then
			fls.output(nout).mf(idx).par=pp1(1:ninputs+1)';
			pp1(1:ninputs+1)=[];
		else
			fls.output(nout).mf(idx).par=pp1(1);
			pp1(1)=[];
		end
	end
end

// CALCULATE FINAL STATUS AND REPORT
[Y1]=evalfls(idata,fls);
Y1=Y1(:,nout);
E1=odata-Y1;
m1=max(abs(E1));
ms1=sqrt(sum(E1.^2)/size(E1,1));

if (verbose) then
	write(%io(2),"Final information:");
	write(%io(2)," max error = "+string(m1));
	write(%io(2)," MSSE      = "+string(ms1));
end

merr=[m1 ms1];

endfunction

