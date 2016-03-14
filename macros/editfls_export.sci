function editfls_export()
// ----------------------------------------------------------------------
// Export the currents fls structures 
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
// CHANGES:
// 2005-05-28 Change TCL/TK calling.
// ----------------------------------------------------------------------

ok=TCL_GetVar("sciFLTEditorTable(do_import_from_scilab)");
if (ok=="1") then
	txt=sciFLTgetFLS();
	if (txt~=[]) then
		sttoex="";
		TCL_SetVar("sciFLTEditorTable(from_scilab)","");
		for j=1:size(txt,"*"),
			q=grep(txt(j),["$","%"]);
			if (q==[]) then	
				sttoex=sttoex+" "+txt(j);
			end
		end

		if (sttoex~="") then
			TCL_SetVar("sciFLTEditorTable(from_scilab)",sttoex);
			TCL_EvalStr("sciFLTEditorImportFromScilab");		
		end
	end
end

endfunction

