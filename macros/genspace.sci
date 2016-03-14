function out=genspace(x1,x2)
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
// UTIL FUNCTION -> GENERATE SPACE
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
// 2004-11-03 Vectorization.
// ----------------------------------------------------------------------

m1=x1.*.ones(x2);
m2=x2.*.ones(x1)';
out=[m1 m2(:)];

endfunction
