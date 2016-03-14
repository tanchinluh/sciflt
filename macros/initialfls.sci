function fls=initialfls(order,domI,domO,npart)
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
// CREATE A INITIAL TAKAGI SUGENO SYSTEM
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

deff('out=f(x)','out=0;');
deff('out=g(x)','out=zeros(1,size(domI,2))');
fls=fuzzapp(order,domI,domO,npart,f,g);

endfunction
