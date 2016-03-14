mode(-1);
// ----------------------------------------------------------------------
// TEST EXTENDED GAUSS MEMBER FUNCTION
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

write(%io(2),"TESTING EXTENDED GAUSS MEMBER FUNCTION");
allok=%t;

x=linspace(0,1,100)';
for a=[0 0.2 0.4 0.6 0.8 1],
	for b=[-100 -50 -10 -1 1 10 50 100],
		for c=[1 0.8 0.6 0.4 0.2 0],
			for d=[100 50 10 1 -1 -100 -20 -100],
				Y1=gauss2mf(x,[b,a,d,c]);
				idxA=1*(x<=a);
				idxB=1*(x>=c);
				YA=exp(-((x-a).^2)/((2*b^2))).*idxA+(1-idxA);
				YB=exp(-((x-c).^2)/((2*d^2))).*idxB+(1-idxB);	
				Y2=YA .* YB;
				ok=find(abs(Y1-Y2)>%eps);
				if length(ok)>0 then
					//write(%io(2),"|E_max|="+string(max(abs(Y1-Y2)))+" FAILED WITH a="+string(a)+" b="+string(b)+" c="+string(c)+" d="+string(d));
					allok=%f;				
				end
			end
		end

	end
end

if (allok) then
	write(%io(2)," --------------> ALL OK");
else
	write(%io(2)," --------------> TEST FAILED");
end
