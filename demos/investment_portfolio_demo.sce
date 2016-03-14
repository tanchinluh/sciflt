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


demo_path= get_absolute_file_path("investment_portfolio_demo.sce");
clc; mode(1);lines(0);

// Demonstrate the use of the Scilab Fuzzy Logic Toolkit to read and evaluate
// a Mamdani-type FIS stored in a file. Also demonstrate the use of hedges and
// weights in the FIS rules, the use of the Einstein product and sum as the
// T-norm/S-norm pair, and the non-standard use of the Einstein sum as the
// aggregation method.

//Read the FIS structure from a file.

fis=importfis (demo_path+'/investment_portfolio');


//Plot the input and output membership functions.
scf();plotvar (fis, 'input', [1 2]);
scf();plotvar (fis, 'output', [1]);

//Plot the Percentage-In-Stocks a function of Age and Risk-Tolerance.
scf();plotsurf (fis, [1 2], 1,[0 0]);

// //Calculate the Percentage-In-Stocks using (Age, Risk-Tolerance) = (40, 7).
[output, rule_input,fuzzy_output] = evalfls ([40 7], fis, 1001);
// 
// // Plot the output (Percentage-In-Stocks) of the individual fuzzy rules
// // on one set of axes.
x_axis = linspace (fis.output(1).range(1), fis.output(1).range(2), 1001);
 colors = ['r' 'b' 'm' 'g'];
//  figure ( 'figure_name',  'Output of Fuzzy Rules 1-4 for (Age, Risk Tolerance) = (40, 7)');
// 
//  for i = 1 : 4
//      y_label = [colors(i)];// +";Rule "+ string(i)+ ";"];
//      plot (x_axis, rule_output(:,i), y_label, 'LineWidth', 2);
//      
// end
// 
// //ylim ([-0.1, 1.1]);
// xlabel ('Percentage in Stocks', 'FontWeight', 'bold');
// grid;
// 
// 
// Plot the first aggregated fuzzy output and the crisp output (Percentage-In-Stocks)
// on one set of axes.
figure( 'figure_name',  'Aggregation and Defuzzification for (Age, Risk Tolerace) = (40, 7)');
plot (x_axis, fuzzy_output(:, 1), "b", 'LineWidth', 2);


plot ([output,output], [0 1], "r", 'LineWidth', 2);
//ylim ([-0.1, 1.1]);
xlabel ('Percentage in Stocks', 'FontWeight', 'bold');
xgrid();
legend(";Aggregated Fuzzy Output;","Crisp Output = " +string(output(1))+ "%;");


// Show the rules in English.
printf ("\nInvestment Portfolio Calculator Rules:\n\n");
printrule (fis);
