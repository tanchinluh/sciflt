function fls=addmf(fls_input,input_output,var_index,mf_name,mf_type,mf_par)
//Add a new member function to a fls structure
// Calling Sequence
// fls=addmf( fls_input, input_output , var_index , mf_name , mf_type , mf_par )
// Parameters
// fls_input: fuzzy logic system (as input).
// fls:fuzzy logic system (as output).
// input_output:string. <literal>"input"</literal> for input variable,  <literal>"output"</literal> for output variable.
// var_index: integer. Variable number.
// mf_name: string. Member function tag-name
// mf_type:string. Member function type.
// mf_par:row vector of reals. Member function parameters.
// Description
//          <literal>addmf </literal> add a new member function to fuzzy logic system
//    <literal>fls_input</literal> and return it with this change as <literal>fls</literal>.
//    This command only add the member function named <literal>mf_name</literal> with
//    type <literal>mf_type</literal> and parameters <literal>mf_par</literal> if the
//    variable <literal>var_index</literal> exist as input or output (depends of
//    <literal>input_output</literal> parameter).
//Examples
//fls=newfls("m");
//fls=addvar(fls,"input","speed",[0 100]);
//fls=addmf(fls,"input",1,"low","trimf",[-50 0 50]);
//fls=addmf(fls,"input",1,"med","trimf",[0 50 100]);
//fls=addmf(fls,"input",1,"high","trimf",[50 100 150]);
//plotvar(fls,"input",1);
// See also
// addvar
// delvar
// delmf
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

// ----------------------------------------------------------------------
// Add member function
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

if (argn(2)~=6) then
	error('addmf needs six parameters.');
end

if (size(mf_par,"*")~=size(mf_par,2)) then
	error("The member function parameters must be a row vector!");
end

fls=fls_input;
flsmf=tlist(['flsmf','name','type','par'],string(mf_name),string(mf_type),mf_par);

if (input_output=='input') then
	nvar=length(fls.input);
	if (var_index>nvar) then
		error('Incorrect variable index.');
	else
		fls.input(var_index).mf($+1)=flsmf;
	end

elseif (input_output=='output') then
	nvar=length(fls.output);
	if (var_index>nvar) then
		error('Incorrect variable index.');
	else
		fls.output(var_index).mf($+1)=flsmf;
	end
else
	error('Wrong input/output');
end

endfunction

