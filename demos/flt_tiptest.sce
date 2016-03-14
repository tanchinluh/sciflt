mode(-1);
// ----------------------------------------------------------------------
// Example
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
// 2004-11-04 Spell check.
// ----------------------------------------------------------------------

fls=importfis(flt_path()+"demos/tip.fis");
scf();clf();
h=gcf();
h.visible="off";
i=1;
for dff=["centroide" "bisector" "mom" "som" "lom"],
	subplot(3,2,i);
	fls.defuzzMethod=dff;
	plotsurf(fls,[2 1],1,[0 0],25,2);
	xtitle("defuzzMethod="+dff);
	i=i+1;
end
subplot(3,2,i);
xstring(0,0.7,"Defuzzification Output Surface Gallery");
t=get("hdl");
t.foreground=9;t.font_size=3;
xstring(0,0.6,"The Fuzzy Logic system have:");
xstring(0,0.5,"2 inputs (service and food)");
xstring(0,0.4,"1 output (tip)");
h.visible="on";


