mode(-1);
// ----------------------------------------------------------------------
// TEST DIFFERENCE OF TWO SIGMOIDAL MEMBER FUNCTION
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

write(%io(2),"TESTING DIFFERENCE OF TWO SIGMOIDAL MEMBER FUNCTION");
allok=%t;

x=linspace(0,1,100)';
for a=linspace(-1,1,10),
	for b=linspace(-1,1,10),
		Y1=dsigmf(x,[a b b a]);
		tmp1= 1 ./ ( 1 + exp( -a*(x-b) ) );
		tmp2= 1 ./ ( 1 + exp( -b*(x-a) ) );
		Y2=abs(tmp1 - tmp2);
		if isdef("plotpr") then
			if (plotpr) then
				scf();
				plot2d(abs(Y1-Y2));
				halt();
			end
		end
		ok=find(abs(Y1-Y2)>%eps);
		if length(ok)>0 then						
			write(%io(2),"|E_max|="+string(max(abs(Y1-Y2)))+" FAILED WITH a="+string(a)+" b="+string(b));
			allok=%f;
		end;		
	end
end

if (allok) then
	write(%io(2)," --------------> ALL OK");
else
	write(%io(2)," --------------> TEST FAILED");
end
