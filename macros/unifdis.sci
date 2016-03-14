function fls=unifdis(fls_input,var_type,var_id,mf_type,mf_name,nmf,p1)
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
// Create a uniform distributed member function
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

if (argn(2)<6) then
	error('unifdis needs at least six parameteres.');
end
fls=fls_input;

// Select variable to work
if (var_type=='input') then
	dom=fls.input(var_id).range;
	var=fls.input(var_id).mf;
elseif (var_type=='output') then
	adom=fls.output(var_id).range;
	var=fls.input(var_id).mf;
else
	error('Wrong type.');
end

// Work with variable
if (mf_type=='trimf') then
	// Triangular Member Function
	b=max(dom);
	a=min(dom);
	if (nmf<2) then
		error('triangular unifdis needs nmf>1');
	end
	dc=(b-a)/(nmf-1);
	flsmf=tlist(['flsmf','name','type','par'],'',string(mf_type),[]);
	pard=[-dc 0 dc];
	sp=linspace(a,b,nmf);
	for j=1:nmf,
		flsmf.name=string(mf_name)+'_'+string(j);
		flsmf.par=sp(j)+pard;
		var($+1)=flsmf;
	end

elseif (mf_type=='trapmf') then
	// Trapezoidal Member Function
	b=max(dom);
	a=min(dom);
	if (argn(2)~=7) then
		error('trapezoidal unifdis needs seven parameters.');
	elseif (par1<=0) then
		error('trapezoidal unifdis need p1>0');
	end
	if (nmf<2) then
		error('trapezoidal unifdis needs nmf>1');
	end
	h=(b-a)/((nmf-1)*(1+p1));
	dc=(b-a)/(nmf-1);
	flsmf=tlist(['flsmf','name','type','par'],'',string(mf_type),[]);
	pard=[-h*p -h/2 h/2 h/2+h*p];
	sp=linspace(a,b,nmf);
	for j=1:nmf
		flsmf.name=string(mf_name)+'_'+string(j);
		flsmf.par=sp(j)+pard;
		var($+1)=flsmf;
	end
	
else
	error('This type is not yet implemented in unifdis.');
end


// Make the change
if (var_type=='input') then
	fls.input(var_id).mf=var;
elseif (var_type=='output') then
	fls.input(var_id).mf=var;
end

endfunction

