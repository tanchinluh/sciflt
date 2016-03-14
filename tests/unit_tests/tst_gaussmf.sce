mode(-1);
// ----------------------------------------------------------------------
// TEST GAUSS MEMBER FUNCTION
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

write(%io(2),"TESTING GAUSSIAN MEMBER FUNCTION");
allok=%t;

x=linspace(0,1,100)';
for a=[0 0.2 0.4 0.6 0.8 1],
	for b=[-100 -50 -10 -1 1 10 50 100],
		Y1=gaussmf(x,[b,a]),
		Y2=exp(-((x-a).^2)/((2*b^2)));
		ok=find(abs(Y1-Y2)>%eps);
		if length(ok)>0 then
			//write(%io(2)," FAILED WITH a="+string(a)+" b="+string(b));
			allok=%f;
		end;
	end
end

if (allok) then
	write(%io(2)," --------------> ALL OK");
else
	write(%io(2)," --------------> TEST FAILED");
end
