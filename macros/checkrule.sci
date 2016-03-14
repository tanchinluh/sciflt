function [all_ok,mes]=checkrule(fls)
//Check rules in fls structure
//Calling Sequence
//[all_ok,mes]=checkrule(fls)
//Parameters
//fls:fls structure
//all_ok: scalar, if all_ok is greater than 0 the some or all rules have incorrect representation.
//mes: string. Return a error message.
//Description
//  <literal>checkrule</literal> verify the rule representation in the fls   structure.
//  Examples
//  // GET A FLS
//  fls=loadfls(flt_path()+"demos/fan1.fls");
//[all_ok,mes]=checkrule(fls);
//if (all_ok>0) then
// warning(mes);
//end
//// Make the first rule invalid
//fls.rule(1,1)=500;
//[all_ok,mes]=checkrule(fls);
//if (all_ok>0) then
// warning(mes);
//end
//See also
//fls_structure
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

// ----------------------------------------------------------------------
// Check Rules
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

// Check Parameter
if (argn(2)==1) then
	if (typeof(fls)~="fls") then
		error("The parameter must be a fls.");
	end
else
	error("This function need one parameter.");
end

all_ok=0;
mes='';
nimp=length(fls.input);
nout=length(fls.output);

// Check matrix rule
rule=fls.rule;
n1=size(rule,2);
if (n1~=(nimp+nout+2)) then
	all_ok=1; // Inconsistent dimension
	mes='Inconsistent dimension.';
	return;

else
	r1=rule(:,1:(nimp+nout));
// 	oo=find(int(r1)~=r1,1);
// 	if (length(oo)~=0) then
// 		all_ok=2; // Inconsisten rule
// 		mes='Inconsistent rule.';
// 		return;
// 	end

	andor=rule(:,$-1);
	oo=find((andor==0)|(andor==1));
	if (length(oo)~=size(rule,1)) then
		all_ok=3; // Inconsistent and or
		mes='Inconsistent AND or OR.';
		return;
	end
	
	tocompare=[];
	for j=1:nimp,
		tocompare=[tocompare length(fls.input(j).mf)];
	end
	for j=1:nout,
		tocompare=[tocompare length(fls.output(j).mf)];
	end

	for j=1:size(rule,1),
		oo=find(int(rule(j,1:(nimp+nout)))>tocompare,1);
		if (length(oo)>0) then
			all_ok=2; // Inconsistent rule
			mes='Inconsistent rule.';
			return;
		end
	end

	oo=find(rule(:,(nimp+nout+1):$-2)<0);
	if (length(oo)>0) then
		all_ok=4; // Inconsistent output
		mes='Inconsistent output.';
	end
end

endfunction


