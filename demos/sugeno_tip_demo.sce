mode(-1);
// ----------------------------------------------------------------------
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

// Copyright (C) 2011 L. Markowsky <lmarkov@users.sourceforge.net>
//

// Author:        L. Markowsky
// Note:          This example is based on an assignment written by
//               Dr. Bruce Segee (University of Maine Dept. of ECE).


demo_path= get_absolute_file_path("sugeno_tip_demo.sce");
clc; mode(1);lines(0);
// Demonstrate the use of the Fuzzy Logic Toolkit to read and
// evaluate a Sugeno-type FIS with multiple outputs stored in a text
// file. Also demonstrate the use of hedges in the FIS rules and the
// Einstein product and sum as the T-norm/S-norm pair.

// Read the FIS structure from a file.
fis = importfis (demo_path+'/sugeno_tip_calculator.fis');

// Plot the input and output membership functions.
scf();plotvar (fis, 'input', [1 2]);

scf();plotvar (fis, 'output', [1 2 3]);


// Plot the cheap, average, and generous tips as a function of
// Food-Quality and Service.
scf();plotsurf (fis, [1 2], 1,[0 0]);
scf();plotsurf (fis, [1 2], 2,[0 0]);
scf();plotsurf (fis, [1 2], 3,[0 0]);

// Demonstrate showrule with hedges.
printrule (fis);

// Calculate the Tip for 6 sets of input values: 
printf ("\nFor the following values of (Food Quality, Service):\n\n");
food_service = [1 1; 5 5; 10 10; 4 6; 6 4; 7 4]
printf ("\nThe cheap, average, and generous tips are:\n\n");
tip = evalfls (food_service, fis, 1001)
