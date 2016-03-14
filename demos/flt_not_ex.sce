mode(-1);
// ----------------------------------------------------------------------
// NOT operation example (Complement)
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

x=[0:0.1:10]';
y1=gaussmf(x,[5 0.5]);
yy1=complement(y1,'one');
yy2=complement(y1,'sugeno',3);
yy3=complement(y1,'yager',5);
scf();clf();
subplot(2,1,1);
plot2d(x,y1,leg='mf',rect=[0 -0.1 10 1.1]);
xtitle('Member Function Evaluation','x','mu(x)');
subplot(2,1,2);
plot2d(x,[yy1 yy2 yy3],leg='one@sugeno, lambda=3@yager, omega=5',rect=[0 -0.1 10 1.1]);
xtitle('NOT OPERATION','x','not(mf)');
