function fls=addrule(fls_input,rule_matrix)
//Add a new member function to a fls structure
// Calling Sequence
// fls=addrule(fls_input,rule_matrix)
// Parameters
// fls_input: fuzzy logic system (as input).
// fls:fuzzy logic system (as output).
// rule_matrix: each row of the rule matrix represents one rule and has the form [in1_mf ... inM_mf out1_mf ... outN_mf  connect weight]
// where:
// in<i>_mf == membership function index for input i
// out<j>_mf == membership function index for output j
// connect == antecedent connective (1 == and; 0 == or)
// weight == relative weight of the rule (0 <= weight <= 1)
// 
// Description
// To express:
// 
// "not" -- prepend a minus sign to the membership function index
// 
// "somewhat" -- append ".05" to the membership function index 
// 
// "very" -- append ".20" to the membership function index
// 
// "extremely" -- append ".30" to the membership function index
// 
// "very very" -- append ".40" to the membership function index
// 
// To omit an input or output, use 0 for the membership function index.
//  The consequent connective is always "and".
//Examples
//
// //   If (input_1 is mf_2) or (input_3 is not mf_1) or (input_4 is very mf_1),
// //	then (output_1 is mf_2) and (output_2 is mf_1^0.3).
// //	fls=addrule(fls,[2 0 -1 4.2 2 1.03 0 1]);
//
// See also
// addvar
// delvar
// delmf
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

// ----------------------------------------------------------------------
// Add rule matrix
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

if (argn(2)~=2) then
	error('addrule needs two parameters.');
end
fls=fls_input;

if (typeof(fls)~="fls") then
		error("The first parameter must be a fls.");
end

if (or(rule_matrix(:,$-1)>1)) then
  rule_matrix(find(rule_matrix(:,$-1)>1),$-1)=0;


end;

fls.rule=rule_matrix;
[all_ok,mes]=checkrule(fls);

if (all_ok>0) then
  error(mes);
end;

endfunction

