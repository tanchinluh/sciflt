mode(-1);
// ----------------------------------------------------------------------
// TEST GENERALIZED BELL MEMBER FUNCTION
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

write(%io(2),"TESTING GENERALIZED BELL MEMBER FUNCTION");
allok=%t;

x=linspace(%eps,1,100)';
for c=[-100 -50 -10 -1 0],
	for b=[1 10 50 100],
		for a=[-1 0 -1 0 1 1.5 2 2.5] ;
			Y1=gbellmf(x,[a,b,c]);
			if (c==0) then
				Y2=0.5*ones(x);
			elseif (c<0) then
				Y2=zeros(x);
			else
				Y2=1 ./ ( 1 + (abs((x-c)/a)).^(2*b) );
			end			
			ok=find(abs(Y1-Y2)>%eps);
			if length(ok)>0 then
				//write(%io(2)," FAILED WITH a="+string(a)+" b="+string(b)+ " c="+string(c));
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
