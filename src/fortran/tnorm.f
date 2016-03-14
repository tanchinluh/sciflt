c -----------------------------------------------------------------------
c T-NORM
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
c CHANGES
c 2004-10-06 Change subroutine names
c 2004-11-08 Scicos Block -> Add flag detection
c -----------------------------------------------------------------------

c **************************************************
c GENERAL ROUTINE
c **************************************************
      subroutine ctnorm(class1,x,m,n,par,npar,y,ierr)
      character*(*) class1
      integer m,n,npar,ierr
      double precision x(m,n),par(*),y(*)

      integer i,j
      double precision tmp1,tmp2

c DUBOUIS T-NORM CLASS
      if (class1(1:6).eq."dubois") then
       if (npar.ne.1) then
        call erro("dubois t-norm class need 1 parameter.")
        ierr=1
       else if ((par(1).lt.0.0D0).or.(par(1).gt.1.0D0)) then
        call erro("dubois t-norm class need 0<=parameter<=1.")
        ierr=1
       else
        call dcopy(m,x,1,y,1)
        tmp1=1.0D0-par(1)
        do 130, j=2, n
         do 120, i=1, m
          tmp2=max(y(i),x(i,j),par(1))
          if (tmp2.eq.0.0D0) then
            call erro(
     $"UNKNOW VALUE IN DUBOIS TNORM CLASS DUE INPUT AND PARAMETER")
            ierr=1
            goto 9999
          endif
          y(i)=(y(i)*x(i,j))/tmp2        
120      continue
130     continue
        ierr=0
       end if
       
c YAGER T-NORM CLASS
      else if (class1(1:5).eq."yager") then
       if (npar.ne.1) then
        call erro("yagger t-norm class need 1 parameter.")
        ierr=1
       else if (par(1).le.0.0D0) then
        call erro("yagger t-norm class need parameter>0.")
        ierr=1
       else
        call dcopy(m,x,1,y,1)
        tmp1=1.0D0/par(1)
        do 230, j=2, n
         do 220, i=1, m
          tmp2=((1.0D0-y(i))**par(1)+(1.0D0-x(i,j))**par(1))**tmp1
          y(i)=1.0D0-min(1.0D0,tmp2)
220      continue
230     continue
        ierr=0
       end if

c DRASTIC-PRODUCT T-NORM CLASS
      else if (class1(1:5).eq."dprod") then
       call dcopy(m,x,1,y,1)
       do 330, j=2, n
        do 320, i=1, m
         if (x(i,j).eq.1.0D0) then
c         mantain the same value
         else if (y(i).eq.1.0D0) then
          y(i)=x(i,j)
         else
          y(i)=0.0D0
         end if
320     continue
330    continue
       ierr=0

c EINSTEIN-PRODUCT T-NORM CLASS
      else if (class1(1:5).eq."eprod") then
       call dcopy(m,x,1,y,1)
       do 430, j=2, n
        do 420, i=1, m
         tmp1=y(i)*x(i,j)
         tmp2=2.0D0-(y(i)+x(i,j)-tmp1)
         if (tmp2.eq.0.0D0) then
           call erro(
     $"UNKNOW VALUE IN EINSTEIN TNORM CLASS DUE INPUT AND PARAMETER")
           ierr=1
           goto 9999
         endif
         y(i)=tmp1/(tmp2)
420     continue
430    continue
       ierr=0

c ALGEBRAIC-PRODUCT T-NORM CLASS
      else if (class1(1:5).eq."aprod") then
       call dcopy(m,x,1,y,1)
       do 530, j=2, n
        do 520, i=1, m
         y(i)=y(i)*x(i,j)
520     continue
530    continue
       ierr=0

c MINIMUM-SUM T-NORM CLASS
      else if (class1(1:3).eq."min") then
       call dcopy(m,x,1,y,1)
       do 630, j=2, n
        do 620, i=1, m
         if (x(i,j).lt.y(i)) then
          y(i)=x(i,j)
         end if
620     continue
630    continue
       ierr=0

c UNKNOW T-NORM CLASS
      else
       call erro("Unknow t-norm class.")
       ierr=1
      end if

9999  return
      end

c **************************************************       
c THIS SUBROUTINE IS FOR INTERNAL USE
c **************************************************
      subroutine ctnorm2(classid,x,m,n,par,y,ierr)
      integer classid,m,n,ierr
      double precision x(m,n),par(*),y(*)

      if (classid.eq.0) then
       call ctnorm("dubois",x,m,n,par,1,y,ierr)
      elseif (classid.eq.1) then
       call ctnorm("yager",x,m,n,par,1,y,ierr)
      elseif (classid.eq.2) then
       call ctnorm("dprod",x,m,n,par,0,y,ierr)
      elseif (classid.eq.3) then
       call ctnorm("eprod",x,m,n,par,0,y,ierr)
      elseif (classid.eq.4) then
       call ctnorm("aprod",x,m,n,par,0,y,ierr)
      elseif (classid.eq.5) then
       call ctnorm("min",x,m,n,par,0,y,ierr)
      else
       call erro("Unknow t-norm class.")
       ierr=1
      end if
      return
      end

c **************************************************       
c THIS SUBROUTINE IS USED IN SCICOS
c **************************************************   
      subroutine stnorm(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,rpar,
     $nrpar,ipar,nipar,u,nu,y,ny)
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*),nipar,nu,ny
      integer ierr      

      if (flag.eq.1) then
       if (ipar(1).eq.0) then
        call ctnorm("dubois",u,1,nu,rpar,nrpar,y,ierr)
       else if (ipar(1).eq.1) then
        call ctnorm("yager",u,1,nu,rpar,nrpar,y,ierr)
       else if (ipar(1).eq.2) then
        call ctnorm("dprod",u,1,nu,rpar,nrpar,y,ierr)
       else if (ipar(1).eq.3) then
        call ctnorm("eprod",u,1,nu,rpar,nrpar,y,ierr)
       else if (ipar(1).eq.4) then
        call ctnorm("aprod",u,1,nu,rpar,nrpar,y,ierr)
       else if (ipar(1).eq.5) then
        call ctnorm("min",u,1,nu,rpar,nrpar,y,ierr)       
       else
c       oops some error -> fix with 0
        y(1)=0.0D0
       end if
      endif      
      return
      end

