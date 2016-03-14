// ====================================================================
// Allan CORNET
// Simon LIPP
// INRIA 2008
// This file is released into the public domain
// ====================================================================

if getos()=="Windows" then
  // to manage long pathname
  includes_src_c = '-I""' + get_absolute_file_path('builder_gateway_c.sce') + '../../src/c""  -D__USE_DEPRECATED_STACK_FUNCTIONS__';
else
  includes_src_c = '-I' + get_absolute_file_path('builder_gateway_c.sce') + '../../src/c  -D__USE_DEPRECATED_STACK_FUNCTIONS__';
end

// PutLhsVar managed by user in sci_sum and in sci_sub
// if you do not this variable, PutLhsVar is added
// in gateway generated (default mode in scilab 4.x and 5.x)
WITHOUT_AUTO_PUTLHSVAR = %f;



table=[
	"flsencode","inter_flsencode";...
        "evalfls","inter_evalfls";...
];



  LDFLAGS = "";




LIBS= ['../../src/c/libsciFLT_c','../../src/fortran/libsciFLT_fortran'];



tbx_build_gateway('sciFLT_gateway_c', table, ['flsencode.c'], ..
                  get_absolute_file_path('builder_gateway_c.sce'), ..
                 LIBS,LDFLAGS,includes_src_c);

clear WITHOUT_AUTO_PUTLHSVAR;

clear tbx_build_gateway, table;
