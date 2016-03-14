mode(-1)
// ----------------------------------------------------------------------
// Member Function Gallery
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

// Create an internal first-part list
mf1=list();
mf1($+1)=list('dsigmf',[5 -4 5 2]);
mf1($+1)=list('gaussmf',[0.5 2]);
mf1($+1)=list('gbellmf',[2 4 6]);
mf1($+1)=list('pimf',[-8 -6 -4 -2]);
mf1($+1)=list('psigmf',[2 3 -5 8]);

// Create an internal second-part list
mf2=list();
mf2($+1)=list('sigmf',[-1 0]);
mf2($+1)=list('smf',[-8 -6]);
mf2($+1)=list('trapmf',[-3 -1 1 3]);
mf2($+1)=list('trimf',[1 3 5]);
mf2($+1)=list('zmf',[3 9]);

// Display
scf();clf();
reduce_fac=0.9;
X=linspace(-10, 10, 200)';
mfx='['+strcat(string(X),';')+']';

// First part
Y=[];
LEG=[];
for j=1:length(mf1);
	Y=[Y mfeval(X,mf1(j)(1),mf1(j)(2))];
	LEG=[LEG,mf1(j)(1)];
end
subplot(2,1,1);
plot(X,Y);
legend(LEG,-1,%f);
a=gca();
a.axes_bounds(3)=reduce_fac;
a.data_bounds=[-10,-0.1;10,1.1];
a.tight_limits="on";
xtitle('Member Function Evaluation','x','mu(x)');

// Second part
Y=[];
LEG=[];
for j=1:length(mf2);
	Y=[Y mfeval(X,mf2(j)(1),mf2(j)(2))];
	LEG=[LEG,mf2(j)(1)];
end
subplot(2,1,2);
plot(X,Y);
legend(LEG,-1,%f);
a=gca();
a.axes_bounds(3)=reduce_fac;
a.data_bounds=[-10,-0.1;10,1.1];
a.tight_limits="on";
xtitle('Member Function Evaluation','x','mu(x)');


