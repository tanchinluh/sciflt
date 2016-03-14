function %fls_p(l)
// ----------------------------------------------------------------------
// Overload -> Display fls structure
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

write(%io(2),'         name : '''+string(l.name)+'''');
write(%io(2),'      comment : '''+string(l.comment)+'''');
write(%io(2),'         type : '''+string(l.type)+'''');
write(%io(2),'        SNorm : '''+string(l.SNorm)+'''');
write(%io(2),'     SNormPar : ['+strcat(string(l.SNormPar),' ')+']');
write(%io(2),'        TNorm : '''+string(l.TNorm)+'''');
write(%io(2),'     TNormPar : ['+strcat(string(l.TNormPar),' ')+']');
write(%io(2),'         Comp : '''+string(l.Comp)+'''');
write(%io(2),'      CompPar : ['+strcat(string(l.CompPar),' ')+']');
write(%io(2),'    ImpMethod : '''+string(l.ImpMethod)+'''');
write(%io(2),'    AggMethod : '''+string(l.AggMethod)+'''');
write(%io(2),' defuzzMethod : '''+string(l.defuzzMethod)+'''');
write(%io(2),'        input : '+string(length(l.input))+' input(s)');
write(%io(2),'       output : '+string(length(l.output))+' output(s)');
write(%io(2),'         rule : '+string(size(l.rule,1))+ ' rule(s)' );

endfunction
