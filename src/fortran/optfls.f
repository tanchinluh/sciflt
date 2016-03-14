c -----------------------------------------------------------------------
c OPTIMIZATION FLS STRUCTURES
c -----------------------------------------------------------------------
c This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
c Copyright (C) @YEARS@ Jaime Urzua Grez
c mailto:jaime_urzua@yahoo.com
c 
c Holger Nahrstaedt
c -----------------------------------------------------------------------
c This program is free software; you can redistribute it and/or modify
c it under the terms of the GNU General Public License as published by
c the Free Software Foundation; either version 2 of the License, or
c (at your option) any later version.
c -----------------------------------------------------------------------
c NOTES
c Experimental stage
c -----------------------------------------------------------------------

c --------------------------------------------------
c Compute the following
c y=prod(x,'c')/sum(prod(x,'c'))
c --------------------------------------------------
       subroutine fltmulnor(x,m,n,y)
       integer m,n,i,j
       double precision x(m,n), y(m), ys
       call uinival(y(1),m,1.0D0)
       do 20,j=1,n
        do 10, i=1,m
         y(i)=y(i)*x(i,j)
10      continue
20     continue
       ys=0.0D0
       do 30, i=1, m
        ys=ys+y(i)
30     continue
       call dscal(m,1.0D0/ys,y(1),1)
       end

c --------------------------------------------------
c Compute the following
c y=sum(x,'c')/sum(sum(x,'c'))
c --------------------------------------------------
       subroutine fltsumnor(x,m,n,y)
       integer m,n,i,j
       double precision x(m,n), y(m), ys
       call uinival(y(1),m,0.0D0)
       ys=0.0D0
       do 20,j=1,n
        do 10, i=1,m
         y(i)=y(i)+x(i,j)
         ys=ys+x(i,j)
10      continue
20     continue
       call dscal(m,1.0D0/ys,y(1),1)
       end


