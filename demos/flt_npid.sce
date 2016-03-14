mode(-1);
// ----------------------------------------------------------------------
// HAND CODED FLS STRUCTURE
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

a1=[	1 1 1 1 1 1 1;
	0 1 1 1 1 1 0;
	0 0 1 1 1 0 0;
	0 0 0 1 0 0 0;
	0 0 1 1 1 0 0;
	0 1 1 1 1 1 0;
	1 1 1 1 1 1 1;];
a1=a1+1;

a2=[	0 0 0 0 0 0 0;
	1 1 0 0 0 1 1;
	1 1 1 0 1 1 1;
	1 1 1 1 1 1 1;
	1 1 1 0 1 1 1;
	1 1 0 0 0 1 1;
	0 0 0 0 0 0 0;];
a2=a2+1;
	
a3=[	2 2 2 2 2 2 2;
	3 3 2 2 2 3 3;
	4 3 3 2 3 3 4;
	5 4 3 3 3 4 5;
	4 3 3 2 3 3 4;
	3 3 2 2 2 3 3;
	2 2 2 2 2 2 2;];
a3=a3-1;

fls=newfls('ts');
fls.name="Normalized PID";
fls.comment="Taked from A Course In Fuzzy Systems and Control, Li-Xon Wang"
fls=addvar(fls,"input","Nerror",[-1 1]);
fls=addmf(fls,"input",1,"NB","trimf",[-4/3 -1 -2/3]);
fls=addmf(fls,"input",1,"NM","trimf",[-1 -2/3 -1/3]);
fls=addmf(fls,"input",1,"NS","trimf",[-2/3 -1/3 0]);
fls=addmf(fls,"input",1,"ZO","trimf",[-1/3 0 1/3]);
fls=addmf(fls,"input",1,"PS","trimf",[0 1/3 2/3]);
fls=addmf(fls,"input",1,"PM","trimf",[1/3 2/3 1]);
fls=addmf(fls,"input",1,"PB","trimf",[2/3 1 4/3]);

fls=addvar(fls,"input","Nderror",[-1 1]);
fls=addmf(fls,"input",2,"NB","trimf",[-4/3 -1 -2/3]);
fls=addmf(fls,"input",2,"NM","trimf",[-1 -2/3 -1/3]);
fls=addmf(fls,"input",2,"NS","trimf",[-2/3 -1/3 0]);
fls=addmf(fls,"input",2,"ZO","trimf",[-1/3 0 1/3]);
fls=addmf(fls,"input",2,"PS","trimf",[0 1/3 2/3]);
fls=addmf(fls,"input",2,"PM","trimf",[1/3 2/3 1]);
fls=addmf(fls,"input",2,"PB","trimf",[2/3 1 4/3]);

fls=addvar(fls,"output","NKp",[0 1]);
fls=addmf(fls,"output",1,"S","constant",0);
fls=addmf(fls,"output",1,"B","constant",1);

fls=addvar(fls,"output","NKd",[0 1]);
fls=addmf(fls,"output",2,"S","constant",0);
fls=addmf(fls,"output",2,"B","constant",1);


fls=addvar(fls,"output","alpha",[2 5]);
fls=addmf(fls,"output",3,"S","constant",2);
fls=addmf(fls,"output",3,"MS","constant",3);
fls=addmf(fls,"output",3,"M","constant",4);
fls=addmf(fls,"output",3,"B","constant",5);

p1=[1 2 3 4 5 6 7]';
rule=genspace(p1,p1);
A=a1';
rule=[rule A(:)];
A=a2';
rule=[rule A(:)];
A=a3';
rule=[rule A(:)];
rule=[rule ones(size(rule,1),2)];
fls.rule=rule;

scf();clf();
h=gcf();
h.visible="off";
subplot(2,2,1);
plotsurf(fls,[1 2],1,[0 0]);
subplot(2,2,2);
plotsurf(fls,[1 2],2,[0 0]);
subplot(2,2,3);
plotsurf(fls,[1 2],3,[0 0]);
subplot(2,2,4);
xstring(0,1,"Normalized PID Output Surface");
xstring(0,0.9,"The Fuzzy Logic system have:");
xstring(0,0.8,"2 inputs (Normalized error and Normalized diff. error)");
xstring(0,0.7,"3 outputs (Normalized Kp, Normalized Kd and alpha)");
h.visible="on";
