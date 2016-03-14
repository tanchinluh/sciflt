function editfls_export_fis(fisname)
// ----------------------------------------------------------------------
// Export fis structure from file to editor
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

flsdum=importfis(string(fisname)); // THIS CALL MAYBE CAUSE A BUG ?
editfls flsdum;

endfunction
