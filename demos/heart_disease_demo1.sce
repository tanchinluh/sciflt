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
// a = newfis ('Heart-Disease-Risk', 'sugeno', ...
//             'algebraic_product', 'algebraic_sum', ...
//             'min', 'max', 'wtaver');

demo_path= get_absolute_file_path("heart_disease_demo1.sce");
clc; mode(1);lines(0);
//Demonstrate the use of newfis, addvar, addmf, addrule, and evalfis
// to build and evaluate an FIS. Also demonstrate the use of the algebraic
// product and sum as the T-norm/S-norm pair, and demonstrate the use of
// hedges in the FIS rules.
// Create new FIS.

a = newfls ('ts','Heart-Disease-Risk', ...
            'asum', 'aprod', 'one','wtaver');

// Add two inputs and their membership functions.
a = addvar (a, 'input', 'LDL-Level', [0 300]);
a = addmf (a, 'input', 1, 'Low', 'trapmf', [-1 0 90 130]);
a = addmf (a, 'input', 1, 'Moderate', 'trapmf', [90 130 160 200]);
a = addmf (a, 'input', 1, 'High', 'trapmf', [160 200 300 301]);

a = addvar (a, 'input', 'HDL-Level', [0 100]);
a = addmf (a, 'input', 2, 'Low', 'trapmf', [-1 0 35 45]);
a = addmf (a, 'input', 2, 'Moderate', 'trapmf', [35 45 55 65]);
a = addmf (a, 'input', 2, 'High', 'trapmf', [55 65 100 101]);

// Add one output and its membership functions.
a = addvar (a, 'output', 'Heart-Disease-Risk', [-2 12]);
a = addmf (a, 'output', 1, 'Negligible', 'constant', 0);
a = addmf (a, 'output', 1, 'Low', 'constant', 2.5);
a = addmf (a, 'output', 1, 'Medium', 'constant', 5);
a = addmf (a, 'output', 1, 'High', 'constant', 7.5);
a = addmf (a, 'output', 1, 'Extreme', 'constant', 10);

// Plot the input and output membership functions.
scf();plotvar (a, 'input', [1 2]);
scf();plotvar (a, 'output', 1);

// Add 15 rules and display them in verbose format.
a = addrule (a, [1 1 3 1 1; 1 2 2 1 1; 1 3 1 1 1; ...
                 2 1 4 1 1; 2 2 3 1 1; 2 3 2 1 1; ...
                 3 1 5 1 1; 3 2 4 1 1; 3 3 3 1 1; ...
                 1.3 3.3 2 0 1; ...
                 3.05 1.05 4 0 1; ...
                 -3.2 -1.2 3 1 1]);
printf ("\nOutput of showrule(a):\n\n");
printrule (a);

// Plot the output as a function of the two inputs.
scf();plotsurf (a,[1 2],1,[0 0]);
