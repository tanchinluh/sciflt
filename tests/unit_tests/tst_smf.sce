mode(-1);
// ----------------------------------------------------------------------
// S-SHAPED MEMBER FUNCTION
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

write(%io(2),"TESTING S-SHAPED MEMBER FUNCTION");
allok=%t;

x=linspace(-1,1,100)';
for a=linspace(-1,1,20),
	for b=linspace(-1,1,40),
		par=[a b];
		Y1=smf(x,par);
		if (par(1)>=par(2)) then
			Y2=1*(x>=((par(1)+par(2))/2));
		else
			Y2=ones(x);
			idx=find(x<=par(1));
			Y2(idx)=0;
			idx=find((par(1)<x)&(x<=(par(1)+par(2))/2));
			tmp=((x(idx)-par(1))/(par(2)-par(1)))
			Y2(idx)=2*tmp.*tmp;
			idx=find((((par(1)+par(2))/2)<x)&(x<=par(2)));
			tmp=((par(2)-x(idx))/(par(2)-par(1)))
			Y2(idx)=1-2*tmp.*tmp;		
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
