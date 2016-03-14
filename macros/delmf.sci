function fls=delmf(fls_input,input_output,var_index,mf_index)
//Delete member function to a fls and return it with this change.
//Calling Sequence
//fls=delmf( fls_input , input_output , var_index , mf_index )
//Parameters
//fls_input: fuzzy logic system (as input).
//fls: fuzzy logic system (as output).
//input_output: string. "input" for input variable, "output" for output variable.
//var_index: integer. Variable number.
//mf_index:integer. Member function number.
//Description
//<literal>delmf </literal> delete a member function from fuzzy logic system
//    <literal>fls_input</literal> and return it with this change as <literal>fls</literal>.
//    This command only delete the <literal>mf_index</literal> member function of the
//    <literal>var_index</literal> variable if the member function exist in the input
//    or output (depends of <literal>input_output</literal> parameter). If the fuzzy
//    logic system have rules, then fix the rules reflecting the change.
//    Examples
//    
//    fls=newfls("m");
//fls=addvar(fls,"input","speed",[0 100]);
//fls=addmf(fls,"input",1,"low","trimf",[-50 0 50]);
//fls=addmf(fls,"input",1,"med","trimf",[0 50 100]);
//fls=addmf(fls,"input",1,"high","trimf",[50 100 150]);
//fls=delmf(fls,"input",1,2); // Delete the member function named "med" in the input variable number 1 named "speed"
// See also
//    addvar
//    delvar
//    addmf
//    fls_structure
//    
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


//    
//    
// ----------------------------------------------------------------------
// Delete member function
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
	error('delmf needs four parameters.');
end

fls=fls_input;

if (input_output=='input') then
	nvar=length(fls.input);
	if (var_index>nvar) then
		error('Incorrect variable index.');
	end
	fls.input(var_index).mf(mf_index)=null();
	idx=nvar;	

elseif (input_output=='output') then
	nvar=length(fls.output);
	if (var_index>nvar) then
		error('Incorrect variable index.');
	end
	fls.output(var_index).mf(mf_index)=null();
	idx=length(fls.input)+nvar;	

else
	error('Wrong input/output');
end

// FIX MATRIX OF RULES IF EXIST SOME RULE AND THE SIZE WAS CORRECT

rule=fls.rule;
nrule=size(rule,1);
if nrule>0 then
	if (size(rule,2)==((length(fls.input)+length(fls.output)+2))) then
		idx1=find(abs(rule(:,idx))==idx);
		rule(idx1,idx)=0;
		idx1=find(rule(:,idx)>idx);
		rule(idx1,idx)=rule(idx1,idx)-1;
		idx1=find(rule(:,idx)<(-idx));
		rule(idx1,idx)=rule(idx1,idx)+1;
		fls.rule=rule;
	else
		warning("The fuzzy logic system have a bad table of rules!");
	end	
end

endfunction

