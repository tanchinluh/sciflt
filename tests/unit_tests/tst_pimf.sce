mode(-1);
// ----------------------------------------------------------------------
// PI-SHAPED MEMBER FUNCTION
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

write(%io(2),"TESTING PI-SHAPED MEMBER FUNCTION");
allok=%t;

x=linspace(-1,1,100)';
for a=linspace(-1,1,20),
	for b=linspace(-1,1,40),
		par=[a b b a];
		Y1=pimf(x,par);
		
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

		if (par(3)>=par(4)) then
			Y3=1*(x<=((par(3)+par(4))/2));
		else
			Y3=zeros(x);
			idx=find(x<=par(3));
			Y3(idx)=1;
			idx=find((par(3)<x)&(x<=(par(3)+par(4))/2));
			Y3(idx)=1-2*((x(idx)-par(3))/(par(4)-par(3))).^2;
			idx=find((((par(3)+par(4))/2)<x)&(x<=par(4)));
			Y3(idx)=2*((par(4)-x(idx))/(par(4)-par(3))).^2;		
		end	
			
		Y2= Y2 .* Y3;

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
