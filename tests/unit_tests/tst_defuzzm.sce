mode(-1);
// ----------------------------------------------------------------------
// TEST DEFFUZYFICATION
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

write(%io(2),"TESTING DEFFUZYFICATION");
allok=%t;

// CENTROIDE
msg="ALL OK";
x=linspace(0,10,1000)';
y=rand(1000,1);

y_sum=sum(y);
Y1=sum(y.*x)/y_sum;
Y2=defuzzm(x,y,"centroide");
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end;
write(%io(2)," CENTROIDE    -> "+msg);

// BISECTOR
msg="ALL OK";
x=linspace(0,10,1000)';
y=rand(1000,1);
y_sum=sum(y);
tmp=0;
for k=1:size(x,"*"),
	tmp=tmp+y(k);
	if tmp>= y_sum/2 then
		break;
	end
end
Y1=x(k);
Y2=defuzzm(x,y,"bisector");
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end;
write(%io(2)," BISECTOR     -> "+msg);

// MEAN OF MAXIMUM
msg="ALL OK";
x=linspace(0,10,1000)';
y0=rand(200,1);
y=[];
for j=1:5,
	y=[y;y0];
end
Y1=mean(x(find(y==max(y))));
Y2=defuzzm(x,y,"mom");
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end;
write(%io(2)," MOM          -> "+msg);

// LARGEST OF MAXIMUM
msg="ALL OK";
x=linspace(0,10,1000)';
y0=rand(200,1);
y=[];
for j=1:5,
	y=[y;y0];
end
tmp=find(y==max(y));
Y1=max(x(tmp));
Y2=defuzzm(x,y,"lom");
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end;
write(%io(2)," LOM          -> "+msg);

// SHORTEST OF MAXIMUM
msg="ALL OK";
x=linspace(0,10,1000)';
y0=rand(200,1);
y=[];
for j=1:5,
	y=[y;y0];
end
tmp=find(y==max(y));
Y1=min(x(tmp));
Y2=defuzzm(x,y,"som");
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end;
write(%io(2)," SOM          -> "+msg);

if (allok) then
	write(%io(2)," --------------> ALL OK");
else
	write(%io(2)," --------------> TEST FAILED!");
end
