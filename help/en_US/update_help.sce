// Copyright (C) 2010 - 2011 - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

// Updates the .xml files by deleting existing files and 
// creating them again from the .sci with help_from_sci.


//
cwd = get_absolute_file_path("update_help.sce");
mprintf("Working dir = %s\n",cwd);





//
cwd = get_absolute_file_path("update_help.sce");
mprintf("Working dir = %s\n",cwd);
//
// Generate the fuzzy logic toolbox help
mprintf("Updating fls\n");
helpdir = fullfile(cwd,"./");
funmat = [
  "addmf"
  "addvar"
  "checkrule"
  "delmf"
  "delvar"
  "editfls"
  "fcmeans"
  "flt_path"
  "fuzzapp"
  "importfis"
  "inwichclust"
  "loadfls"
  "m2ts"
  "newfls"
  "optfls01"
  "plotsurf"
  "plotvar"
  "printrule"
  "savefls"
  "subclust"
  "addrule"
  "sciFLTEditor"
  ];
macrosdir = cwd +"../../macros";
//demosdir = cwd +"../../demos";
demosdir = [];
modulename = "sciFLT";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t )
//

// Generate the fuzzy logic toolbox help
mprintf("Updating fls 2\n");
helpdir = fullfile(cwd,"./");
funmat = [
  "complement"
  "constant"
  "defuzzm"
  "dsigmf"
  "evalfls"
  "gauss2mf"
  "gaussmf"
  "linear"
  "mfeval"
  "pimf"
  "psigmf"
  "repvec"
  "sigmf"
  "smf"
  "snorm"
  "tnorm"
  "trapmf"
  "trimf"
  "zmf"
  "gbellmf"
  ];
macrosdir = cwd +"../../macros/help_from_sci";
//demosdir = cwd +"../../demos";
demosdir = [];
modulename = "sciFLT";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t )
//

