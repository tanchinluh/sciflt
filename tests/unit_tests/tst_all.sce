mode(-1);
// ----------------------------------------------------------------------
// GENERAL INTERNAL TEST CALLING ROUTINE
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

lines(0);
oldplath=pwd();
mypath=get_file_path('tst_all.sce');
totest1=[
	"dsigmf";
	"gauss2mf";
	"gaussmf";
	"gbellmf";
	"pimf";
	"psigmf";
	"sigmf";
	"smf";
	"trapmf";
	"trimf";
	"zmf";
	"complement";
	"snorm";
	"tnorm";
	"defuzzm";
];

for j=1:size(totest1,"*"),
	write(%io(2),"******************************************************");
	exec(mypath+"tst_"+totest1(j)+".sce",-1);
	write(%io(2),"******************************************************");
	write(%io(2),"");
end
