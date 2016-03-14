function fls=delvar(fls_input,var_type,var_idx)
//Delete variable in fls and return it with this change.
//Calling Sequence
//fls=delvar( fls_input, var_type , var_idx)
//Parameters
//fls_input:fuzzy logic system (as input).
//var_type:string. "input" for input variable, "output" for output variable.
//var_idx:integer. Variable number.
//Description
// <literal>delvar </literal> delete a variable from fuzzy logic system
//    <literal>fls_input</literal> and return it with this change as <literal>fls</literal>.
//    This command delete the <literal>var_idx</literal> variable (depends of
//    <literal>var_type</literal> parameter) and all associated member functions. If
//    the fuzzy logic system have rules, then fix the rules reflecting the
//    change.
//Examples
//fls=newfls("m");
//fls=addvar(fls,"input","speed",[0 100])
//fls=addvar(fls,"input","temperature",[0 150])
//// DELETE THE FIRST VARIABLE
//fls=delvar(fls,"input",1)
//See also
//addvar
//delmf
//addmf
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Delete variable
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

if (argn(2)~=3) then
	error('delvar needs tree parameters.');
end

fls=fls_input;

if (var_type=='input') then
	if (var_idx>length(fls.input)) then
		error("This input no exist!.")
	end
	fls.input(var_idx)=null();
	idx=var_idx;

elseif (var_type=='output') then
	if (var_idx>length(fls.output)) then
		error("This output no exist!.")
	end
	fls.output(var_idx)=null();
	idx=length(fls.input)+var_idx;

else
	error('Wrong type.');
end

// DELETE COLUMN IN MATRIX OF RULES IF EXIST SOME RULE AND THE SIZE WAS CORRECT

rule=fls.rule;
nrule=size(rule,1);
if (nrule>0) then
	if (size(rule,2)==((length(fls.input)+length(fls.output)+3))) then
		fls.rule=[rule(:,1:(idx-1)) rule(:,(idx+1):$)];		
	else
		warning("The fuzzy logic system have a bad table of rules!");
	end
end

endfunction
