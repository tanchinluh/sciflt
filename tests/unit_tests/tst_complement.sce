mode(-1);
// ----------------------------------------------------------------------
// TEST FUZZY COMPLEMENT
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

write(%io(2),"TESTING COMPLEMENT");
allok=%t;

//  ONE CLASS
msg="ALL OK"
x=linspace(0,1,1000)';
Y1=complement(x,"one");
Y2=1-x;
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end;
write(%io(2)," ONE CLASS    -> "+msg);

// YAGER CLASS
msg="ALL OK"
x=linspace(0,1,1000)';
for h=[1 5 10 100 1000 100000],
	Y1=complement(x,"yager",h);
	Y2=(1-x.^h)^(1/h);
	ok=find(abs(Y1-Y2)>%eps*5);
	if length(ok)>0 then
		write(%io(2)," |E_max|="+string(max(abs(Y1-Y2)))+" WITH h="+string(h));
		msg="TEST FAILED!";
		allok=%f;
	end;
end
write(%io(2)," YAGER CLASS  -> "+msg);

// SUGENO CLASS
msg="ALL OK"
x=linspace(0,1,1000)';
for h=[1 5 10 100 1000 100000],
	Y1=complement(x,"sugeno",h);
	Y2=(1-x)./(1+h*x);
	ok=find(abs(Y1-Y2)>%eps);
	if length(ok)>0 then
		write(%io(2)," |E_max|="+string(max(abs(Y1-Y2)))+" WITH h="+string(h));
		msg="TEST FAILED!";
		allok=%f;
	end;
end
write(%io(2)," SUGENO CLASS -> "+msg);

if (allok) then
	write(%io(2)," --------------> ALL OK");
else
	write(%io(2)," --------------> TEST FAILED!");
end



