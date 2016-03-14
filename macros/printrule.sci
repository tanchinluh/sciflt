function printrule(fls,method,filename)
//Print fls rules in the screen or put it in a file
//Calling Sequence
//printrule(fls [,method [,filename]])
//Parameters
//fls:fls structure.
// method:string. "ling" for linguistic representation, "symb" for symbolic representation, and "indx" for indexed representation. The default value is "ling".
// filename:string. The file name were to put the rules.
//Description
//         <literal>printule </literal> print the <literal>fls</literal> rules in a human
//     readable form. The result can be put in a file named
//     <literal>filename</literal>.
//Examples
// // READ A FLS
// fls=loadfls(flt_path()+"demos/fan1.fls");
// // Print rules to screen. Linguistic representation
// printrule(fls);
// // Print rules to screen. Simbolic representation
// printrule(fls,"symb");
// // Print rule to scree. Indexed representation
// printrule(fls,"indx");
// // Print rules in a file
// printrule(fls,"symb",TMPDIR+"/rules.txt");
//See also
//plotsurf
//plotvar
//newfls
//fls_structure
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Show in screen or write to file fls rules
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
// CHANGES:
// 2004-11-08 Spell check.
// ----------------------------------------------------------------------

// CHECK INPUTS
if (argn(2)>0) then
	if (typeof(fls)~="fls") then
		error("printrule need a fls structure!");
	end
else
	error("printule need at least 1 parameter.");
end

// SET DEFAULT METHOD AND CHECK
if (argn(2)<2) then
	method="ling";
end

if ((method~="ling")&(method~="symb")&(method~="indx")) & ((method~="linguistic")&(method~="symbolic")&(method~="indexed")) then
	error("Unknow method.");
end


// CHECK RULES
[ok,mes]=checkrule(fls);

if (ok~=0) then
	// THE RULES HAVE PROBLEMS
	write(%io(2),'The rules have problems... '+mes);
	
else
	// THE RULES ARE OK
	rr=1;
	if (argn(2)==3) then
		toscreen=%f;
		[u,rr]=mopen(filename,'w');
		if (rr~=0) then
			error('Something is wrong with file output.');
		end
		write(%io(2),'Please wait.');
	else
		toscreen=%t;
	end
	
	rule=fls.rule;
	ninputs=length(fls.input);
	noutputs=length(fls.output);
	nrules=size(rule,1);
	
        select method
          case "linguistic" then 
               method="ling"
          case "symbolic" then 
               method="symb"
          case "indexed" then 
               method="indx"
        end;

	for j=1:nrules,
		// IF PART	
		if ((method=="ling")|(method=="symb")) then
			str="R"+string(j)+":";
			if (method=="ling") then
				str=str+" IF";
			end
		else
			str=string(j)+":";
		end
		
		me=rule(j,$-1);
		we=rule(j,$);
		docon=%f;
		for k=1:ninputs,
			idx=rule(j,k);
                        hedge_num = round (100 * (abs(idx) - fix(abs(idx))));
			if (idx<0) then
				docomplement=%t;
			else
				docomplement=%f;
			end
			idx=abs(fix(idx));
			if (idx>0) then
				if (docon) then
					if (k~=1) then
						if (method=="ling") then
							if (me==0) then
								str=str+" OR";
							else
								str=str+" AND";
							end							
						else 
							if (me==0) then
								str=str+" |";
							else
								str=str+" &";
							end						
						end
					end
				end
				docon=%t;
				if (method=="ling") then
					str=str+" ("+string(fls.input(k).name);
					if (docomplement) then
						str=str+" ISN''T ";
					else
						str=str+" IS ";
					end

					select(hedge_num)
					    case 0 then ;
					    case 5 then str=str+" somewhat ";
					    case 20 then str=str+" very ";
					    case 30 then str=str+" extremely ";
					    case 40 then str=str+" very very ";
					    else str=str+" "+string(hedge_num/10)+" ";
					end;

					str=str+string(fls.input(k).mf(idx).name)+")";
				elseif (method=="symb")
					str=str+" ("+string(fls.input(k).name);
					if (docomplement) then
						str=str+" ~= ";
					else
						str=str+" == ";
					end

					if hedge_num>0 then
					  str=str+string(fls.input(k).mf(idx).name)+"^"+string(hedge_num/10)+")";
					else
					  str=str+string(fls.input(k).mf(idx).name)+")";
					end
				else
					str=str+" (I_"+string(k);
					if (docomplement) then
						str=str+"~=";
					else
						str=str+"==";
					end
					if hedge_num>0 then
					  str=str+"mf_"+string(idx)+"^"+string(hedge_num/10)+")";
                                        else
					   str=str+"mf_"+string(idx)+")";
					end;
				end
			end
		end

		// THEN PART
		if (method=="ling") then
			str=str+" THEN ";
		else
			str=str+" => ";
		end		
		docon=%f;
		for k=1:noutputs,
			idx=rule(j,k+ninputs);
			hedge_num = round (100 * (abs(idx) - fix(abs(idx))));
			if (idx<0) then
				docomplement=%t;
			else
				docomplement=%f;
			end
			idx=abs(fix(idx));
			if ((docon)&(k~=noutputs)) then
				if ((method=="ling")|(method=="symb")) then
					str=str+" , ";
				else
					str=str+" ";				
				end
			end

			if (idx>0) then
				if (method=="ling") then
					str=str+"("+string(fls.output(k).name)+" IS ";
					select(hedge_num)
					    case 0 then ;
					    case 5 then str=str+" somewhat ";
					    case 20 then str=str+" very ";
					    case 30 then str=str+" extremely ";
					    case 40 then str=str+" very very ";
					    else str=str+" "+string(hedge_num/10)+" ";
					end;
					str=str+string(fls.output(k).mf(idx).name)+")";
				elseif (method=="symb") then
					str=str+"("+string(fls.output(k).name)+" = ";

					if hedge_num>0 then
					str=str+string(fls.output(k).mf(idx).name)+"^"+string(hedge_num/10)+")";
					else
					str=str+string(fls.output(k).mf(idx).name)+")";
					end
				else
					str=str+"(O_"+string(k)+"=";
					if hedge_num>0 then
					  str=str+"mf_"+string(idx)+"^"+string(hedge_num/10)+")";
					else
					str=str+"mf_"+string(idx)+")";
					end
				end
			end
		end

		// WEIGTH PART
		if (method=="ling") then
			str=str+" weigth="+string(rule(j,$));
		else
			str=str+" ["+string(rule(j,$))+"]";
		end

		// PUT THE RESULT IN THE SCREEN OR IN A FILE
		if (toscreen) then
			write(%io(2),str);
		else 
			mputstr(str,u);
			mfprintf(u,"\n");			
		end
	end

	// CLOSE THE FILE IF THE OUTPUT IS A FILE
	if (~toscreen) then
		mclose(u);
	end
end

endfunction

