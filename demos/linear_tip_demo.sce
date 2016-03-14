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


demo_path= get_absolute_file_path("linear_tip_demo.sce");
clc; mode(1);lines(0);
// Demonstrate the use of linear output membership functions to simulate
// constant membership functions.
//
// Read the FIS structure from a file.
fis = importfis (demo_path+'/linear_tip_calculator.fis');

// Plot the input membership functions.
scf();plotvar (fis, 'input', [1 2]);


// Plot the Tip as a function of Food-Quality and Service.
scf();plotsurf (fis,[1 2], 1,[0 0]);

// Calculate the Tip for 6 sets of input values: 
printf ("\nFor the following values of (Food Quality, Service):\n\n");
food_service = [1 1; 5 5; 10 10; 4 6; 6 4; 7 4]
printf ("\nThe Tip is:\n\n");
tip = evalfls (food_service, fis, 1001)
