function fls=addvar(fls_input,var_type,var_name,var_range)
//Add a new variable to a fls and return it
//Calling Sequence
//fls=addvar( fls_input , var_type , var_name , var_range )
// Parameters
// fls_input: fuzzy logic system (as input).
// fls:fuzzy logic system (as output).
// var_type:string. <literal>"input"</literal> for input variable,  <literal>"output"</literal> for output variable.
//var_name: string. Variable tag-name.
//var_range: row vector with two elements <literal>[minDom MaxDom]</literal>.          Variable range, <literal>minDom</literal> for minimum value and           <literal>maxDom</literal> for maximum value of the variable.
// Description
//  <literal>addvar </literal> add a new variable to fuzzy logic system
//    <literal>fls_input</literal> and return it with this change as <literal>fls</literal>.
//    This command add the variable named <literal>var_name</literal> with range
//    <literal>[minDom, maxDom]</literal> in the input or output (depends of
//    <literal>var_type</literal> parameter). If the fuzzy logic system have rules,
//    add a new column in rules reflecting the new variable.
//Examples
//fls=newfls("m");
//fls=addvar(fls,"input","speed",[0 100]);
//fls=addvar(fls,"input","wind",[0 100]);
//fls=addvar(fls,"output","actuation",[0 10]);
//See also
//fls_structure
//delvar
//addmf
//delmf
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Add variable
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

if (argn(2)~=4) then
	error('addvar needs four parameters.');
end

if ((size(var_range,"*")~=size(var_range,2))&(size(var_range,"*")~=2)) then
	error("The range must be a row vector with 2 elements!");
end

fls=fls_input;
flsvar=tlist(['flsvar','name','range','mf'],string(var_name),var_range,list());

if (var_type=='input') then
	idx=length(fls.input);
	fls.input($+1)=flsvar;	

elseif (var_type=='output') then
	idx=length(fls.input)+length(fls.output);
	fls.output($+1)=flsvar;

else
	error('Wrong type.');
end

// ADD COLUMN IN MATRIX OF RULES IF EXIST SOME RULE AND THE SIZE WAS CORRECT

rule=fls.rule;
nrule=size(rule,1);
if nrule>0 then
	if (size(rule,2)==((length(fls.input)+length(fls.output)+1))) then
		fls.rule=[rule(:,1:idx) zeros(nrule,1) rule(:,(idx+1):$)];
	else
		warning("The fuzzy logic system have a bad table of rules!");
	end
end

endfunction
