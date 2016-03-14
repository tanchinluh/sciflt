c -----------------------------------------------------------------------
c S-NORM
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
c            Use some BLAS
c -----------------------------------------------------------------------

c **************************************************       
c GENERAL ROUTINE
c **************************************************       

      subroutine csnorm(class1,x,m,n,par,npar,y,ierr)
      character*(*) class1
      integer m,n,npar,ierr
      double precision x(m,n),par(*),y(*)

      integer i,j
      double precision tmp1,tmp2,tmp3

c DUBOIS S-NORM CLASS
      if (class1(1:6).eq."dubois") then
       if (npar.ne.1) then
        call erro("dubois s-norm class need 1 parameter.")
        ierr=1
       else if ((par(1).lt.0.0D0).or.(par(1).gt.1.0D0)) then
        call erro("dubois s-norm class need 0<=parameter<=1.")
        ierr=1
       else
        call dcopy(m,x,1,y,1)
        tmp1=1.0D0-par(1)
        do 130, j=2, n
         do 120, i=1, m
          tmp2=y(i)+x(i,j)-y(i)*x(i,j)-min(y(i),x(i,j),tmp1)
          tmp3=max(1.0D0-y(i),1.0D0-x(i,j),par(1))
          if (tmp3.eq.0.0D0) then
            call erro(
     $"UNKNOW VALUE IN DOUBOIS S-NORM CLASS (DUE INPUT AND PARAMETER")
            ierr=1
            goto 9999
          end if
          y(i)=tmp2/tmp3
120      continue
130     continue
        ierr=0
       end if
       
c YAGER S-NORM CLASS
      else if (class1(1:5).eq."yager") then
       if (npar.ne.1) then
        call erro("yagger s-norm class need 1 parameter.")
        ierr=1
       else if (par(1).le.0.0D0) then
        call erro("yagger s-norm class need parameter>0.")
        ierr=1
       else
        call dcopy(m,x,1,y,1)
        tmp1=1.0D0/par(1)
        do 230, j=2, n
         do 220, i=1, m
          tmp2=y(i)**par(1)+x(i,j)**par(1)
          y(i)=min(1.0D0,tmp2**tmp1)
220      continue
230     continue
        ierr=0
       end if

c DRASTIC-SUM S-NORM CLASS
      else if (class1(1:4).eq."dsum") then
       call dcopy(m,x,1,y,1)
       do 330, j=2, n
        do 320, i=1, m
         if (x(i,j).eq.0.0D0) then
c         mantain the same value
         else if (y(i).eq.0.0D0) then
          y(i)=x(i,j)
         else
          y(i)=1.0D0
         end if
320     continue
330    continue
       ierr=0

c EINSTEIN-SUM S-NORM CLASS
      else if (class1(1:4).eq."esum") then
       call dcopy(m,x,1,y,1)
       do 430, j=2, n
        do 420, i=1, m
         tmp3=1.0D0+y(i)*x(i,j)
         if (tmp3.eq.0.0D0) then
          call erro(
     $"UNKNOW VALUE IN EINSTEIN S-NORM CLASS DUE INPUT AND PARAMETER")
          ierr=1
          goto 9999
         endif
         y(i)=(y(i)+x(i,j))/tmp3
420     continue
430    continue
       ierr=0

c ALGEBRAIC-SUM S-NORM CLASS
      else if (class1(1:4).eq."asum") then
       call dcopy(m,x,1,y,1)
       do 530, j=2, n
        do 520, i=1, m
         y(i)=y(i)+x(i,j)-y(i)*x(i,j)
520     continue
530    continue
       ierr=0

c MAXIMUM-SUM S-NORM CLASS
      else if (class1(1:3).eq."max") then
       call dcopy(m,x,1,y,1)
       do 630, j=2, n
        do 620, i=1, m
         if (x(i,j).gt.y(i)) then
          y(i)=x(i,j)
         end if
620     continue
630    continue
       ierr=0

c UNKNOW
      else
       call erro("Unknow s-norm class.")
       ierr=1
      end if

9999  return
      end       


c **************************************************
c THIS SUBROUTINE IS FOR INTERNAL USE
c **************************************************
      subroutine csnorm2(classid,x,m,n,par,y,ierr)
      integer classid,m,n,ierr
      double precision x(m,n),par(*),y(*)

      if (classid.eq.0) then
       call csnorm("dubois",x,m,n,par,1,y,ierr)
      elseif (classid.eq.1) then
       call csnorm("yager",x,m,n,par,1,y,ierr)
      elseif (classid.eq.2) then
       call csnorm("dsum",x,m,n,par,0,y,ierr)
      elseif (classid.eq.3) then
       call csnorm("esum",x,m,n,par,0,y,ierr)
      elseif (classid.eq.4) then
       call csnorm("asum",x,m,n,par,0,y,ierr)
      elseif (classid.eq.5) then
       call csnorm("max",x,m,n,par,0,y,ierr)
      else
       call erro("Unknow s-norm class.")
       ierr=1
      end if

9999  return
      end

c **************************************************       
c THIS SUBROUTINE IS USED IN SCICOS
c **************************************************        
      subroutine ssnorm(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,rpar,
     $nrpar,ipar,nipar,u,nu,y,ny)
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*),nipar,nu,ny
      integer ierr

      if (flag.eq.1) then
       if (ipar(1).eq.0) then
        call csnorm("dubois",u,1,nu,rpar,nrpar,y,ierr)
       else if (ipar(1).eq.1) then
        call csnorm("yager",u,1,nu,rpar,nrpar,y,ierr)
       else if (ipar(1).eq.2) then
        call csnorm("dsum",u,1,nu,rpar,nrpar,y,ierr)
       elseif (ipar(1).eq.3) then
        call csnorm("esum",u,1,nu,rpar,nrpar,y,ierr)
       else if (ipar(1).eq.4) then
        call csnorm("asum",u,1,nu,rpar,nrpar,y,ierr)
       else if (ipar(1).eq.5) then
        call csnorm("max",u,1,nu,rpar,nrpar,y,ierr)       
       else
c       oops some error -> fix with 0
        y(1)=0.0D0
       end if
      end if      
      return
      end

