mode(-1);
// ----------------------------------------------------------------------
// TEST TRAPEZOIDAL MEMBER FUNCTION
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

write(%io(2),"TESTING TRAPEZOIDAL MEMBER FUNCTION");
allok=%t;

x=linspace(0,1,100)';
for a=[0 0.2 0.4 0.6 0.8 1],
	for b=[0.1 0.2 0.3 0.4 .5 0.6 0.7 0.8 0.9 1],
		for c=[0 0.1 0.2 0.3 0.4],
			par=[a-b-c a-c a+c a+b+c];
			Y1=trapmf(x,par);
			Y2=Y1;
			idx=find( (x>par(1)) & (x<par(2)) );
			Y2(idx)=(x(idx)-par(1))/(par(2)-par(1));
			idx=find( (x>=par(2)) & (x<=par(3)) );
			Y2(idx)=1;
			idx=find( (x>par(3)) & (x<par(4)) );
			Y2(idx)=(par(4)-x(idx))/(par(4)-par(3));
			ok=find(abs(Y1-Y2)>%eps);
			if length(ok)>0 then			
				//write(%io(2)," FAILED WITH a="+string(a)+" b="+string(b));
				allok=%f;
			end;
		end
	end
end

if (allok) then
	write(%io(2)," --------------> ALL OK");
else
	write(%io(2)," --------------> TEST FAILED");
end
