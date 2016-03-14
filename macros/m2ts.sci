function fls=m2ts(fls_input)
//Transform Mamdani to Takagi-Sugeno fls structure.
//Calling Sequence
//fls=m2ts(fls_input)
//Parameters
//fls_input:fuzzy logic system (as input).
// fls:fuzzy logic system (as output).
//Description
//         <literal>m2ts </literal> transform a Mamdani FLS structure
//     <literal>fls_input</literal> into a Takagi-Sugeno FLS structure
//     <literal>fls</literal>. The returned Takagi-Sugeno system has constant output
//     member functions.
//Examples
//fls=importfis(flt_path()+"demos/tip.fis");
// fls_ts=m2ts(fls);
//See also
//fls_structure
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Transform Mamdani to Takagi-Sugeno
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
	if (typeof(fls_input)~="fls") then
		error("The parameter must be a fls.");
	end
else
	error("This function need one parameter.");
end

if (fls_input.type~="m") then
	error("The fls structure must be a Mamdani");
end

fls=fls_input;
defuzzMethod=fls.defuzzMethod;
for i=1:length(fls.output),
	ran=fls.output(i).range;
	x=linspace(min(ran),max(ran),101)';
	for j=1:length(fls.output(i).mf)
		mf=mfeval(x,fls.output(i).mf(j).type,fls.output(i).mf(j).par);
		cc=defuzzm(x,mf,defuzzMethod);
		fls.output(i).mf(j).type="constant";
		fls.output(i).mf(j).par=cc;
	end
end
fls.type="ts";
fls.defuzzMethod="wtaver";
endfunction
