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


demo_path= get_absolute_file_path("heart_disease_demo2.sce");
clc; mode(1);lines(0);
// Demonstrate the use of the Fuzzy Logic Toolkit to read and evaluate a
// Sugeno-type FIS stored in a file.


// Read the FIS structure from a file.
// (Alternatively, to select heart_disease_risk.fis using the dialog,
// replace the following line with
//    fis = readfis ();
fis = importfis(demo_path+'/heart_disease_risk.fis');

// Plot the input and output membership functions.
scf();plotvar (fis, 'input', [1 2]);
scf();plotvar (fis, 'output', 1);

// Plot the Heart Disease Risk as a function of LDL-Level and HDL-Level.
scf();plotsurf (fis,[1 2],1,[0 0]);

// Calculate the Heart Disease Risk for 4 sets of LDL-HDL values: 
printf ("\nFor the following four sets of LDL-HDL values:\n\n");
ldl_hdl = [129 59; 130 60; 90 65; 205 40]
printf ("\nThe Heart Disease Risk is:\n\n");
heart_disease_risk = evalfls (ldl_hdl, fis, 1001)
