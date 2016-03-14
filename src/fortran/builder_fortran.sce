// ====================================================================
// Allan CORNET
// Simon LIPP
// INRIA 2008
// This file is released into the public domain
// ====================================================================


function buildFortran()

fortran_dir = get_absolute_file_path("builder_fortran.sce");
files=['complement.f';...
        'defuzzm.f';...
        'flsengine.f';...
        'mfs.f';...
        'optfls.f';...
        'snorm.f';...
        'tnorm.f';...
        'util1.f';...
];


ldflags = "";
fflags = "";
	
if getos() == "Windows" then
	cflags = "-DWIN32";
	libs = [];
else
	include1 = fortran_dir;
	cflags = "-I"""+include1+"""";
	libs = [];
end


// if getos() == 'Windows' then
// 	  LDFLAGS = SCI + '/bin/elementary_functions_f.lib';
// end

 tbx_build_src(['sciFLT_fortran'], files, 'f', fortran_dir, libs, ldflags, cflags, fflags);


endfunction     
buildFortran();
clear buildFortran;
