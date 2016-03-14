function plotvar(fls,inpout,var_number,y_lower_limit,y_upper_limit,npt)
//Plot a fls input(s) or output(s) variable(s)
//Calling Sequence
//plotvar( fls, inpout, var_number [,y_lower_limit,y_upper_limit [,npt]] )
//Parameters
//fls:fls structure.
// inpouts:string. "input" for input variable or "output" for output variable.
// var_number:vector. The input/output variable to plot.
// y_lower_limit: a real scalar (default value = -0.1)
// y_lower_limit: a real scalar (default value = 1.1)
//  npt:scalar. Number of domain partitions.
//Description
//         <literal>plotvar </literal> plot the member function of input or output
//     variable from the <literal>fls</literal> structure. The parameter
//     <literal>npt</literal> means the number or partitions of the variable domain
//     (the default value is 101 partitions);
//Examples
// // READ A FLS
// fls=loadfls(flt_path()+"demos/fan1.fls");
// // Plot inputs variables with 1001 partitions
// scf();clf();
// plotvar(fls,"input",[1 2],-0.1,1.1,1001);
// 
// // Plot output variable with default values
// scf();clf();
// plotvar(fls,"output",1);
//See also
//plotsurf
//printrule
//newfls
//fls_structure
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Plot Variable Member Function
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
// CHANGES
// 2006-09-05 Small change in the behabiour. Now if only 01 var is
//            displayed, then no subplot is required.
// ----------------------------------------------------------------------
if (argn(2)<6) then
	npt=101;
end
if (argn(2)<5) then
	y_lower_limit=-0.1;
end
if (argn(2)<4) then
	y_upper_limit=1.1;
end
clf();

reduce_fac=0.9;

// Plot
if (inpout=='input') then
	// INPUT variable
	npq=size(var_number,"*");
       
        
	for j=1:npq,
		if (npq>1) then
			subplot(npq,1,j);
		end
		idx=var_number(j)
		dom=fls.input(idx).range;
		X=linspace(min(dom),max(dom),npt)';
		Y=[];
		LEG=[];
		//REC=[min(dom) y_lower_limit max(dom) y_upper_limit];
                REC=[min(dom) y_lower_limit; max(dom) y_upper_limit];
		for k=1:length(fls.input(idx).mf),			
			Y=[Y mfeval(X,fls.input(idx).mf(k).type,fls.input(idx).mf(k).par)];
			LEG=[LEG, fls.input(idx).mf(k).name];
		end
		
		plot(X,Y);
		legend(LEG,-1,%f);
		a=gca();
		a.axes_bounds(3)=reduce_fac;
		a.data_bounds=REC;
		a.tight_limits="on";
                xgrid();
		xtitle("Member functions for input number "+string(idx)+" named "+fls.input(idx).name,fls.input(idx).name,"mu("+fls.input(idx).name+")");
	end

elseif (inpout=='output') then
	// OUTPUT variable
	if (fls.type=="m") then
		npq=size(var_number,"*");
		for j=1:npq,
			if (npq>1) then
				subplot(npq,1,j);
			end
			idx=var_number(j)
			dom=fls.output(idx).range;
			X=linspace(min(dom),max(dom),npt)';
			Y=[];
			LEG=[];
                        REC=[min(dom) y_lower_limit; max(dom) y_upper_limit];
			//REC=[min(dom) y_lower_limit max(dom) y_upper_limit];
			for k=1:length(fls.output(idx).mf),			
				Y=[Y mfeval(X,fls.output(idx).mf(k).type,fls.output(idx).mf(k).par)];
				LEG=[LEG,fls.output(idx).mf(k).name];
			end
			plot(X,Y);
			legend(LEG,-1,%f);
 			    a=gca();
		            a.axes_bounds(3)=reduce_fac;
			    a.data_bounds=REC;
			    a.tight_limits="on";
                        xgrid();
			xtitle("Member functions for output number "+string(idx)+" named "+fls.output(idx).name,fls.output(idx).name,"mu("+fls.output(idx).name+")");
		end
	else
		npq=size(var_number,"*");
		for j=1:npq,
			if (npq>1) then
				subplot(npq,1,j);
			end
			idx=var_number(j)
			dom=fls.output(idx).range;
			X=linspace(min(dom),max(dom),npt)';
			Y=[];
			LEG=[];
			REC=[min(dom) y_lower_limit; max(dom) y_upper_limit];
			//REC=[y_lower_limit,min(dom);y_upper_limit, max(dom)];
			for k=1:length(fls.output(idx).mf),	
                               if fls.output(idx).mf(k).type=="constant" then
                                tmp=zeros(X);
                                tmp(min(find(X>fls.output(1).mf(k).par)))=1;
                                //tmp(max(1,min(find(X>fls.output(1).mf(k).par))-1))=1;
				 Y=[Y tmp];
                               else
				Y=[Y mfeval(X,fls.output(idx).mf(k).type,fls.output(idx).mf(k).par)];
                               end
				LEG=[LEG,fls.output(idx).mf(k).name];
			end
                       
                            plot(X,Y);
                            legend(LEG,-1,%f);
			    a=gca();
		            a.axes_bounds(3)=reduce_fac;
			    a.data_bounds=REC;
			    a.tight_limits="on";
			    xgrid();


			xtitle("Member functions for output number "+string(idx)+" named "+fls.output(idx).name,fls.output(idx).name,"mu("+fls.output(idx).name+")");
		end
	end
else
	error('Wrong type.');
end

endfunction
