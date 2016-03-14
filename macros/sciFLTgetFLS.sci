function [%_export]=sciFLTgetFLS()
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
// FIND ALL FLS SYSTEMS IN WORKSPACE
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

[%_nams]=who("get");
%_export=[];
for k=1:size(%_nams,"*")
	execstr('%_typ=typeof('+%_nams(k)+')');
	if (%_typ=="fls") then	
		%_export=[%_export;%_nams(k)];
	end
end

endfunction
