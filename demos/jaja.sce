mode(-1);
// ----------------------------------------------------------------------
// OPTFLS01 Butterfly example
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

t=linspace(0,6*%pi,150)';
r=exp(cos(t))-2*cos(4*t)+sin(t/12).^5;
x=r.*cos(t-%pi/2);
y=r.*sin(t-%pi/2);

X=[x(2:$-2) x(3:$-1) x(4:$)];
Y=[y(2:$-2) y(3:$-1) y(4:$)];
[theta,psi,ck1,fls1]=optfls01(X,x(1:$-3),5,sqrt(%eps),5,%t);
[theta,psi,ck2,fls2]=optfls01(Y,y(1:$-3),5,sqrt(%eps),5,%t);
xf=evalfls(X,fls1);
yf=evalfls(Y,fls2);

scf();clf();
subplot(4,3,1);
plot(x,y);
xtitle("Real butterfly","x","y");

subplot(4,3,2);
plot(xf,yf);
xtitle("Fuzzy butterfly","x","y");

subplot(4,3,3);
plot(ck1,'o-');
xtitle("Objetive function approximation x axis","k","Ck");

subplot(4,3,4);
plot(x(1:length(xf))-xf,'r');
xtitle("x axis error","k","x(k)");

subplot(4,3,5);
plot(y(1:length(yf))-yf,'r');
xtitle("y axis error","k","y(k)");

subplot(4,3,6);
plot(ck2,'o-');
xtitle("Objetive function approximation y axis","k","Ck");

for q=1:3;
	subplot(4,3,6+q);
	plotvar(fls1,'input',q);
	subplot(4,3,9+q);
	plotvar(fls2,'input',q);
end


