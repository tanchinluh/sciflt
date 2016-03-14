c -----------------------------------------------------------------------
c Defuzzification
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

c **************************************************       
c GENERAL ROUTINE
c **************************************************
      subroutine defuzzm(method,x,m,y,ou,ierr)
      character*(*) method
      integer m,ierr
      double precision x(*),y(*),ou

      integer i
      double precision tmp1,tmp2
 
c CENTROIDE
      if (method(1:9).eq."centroide") then
       tmp1=0.0D0
       ou=0.0D0
       do 100, i=1, m
        tmp1=tmp1+y(i)
        ou=ou+x(i)*y(i)
100    continue
       if (tmp1.eq.0.0D0) then
        call erro("Total area is cero.")
        ierr=1
       else
        ou=ou/tmp1
        ierr=0
       endif

c BISECTOR
      elseif (method(1:8).eq."bisector") then
       tmp1=0.0D0
       do 200, i=1, m
        tmp1=tmp1+y(i)
200    continue
       if (tmp1.eq.0.0D0) then
        call erro("Total area is cero.")
        ierr=1
       else
        tmp1=tmp1/2.0D0
        tmp2=0.0D0
        do 210, i=1, m
         tmp2=tmp2+y(i)
         if (tmp2.ge.tmp1) then
          goto 220
         endif
210     continue
        i=m
220     ou=x(i)
        ierr=0
       endif

c MEAN OF MAXIMUM
      elseif (method(1:3).eq."mom") then
      ou=x(1)
      tmp1=y(1)
      tmp2=1.0D0
      do 300, i=2, m
       if (y(i).eq.tmp1) then
        ou=ou+x(i)
        tmp2=tmp2+1.0D0
       elseif (y(i).gt.tmp1) then
        tmp1=y(i)
        ou=x(i)
        tmp2=1.0D0
       endif
300   continue
      ou=ou/tmp2
      ierr=0

c SHORTEST OF MAXIMUM
      elseif (method(1:3).eq."som") then
      ou=x(1)
      tmp1=y(1)
      do 400, i=2, m
       if (y(i).eq.tmp1) then
        if (x(i).lt.ou) then
          ou=x(i)
        endif
       elseif (y(i).gt.tmp1) then
        tmp1=y(i)
        ou=x(i)
       endif
400   continue
      ierr=0

c LARGEST OF MAXIMUM
      elseif (method(1:3).eq."lom") then
      ou=x(1)
      tmp1=y(1)
      do 500, i=2, m
       if (y(i).eq.tmp1) then
        if (x(i).gt.ou) then
         ou=x(i)
        endif
       elseif (y(i).gt.tmp1) then
        tmp1=y(i)
        ou=x(i)
       endif
500   continue
      ierr=0

c UNKNOW METHOD
      else
       call erro("Unknow method.")
       ierr=1
      end if
      
9999  return
      end

c **************************************************       
c CALL BY ID
c **************************************************
      subroutine defuzzm2(methodid,x,m,y,ou,ierr)
      integer methodid,m,ierr
      double precision x(*),y(*),ou

      if (methodid.eq.0) then
       call defuzzm("centroide",x,m,y,ou,ierr)
      elseif (methodid.eq.1) then
       call defuzzm("bisector",x,m,y,ou,ierr)
      elseif (methodid.eq.2) then
       call defuzzm("mom",x,m,y,ou,ierr)
      elseif (methodid.eq.3) then
       call defuzzm("som",x,m,y,ou,ierr)
      elseif (methodid.eq.4) then
       call defuzzm("lom",x,m,y,ou,ierr)      
      else
       call erro("Unknow method.")
       ierr=1
      end if

9999  return
      end       
