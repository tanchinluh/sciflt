function editfls_plot(filename,opt,p1,p2,p3,p4,p5,p6)
// ----------------------------------------------------------------------
// Util -> Plot 
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
dodel=%f;
fls=loadfls(filename);
if (opt==0) then
	// PLOT INPUT VARS
	scf();clf();
	k=length(fls.input);
	plotvar(fls,"input",1:k);
	dodel=%t;
elseif (opt==1) then
	// PLOT OUTPUT VARS
	scf();clf();
	k=length(fls.output);
	plotvar(fls,"output",1:k);
	dodel=%t;
elseif (opt==2) then
	if (p6==1) then
		scf();clf();
	else
		plotsurf(fls,p1,p2,p3,p4,p5);		
	end
	dodel=%t;
end

// DELETE ARCHIVE
if (dodel) then
	if (getos()=="Windows") then
		unix_s("del "+strsubst(filename,"/","\"));
	else
		unix_s("rm "+strsubst(filename,"\","/"));
	end
end
endfunction
