function %flsmf_p(l)
// ----------------------------------------------------------------------
// Overload -> Display member function structure
// ----------------------------------------------------------------------
// This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
// Copyright (C) @YEARS@ Jaime Urzua Grez
// mailto:jaime_urzua@yahoo.com
// Toolbox Revision @REV@ -- @DATE@
// ----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// ----------------------------------------------------------------------

write(%io(2),' name : '''+string(l.name)+'''');
write(%io(2),' type : '''+string(l.type)+'''');
write(%io(2),'  par : ['+strcat(string(l.par),' ')+']');

endfunction
