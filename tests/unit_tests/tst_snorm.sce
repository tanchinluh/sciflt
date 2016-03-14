mode(-1);
// ----------------------------------------------------------------------
// TEST S-NORM
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
// NOTES:
// (1) In some case dubois and yager S-NORM CLASS don't pass the test
// ----------------------------------------------------------------------

write(%io(2),"TESTING S-NORM");
allok=%t;

// MAX CLASS
msg="ALL OK"
x=rand(100,100);
Y1=snorm(x,"max");
Y2=max(x,"c");
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then msg="TEST FAILED!"; allok=%f; end;
write(%io(2)," MAX CLASS           -> "+msg);

// ALGEBRAIC SUM CLASS
msg="ALL OK"
x=rand(100,100);
Y1=snorm(x,"asum");
Y2=x(:,1);
for j=2:size(x,2),
	Y2=Y2+x(:,j)-Y2.*x(:,j);
end
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then msg="TEST FAILED!"; allok=%f; end;
write(%io(2)," ALGEBRAIC SUM CLASS -> "+msg);

// EINSTEIN SUM CLASS
msg="ALL OK"
x=rand(100,100);
Y1=snorm(x,"esum");
Y2=x(:,1);
for j=2:size(x,2),
	Y2=(Y2+x(:,j))./(1+Y2.*x(:,j));
end
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then msg="TEST FAILED!"; allok=%f; end;
write(%io(2)," EINSTEIN SUM CLASS  -> "+msg);

// DRASTIC SUM CLASS
msg="ALL OK"
x=[rand(100,100); zeros(100,50) rand(100,25) zeros(100,25)];
Y1=snorm(x,"dsum");
Y2=x(:,1);
for j=2:size(x,2),
	T=Y2;
	idx=find(Y2==0);
	T(idx)=x(idx,j);
	idx=find( (Y2~=0) & (x(:,j)~=0) );
	T(idx)=1;
	Y2=T;
end
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then msg="TEST FAILED!"; allok=%f; end;
write(%io(2)," DRASTIC SUM CLASS   -> "+msg);

// YAGER SUM CLASS
msg="ALL OK"
x=rand(50,3);
for p=[1 5 10 20],
	Y1=snorm(x,"yager",p);
	Y2=x(:,1);
	for j=2:size(x,2),
		tmp=Y2.^p + x(:,j).^p;
		tmp=tmp.^(1/p);
		Y2=min([ones(Y2) tmp],"c");
	end	
	ok=find(abs(Y1-Y2)>%eps);
	if length(ok)>0 then
		write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
		msg="TEST FAILED!";
		allok=%f;
	end;	
end

write(%io(2)," YAGER CLASS         -> "+msg);

// DUBOIS SUM CLASS
msg="ALL OK"
x=rand(50,3);
for p=linspace(0.1,0.9,5),
	Y1=snorm(x,"dubois",p);
	Y2=x(:,1);
	for j=2:size(x,2),
		tmp=Y2+x(:,j)-Y2.*x(:,j)-min([Y2 x(:,j) ones(Y2)*(1-p)],"c");
		Y2=tmp ./ max([1-Y2 1-x(:,j) ones(Y2)*p],"c");
	end	
	ok=find(abs(Y1-Y2)>%eps);
	if length(ok)>0 then
		write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
		msg="TEST FAILED!";
		allok=%f;
	end;
end

write(%io(2)," DUBOIS CLASS        -> "+msg);

if (allok) then
	write(%io(2)," --------------> ALL OK");
else
	write(%io(2)," --------------> TEST FAILED!");
end
