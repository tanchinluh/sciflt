function savefls(fls,fls_filename,int_rules)
//Save fls structure in a file
//Calling Sequence
//savefls(fls,fls_filename)
//savefls(fls,fls_filename,int_rules)
//Parameters
//fls:fls structure.
// fls_filename:string, the file name where to save
// int_rules: boolean, %t - rules are written as integer (default), %f - rules are written as double
//Description
//      <literal>savefls </literal> save the fuzzy logic system <literal>fls</literal> in
//     the file <literal>fls_filename</literal>. The extension <literal>.fls</literal> is
//     only added to filename if it is not already included in the name.
//     
//     As the editor can only handle integer based rules, integer values can be forced with int_rules=%t
//Examples
// // Create a new structure
// fls1=newfls('ts');
// fls1.comment="This is an example"
// 
// // Save the structure in TMPDIR/example1.fls
// savefls(fls1,TMPDIR+"/example1");
// 
// // Restore the value
// fls2=loadfls(TMPDIR+"/example1")
//See also
//loadfls
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Save fls in a file 
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

// CHECK THE NUMBER OF INPUTS
if (argn(2)~=2) then
	error("savefls need 2 parameters.");
end
if (argn(2)<3)
  int_rules=%t;
end;

// CHECK THE FIRST ARGUMENT
if (typeof(fls)~="fls") then
	error("The first argument must be a fls.");
end

// CHECK THE SECOND ARGUMENT
if (type(fls_filename)~=10) then
	erro("The second argument must be a string.");
end
if (convstr(fileparts(fls_filename,"extension"),"l")~=".fls") then
	fls_filename2=fls_filename+".fls";
else
	fls_filename2=fls_filename;
end

// CHECK IF IS POSSIBLE TO SAVE ...
[fd,err]=mopen(fls_filename2,"w");
if (err~=0) then
	error("Unable to save in "+fls_filename2);
else

	// WRITE PREAMBLE
	mfprintf(fd,"# sciFLT scilab Fuzzy Logic Toolbox\n");
	mfprintf(fd,"<REVISION>\n");
	mfprintf(fd," <revision>@REV@\n"); 
	mfprintf(fd,"\n");

	// WRITE DESCRIPTION
	mfprintf(fd,"<DESCRIPTION>\n");
	mfprintf(fd," <name>%s\n",string(fls.name));
	mfprintf(fd," <comment>%s\n",string(fls.comment));
	mfprintf(fd," <type>%s\n",string(fls.type));
	mfprintf(fd," <SNorm>%s\n",string(fls.SNorm));
	if (fls.SNormPar==[]) then
		mfprintf(fd," <SNormPar>\n");
	else
		mfprintf(fd," <SNormPar>%1.10e\n",fls.SNormPar);
	end
	mfprintf(fd," <TNorm>%s\n",string(fls.TNorm));
	if (fls.TNormPar==[]) then
		mfprintf(fd," <TNormPar>\n");
	else
		mfprintf(fd," <TNormPar>%1.10e\n",fls.TNormPar);
	end
	mfprintf(fd," <Comp>%s\n",string(fls.Comp));
	if (fls.CompPar==[]) then
		mfprintf(fd," <CompPar>\n");
	else
		mfprintf(fd," <CompPar>%1.10e\n",fls.CompPar);
	end
	mfprintf(fd," <ImpMethod>%s\n",string(fls.ImpMethod));
	mfprintf(fd," <AggMethod>%s\n",string(fls.AggMethod));
	mfprintf(fd," <defuzzMethod>%s\n",string(fls.defuzzMethod));
	mfprintf(fd,"\n");	

	// WRITE INPUT
	mfprintf(fd,"<INPUT>\n");
	for j=1:length(fls.input),
		mfprintf(fd," <name>%s\n",fls.input(j).name);
		mfprintf(fd,"  <range>%1.10e %1.10e\n",min(fls.input(j).range),max(fls.input(j).range));
		for k=1:length(fls.input(j).mf),
		mfprintf(fd,"   <mf_name>%s\n",string(fls.input(j).mf(k).name));
		mfprintf(fd,"    <mf_type>%s\n",string(fls.input(j).mf(k).type));
		mfprintf(fd,"    <mf_par>");
			for h=1:length(fls.input(j).mf(k).par),
				mfprintf(fd,"%1.10e ",fls.input(j).mf(k).par(h));
			end
			mfprintf(fd,"\n");
		end
	end
	mfprintf(fd,"\n");
	
	// WRITE OUTPUT
	mfprintf(fd,"<OUTPUT>\n");
	for j=1:length(fls.output),
		mfprintf(fd," <name>%s\n",fls.output(j).name);
		mfprintf(fd,"  <range>%1.10e %1.10e\n",min(fls.output(j).range),max(fls.output(j).range));
		for k=1:length(fls.output(j).mf),
		mfprintf(fd,"   <mf_name>%s\n",string(fls.output(j).mf(k).name));
		mfprintf(fd,"    <mf_type>%s\n",string(fls.output(j).mf(k).type));
		mfprintf(fd,"    <mf_par>");
			for h=1:length(fls.output(j).mf(k).par),
				mfprintf(fd,"%1.10e ",fls.output(j).mf(k).par(h));
			end
			mfprintf(fd,"\n");
		end
	end
	mfprintf(fd,"\n");
	
	// WRITE RULE
	mfprintf(fd,"<RULE>\n");
	np1=size(fls.rule,2)-1;
	for j=1:size(fls.rule,1),
		for k=1:np1,
		      if (int_rules) then
			mfprintf(fd,"%1.0f ",fls.rule(j,k)); 
		      else
			mfprintf(fd,"%1.3f ",fls.rule(j,k)); 
		      end;
		end
		mfprintf(fd,"%1.10e\n",fls.rule(j,np1+1));
	end
end

mclose(fd);

endfunction
