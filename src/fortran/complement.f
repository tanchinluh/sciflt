c -----------------------------------------------------------------------
c Fuzzy Complement
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

      subroutine complement(class1,x,m,n,par,npar,y,ierr)
      character*(*) class1
      integer m,n,npar,ierr
      double precision x(m,n),par(*),y(m,n)

      integer i,j
      double precision tmp1

c ONE COMPLEMENT CLASS
      if (class1(1:3).eq."one") then
       do 120, j=1, n
        do 110, i=1, m
         y(i,j)=1.0D0-x(i,j)
110     continue
120    continue
       ierr=0
       
c YAGER COMPLEMENT CLASS
      else if (class1(1:5).eq."yager") then
       if (npar.ne.1) then
        call erro("yagger complement class need 1 parameter.")
        ierr=1
       else if (par(1).le.0.0D0) then
        call erro("yagger complenent class need parameter>0.")
        ierr=1
       else
        tmp1=1.0D0/par(1)
        do 220, j=1, n
         do 210, i=1, m
          y(i,j)=(1.0D0-x(i,j)**par(1))**tmp1
210      continue
220     continue
        ierr=0
       end if

c SUGENO COMPLEMENT CLASS
      else if (class1(1:6).eq."sugeno") then
       if (npar.ne.1) then
        call erro("sugeno complement class need 1 parameter.")
        ierr=1
       else if (par(1).le.-1.0D0) then
        call erro("sugeno complenent class need parameter>-1.")
        ierr=1
       else
        do 320, j=1, n
         do 310, i=1, m
          tmp1=1.0D0+par(1)*x(i,j)
          if (tmp1.eq.0.0D0) then
           ierr=1
           call erro(
     $"UNKNOW VALUE IN SUGENO COMPLEMENT (DUE PARAMETER AND INPUT)")
           goto 9999
          endif
          y(i,j)=(1.0D0-x(i,j))/(tmp1)
310      continue
320     continue
        ierr=0
       end if

c UNKNOW COMPLEMENT CLASS
      else
       call erro("Unknow complement class.")
       ierr=1
      end if

9999  return
      end

c **************************************************       
c THIS SUBROUTINE IS FOR INTERNAL USE
c **************************************************       
      subroutine complement2(classid,x,m,n,par,y,ierr)
      integer classid,m,n,ierr
      double precision x(m,n),par(*),y(m,n)

      if (classid.eq.0) then
        call complement("one",x,m,n,par,0,y,ierr)
      elseif (classid.eq.1) then
        call complement("yager",x,m,n,par,1,y,ierr)
      elseif (classid.eq.2) then
        call complement("sugeno",x,m,n,par,1,y,ierr)
      else
       call erro("Unknow complement class.")
       ierr=1
      end if
      
9999  return
      end

c **************************************************       
c THIS SUBROUTINE IS USED IN SCICOS
c **************************************************            
      subroutine scomplement(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,rpar,
     $nrpar,ipar,nipar,u,nu,y,ny)
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*),nipar,nu,ny
      integer ierr
      
      if (ipar(1).eq.0) then
       call complement("one",u,nu,1,rpar,nrpar,y,ierr)
      else if (ipar(1).eq.1) then
       call complement("yager",u,nu,1,rpar,nrpar,y,ierr)
      else if (ipar(1).eq.2) then
       call complement("sugeno",u,nu,1,rpar,nrpar,y,ierr)
      else
c      oops some error -> fix with 0
       y(1)=0.0D0
      end if
      
      return
      end 
       
