// This file is released under the 3-clause BSD license. See COPYING-BSD.
// Generated by builder.sce : Please, do not edit this file
// ----------------------------------------------------------------------------
//
if ~win64() then
  warning(_("This module requires a Windows x64 platform."));
  return
end
//
sciFLT_c_xcos_path = get_absolute_file_path('loader.sce');
//
// ulink previous function with same name
[bOK, ilib] = c_link('sfls');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('scomplement');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('stnorm');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('ssnorm');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('smfeval');
if bOK then
  ulink(ilib);
end
//
link(sciFLT_c_xcos_path + filesep() + '../c_scilab/libsciFLT_c_scilab' + getdynlibext());
link(sciFLT_c_xcos_path + 'libsciFLT_c_xcos' + getdynlibext(), ['sfls','scomplement','stnorm','ssnorm','smfeval'],'c');
// remove temp. variables on stack
clear sciFLT_c_xcos_path;
clear bOK;
clear ilib;
// ----------------------------------------------------------------------------