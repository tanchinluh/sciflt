mode(-1);
// ----------------------------------------------------------------------
// TEST T-NORM
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

write(%io(2),"TESTING T-NORM");
allok=%t;

// MIN CLASS
msg="ALL OK"
x=rand(100,2);
Y1=tnorm(x,"min");
Y2=min(x,"c");
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end
write(%io(2)," MIN CLASS               -> "+msg);

// ALGEBRAIC PRODUCT CLASS
msg="ALL OK"
x=rand(100,2);
Y1=tnorm(x,"aprod");
Y2=prod(x,"c");
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end
write(%io(2)," ALGEBRAIC PRODUCT CLASS -> "+msg);

// EINSTEIN PRODUCT CLASS
msg="ALL OK"
x=rand(100,2);
Y1=tnorm(x,"eprod");
Y2=x(:,1);
for j=2:size(x,2),
	tmp=Y2 .* x(:,j);
	Y2= tmp ./ ( 2 - ( Y2 + x(:,j) - Y2 .* x(:,j) ) );
end
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end
write(%io(2)," EINSTEIN PRODUCT CLASS  -> "+msg);

// DRASTIC PRODUCT CLASS
msg="ALL OK"
x=[rand(100,3); zeros(100,1) rand(100,1) zeros(100,1)];
Y1=tnorm(x,"dprod");
Y2=x(:,1);
for j=2:size(x,2),
	T=Y2;
	idx=find(Y2==1);
	T(idx)=x(idx,j);
	idx=find( (Y2~=1) & (x(:,j)~=1) );
	T(idx)=0;
	Y2=T;
end
ok=find(abs(Y1-Y2)>%eps);
if length(ok)>0 then
	write(%io(2)," |E_max|="+string(max(abs(Y1-Y2))));
	msg="TEST FAILED!";
	allok=%f;
end
write(%io(2)," DRASTIC PRODUCT CLASS   -> "+msg);

// YAGER CLASS
msg="ALL OK"
x=rand(100,2);
for p=[1 5 10 %inf],
	Y1=tnorm(x,"yager",p);
	Y2=x(:,1);
	for j=2:size(x,2),
		tmp=(1-Y2).^p + (1-x(:,j)).^p;
		tmp=tmp.^(1/p);
		tmp2=ones(Y2);
		idx=find(tmp<1);
		tmp2(idx)=tmp(idx);
		Y2=1-tmp2;
		
	end	
	ok=find(abs(Y1-Y2)>%eps);
	if length(ok)>0 then
		write(%io(2)," |E_max|="+string(max(abs(Y1-Y2)))+" WITH p="+string(p));
		msg="TEST FAILED!";
		allok=%f;
	end
end

write(%io(2)," YAGER CLASS             -> "+msg);

// DUBOIS SUM CLASS
msg="ALL OK"
x=rand(100,2);
for p=linspace(0,1,10),
	Y1=tnorm(x,"dubois",p);
	Y2=x(:,1);
	for j=2:size(x,2),
		tmp=Y2 .* x(:,j);
		Y2=tmp ./ max([Y2 x(:,j) ones(Y2)*p],"c");
	end	
	ok=find(abs(Y1-Y2)>%eps);
	if length(ok)>0 then
		write(%io(2)," |E_max|="+string(max(abs(Y1-Y2)))+" WITH p="+string(p));
		msg="TEST FAILED!";
		allok=%f;
	end
end

write(%io(2)," DUBOIS CLASS            -> "+msg);

if (allok) then
	write(%io(2)," --------------> ALL OK");
else
	write(%io(2)," --------------> TEST FAILED!");
end
