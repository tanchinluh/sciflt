// ====================================================================
// Allan CORNET
// Simon LIPP
// INRIA 2008
// This file is released into the public domain
// ====================================================================

src_c_path = get_absolute_file_path('builder_c.sce');


  CFLAGS = ilib_include_flag(src_c_path);
  LDFLAGS = "";
  if (getos()<>"Windows") then
    if ~isdir(SCI+"/../../share") then
      // Source version
      CFLAGS = CFLAGS + " -I" + SCI + "/modules/scicos_blocks/includes" ;
      CFLAGS = CFLAGS + " -I" + SCI + "/modules/scicos/includes  -D__USE_DEPRECATED_STACK_FUNCTIONS__" ;
    else
      // Release version
      CFLAGS = CFLAGS + " -I" + SCI + "/../../include/scilab/scicos_blocks";
      CFLAGS = CFLAGS + " -I" + SCI + "/../../include/scilab/scicos  -D__USE_DEPRECATED_STACK_FUNCTIONS__";
    end
  else
    CFLAGS = CFLAGS + " -I" + SCI + "/modules/scicos_blocks/includes";
    CFLAGS = CFLAGS + " -I" + SCI + "/modules/scicos/includes  -D__USE_DEPRECATED_STACK_FUNCTIONS__";

    // Getting symbols
    if findmsvccompiler() <> "unknown" & haveacompiler() then
      LDFLAGS = LDFLAGS + " """ + SCI + "/bin/scicos.lib""";
      LDFLAGS = LDFLAGS + " """ + SCI + "/bin/scicos_f.lib""";
    end
  end




  tbx_build_src(['sfls','scomplement','stnorm','ssnorm','smfeval'],        ..
                [ "sfls.c","scomplement.c","stnorm.c","ssnorm.c","smfeval.c","util2.c"],   ..
                "c",                                  ..
                src_c_path,                           ..
                ['../fortran/libsciFLT_fortran'],     ..
                LDFLAGS,                              ..
                CFLAGS,                               ..
                "",                                   ..
                "",                                   ..
                "sciFLT_c");



clear tbx_build_src;
clear src_c_path;
clear CFLAGS;
