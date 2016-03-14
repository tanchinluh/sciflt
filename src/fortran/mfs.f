c -----------------------------------------------------------------------
c Member functions
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
c 2004-11-08 Change some internal subroutines to use BLAS primitives
c            Change SCICOS block -> Add flag detection
c -----------------------------------------------------------------------

c **************************************************       
c TRIANGULAR MEMBER FUNCTION
c **************************************************       
       subroutine trimf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision a,b,c,tmp1,tmp2

       a=par(1)
       b=par(2)
       c=par(3)
       tmp1=b-a
       tmp2=c-b

c CHECK PARAMETERS
       if ((tmp1.lt.0.0D0).or.(tmp2.lt.0.0D0)) then
        call flterr(1000)
        ierr=1
        goto 9999
       end if

c COMPUTE MEMBER FUNCTION
       do 20, j=1, n
        do 10, i=1, m
         if ((x(i,j).le.a).or.(x(i,j).ge.c)) then
          y(i,j)=0.0D0
         else if (x(i,j).lt.b) then
          y(i,j)=(x(i,j)-a)/tmp1
         else if (x(i,j).eq.b) then
          y(i,j)=1.0D0
         else
          y(i,j)=(c-x(i,j))/tmp2
         end if
10      continue
20     continue
       ierr=0
    
9999   return
       end

c **************************************************       
c TRAPEZOIDAL MEMBER FUNCTION
c **************************************************       
       subroutine trapmf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision a,b,c,d,tmp1,tmp2

       a=par(1)
       b=par(2)
       c=par(3)
       d=par(4)
       tmp1=b-a
       tmp2=d-c

c CHECK PARAMETERS
c       if ((tmp1.le.0.0D0).or.(tmp2.le.0.0D0).or.(c.lt.b)) then
       if ((tmp1.lt.0.0D0).or.(tmp2.lt.0.0D0).or.(c.lt.b)) then
        call flterr(1010)
        ierr=1
        goto 9999
       end if

c COMPUTE MEMBER FUNCTION
       do 20, j=1, n
        do 10, i=1, m
         if ((x(i,j).le.a).or.(x(i,j).ge.d)) then
          y(i,j)=0.0D0
         else if (x(i,j).lt.b) then
          y(i,j)=(x(i,j)-a)/tmp1
         else if ((x(i,j).ge.b).and.(x(i,j).le.c)) then
          y(i,j)=1.0D0
         else
          y(i,j)=(d-x(i,j))/tmp2
         end if
10      continue
20     continue
       ierr=0

9999   return
       end

c **************************************************
c GAUSSIAN MEMBER FUNCTION
c **************************************************
       subroutine gaussmf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision sig,c,tmp1,tmp2

       sig=par(1)
       c=par(2)
       tmp1=2.0D0*sig*sig

c CHECK PARAMETERS
       if (sig.eq.0.0D0) then
        call flterr(1020)
        ierr=1
        goto 9999
       end if

c COMPUTE MEMBER FUNCTION
       do 20, j=1, n
        do 10, i=1, m
         tmp2=(x(i,j)-c)**2         
         y(i,j)=exp(-tmp2/tmp1)
10      continue
20     continue
       ierr=0
    
9999   return
       end

c **************************************************
c EXTENDED GAUSSIAN MEMBER FUNCTION
c **************************************************
       subroutine gauss2mf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision sig1,c1,sig2,c2,tmp1,tmp2,tmp3,tmp4

       sig1=par(1)
       c1=par(2)
       sig2=par(3)
       c2=par(4)
       tmp1=2.0D0*sig1*sig1
       tmp2=2.0D0*sig2*sig2

c CHECK PARAMETERS
       if ((sig1.eq.0.0D0).or.(sig2.eq.0.0D0)) then
        call flterr(1030)        
        ierr=1
        goto 9999
       end if

c COMPUTE MEMBER FUNCTION
       do 20, j=1, n
        do 10, i=1, m
         if (x(i,j).le.c1) then
          tmp3=(x(i,j)-c1)**2
          tmp3=exp(-tmp3/tmp1)
         else
          tmp3=1.0D0
         end if
         
         if (x(i,j).ge.c2) then
          tmp4=(x(i,j)-c2)**2
          tmp4=exp(-tmp4/tmp2)
         else
          tmp4=1.0D0
         end if
         
         y(i,j)=tmp3*tmp4
10      continue
20     continue
       ierr=0

9999   return
       end

c **************************************************
c SIGMOIDAL MEMBER FUNCTION
c **************************************************
       subroutine sigmf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision a,b,tmp1

       a=par(1)
       b=par(2)

c COMPUTE MEMBER FUNCTION
       do 20, j=1, n
        do 10, i=1, m
         tmp1=par(1)*(x(i,j)-par(2))
         y(i,j)=1.0D0/(1.0D0+exp(-tmp1))
10      continue
20     continue
       ierr=0   

9999   return
       end

c **************************************************
c PRODUCT OF TWO SIGMOIDAL MEMBER FUNCTION
c **************************************************
       subroutine psigmf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision a,b,c,d,tmp1,tmp2

c INITIALIZE SOME INTERNAL
       a=par(1)
       b=par(2)
       c=par(3)
       d=par(4)

c COMPUTE MEMBER FUNCTION
       do 20, j=1, n
        do 10, i=1, m
         tmp1=par(1)*(x(i,j)-par(2))
         tmp1=1.0D0/(1.0D0+exp(-tmp1))
         tmp2=par(3)*(x(i,j)-par(4))
         tmp2=1.0D0/(1+0D0+exp(-tmp2))         
         y(i,j)=tmp1*tmp2
10      continue
20     continue
       ierr=0
    
9999   return
       end

c **************************************************
c DIFFERENCE OF TWO SIGMOIDAL MEMBER FUNCTION
c **************************************************
       subroutine dsigmf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision a,b,c,d,tmp1,tmp2

       a=par(1)
       b=par(2)
       c=par(3)
       d=par(4)

c COMPUTE MEMBER FUNCTION
       do 20, j=1, n
        do 10, i=1, m
          tmp1=par(1)*(x(i,j)-par(2))
          tmp1=1.0D0/(1.0D0+exp(-tmp1))
          tmp2=par(3)*(x(i,j)-par(4))
          tmp2=1.0D0/(1.0D0+exp(-tmp2))
          y(i,j)=abs(tmp1-tmp2)
10      continue
20     continue
       ierr=0
    
9999   return
       end

c **************************************************
c GENERALIZED BELL MEMBER FUNCTION
c **************************************************
       subroutine gbellmf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision a,b,c,tmp1

       a=par(1)
       b=par(2)
       c=par(3)

c CHECK PARAMETERS
       if (b.eq.0.D0) then
        call flterr(1040)
        ierr=1
        goto 9999
       end if

c COMPUTE MEMBER FUNCTION
       do 20, j=1, n
        do 10, i=1, m
c         if (par(3).eq.0.D0) then
c          y(i,j)=0.5D0
c         elseif (par(3).lt.0.0D0) then
c          y(i,j)=0.0D0
c         else
          tmp1=(x(i,j)-c)/a
          if (tmp1.lt.0.0D0) then
           tmp1=-tmp1
          endif
          tmp1=tmp1**(2.0D0*b)
          y(i,j)=1.0D0/(1.0D0+tmp1)
c         end if
10      continue
20     continue
       ierr=0
    
9999   return
       end

c **************************************************
c PI-SHAPED MEMBER FUNCTION
c **************************************************
       subroutine pimf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision a(2),b(2),tmp1,tmp2

       a(1)=par(1)
       a(2)=par(2)
       b(1)=par(3)
       b(2)=par(4)

c COMPUTE MEMBER FUNCTION
       do 20, j=1, n
        do 10, i=1, m
c        TAKE MUCH TIME ¿ OPTMIZATION ?
         call smf(x(i,j),1,1,a,tmp1,ierr)
         call zmf(x(i,j),1,1,b,tmp2,ierr)
         y(i,j)=tmp1*tmp2
10      continue
20     continue       

9999   return
       end       

c **************************************************
c S-SHAPED MEMBER FUNCTION
c **************************************************
       subroutine smf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision a,b,tmp1,tmp2

       a=par(1)
       b=par(2)
       tmp1=(a+b)/2.0D0
       tmp2=b-a

c COMPUTE MEMBER FUNCTION
       if (a.ge.b) then
        do 20, j=1, n
         do 10, i=1, m
          if (x(i,j).ge.tmp1) then
           y(i,j)=1.0D0
          else
           y(i,j)=0.0D0
          end if
10       continue
20      continue
       else
        do 40, j=1, n
         do 30, i=1, m
          if (x(i,j).le.a) then
           y(i,j)=0.0D0
          else if (x(i,j).le.tmp1) then
           y(i,j)=2.0D0*((x(i,j)-a)/tmp2)**2
          else if (x(i,j).le.b) then
           y(i,j)=1.0D0-2.0D0*((b-x(i,j))/tmp2)**2
          else
           y(i,j)=1.0D0
          end if
30       continue
40      continue
       end if
       ierr=0
    
9999   return
       end

c **************************************************
c Z-SHAPED MEMBER FUNCTION
c **************************************************
       subroutine zmf(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m,n)

       integer i,j
       double precision a,b,tmp1,tmp2

       a=par(1)
       b=par(2)
       tmp1=(a+b)/2.0D0
       tmp2=b-a

c COMPUTE MEMBER FUNCTION
       if (a.ge.b) then
        do 20, j=1, n
         do 10, i=1, m
          if (x(i,j).le.tmp1) then
           y(i,j)=1.0D0
          else
           y(i,j)=0.0D0
          end if
10       continue
20      continue
       else
        do 40, j=1, n
         do 30, i=1, m
          if (x(i,j).le.a) then
           y(i,j)=1.0D0
          else if (x(i,j).le.tmp1) then
           y(i,j)=1.0D0-2.0D0*((x(i,j)-a)/tmp2)**2
          else if (x(i,j).le.b) then
           y(i,j)=2.0D0*((b-x(i,j))/tmp2)**2
          else
           y(i,j)=0.0D0
          end if
30       continue
40      continue
       end if
       ierr=0

9999   return
       end

c **************************************************
c CONSTANT MEMBER FUNCTION
c **************************************************
       subroutine constant(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m)

       integer i

c COMPUTE MEMBER FUNCTION
       call uinival(y,m,par(1))
       ierr=0

9999   return
       end       

c **************************************************
c LINEAR MEMBER FUNCTION
c **************************************************
       subroutine linear(x,m,n,par,y,ierr)
       integer m,n,ierr
       double precision x(m,n),par(*),y(m)

       integer i,j
       double precision tmp1

c COMPUTE MEMBER FUNCTION
       call uinival(y,m,par(n+1))        
       do 30, j=1, n
       if (par(j).ne.0.0D0) then
        call daxpy(m,par(j),x(1,j),1,y,1)
       endif
30     continue
       ierr=0 


9999   return
       end

c **************************************************
c EVALUATE MEMBER FUNCTION
c **************************************************
      subroutine mfeval(mfname,x,m,n,par,npar,y,ierr)
      character*(*) mfname
      integer m,n,npar,ierr
      double precision x(m,n),par(*),y(m,n)

c TRIANGULAR MEMBER FUNCTION
      if (mfname(1:5).eq."trimf") then
       if (npar.ne.3) then
        call erro("trimf need 3 parameters in a row vector.")
        ierr=1
       else
        call trimf(x,m,n,par,y,ierr)
       end if

c TRAPEZOIDAL MEMBER FUNCTION
      else if (mfname(1:6).eq."trapmf") then
       if (npar.ne.4) then
        call erro("trapmf need 4 parameters in a row vector.")
        ierr=1
       else
        call trapmf(x,m,n,par,y,ierr)
       end if

c GAUSSIAN MEMBER FUNCTION
      else if (mfname(1:7).eq."gaussmf") then       
       if (npar.ne.2) then
        call erro("gaussmf need 2 parameters in a row vector.")
        ierr=1
       else
        call gaussmf(x,m,n,par,y,ierr)
       end if

c EXTENDED GAUSSIAN MEMBER FUNCTION
      else if (mfname(1:8).eq."gauss2mf") then
       if (npar.ne.4) then
        call erro("gauss2mf need 4 parameters in a row vector.")
        ierr=1
       else
        call gauss2mf(x,m,n,par,y,ierr)
       end if
       
c SIGMOIDAL MEMBER FUNCTION
      else if (mfname(1:5).eq."sigmf") then
       if (npar.ne.2) then
        call erro("sigmf need 2 parameters in a row vector.")
        ierr=1
       else
        call sigmf(x,m,n,par,y,ierr)
       end if

c PRODUCT OF TWO SIGMOIDAL MEMBER FUNCTION
      else if (mfname(1:6).eq."psigmf") then
       if (npar.ne.4) then
        call erro("psigmf need 4 parameters in a row vector.")
        ierr=1
       else
        call psigmf(x,m,n,par,y,ierr)
       end if
       
c DIFFERENCE OF TWO SIGMOIDAL MEMBER FUNCTION
      else if (mfname(1:6).eq."dsigmf") then
       if (npar.ne.4) then
        call erro("dsigmf need 4 parameters in a row vector.")
        ierr=1
       else
        call dsigmf(x,m,n,par,y,ierr)
       end if
       
c GENERALIZED BELL MEMBER FUNCTION
      else if (mfname(1:7).eq."gbellmf") then
       if (npar.ne.3) then
        call erro("gbellmf need 3 parameters in a row vector.")
        ierr=1
       else
        call gbellmf(x,m,n,par,y,ierr)
       end if

c Pi-Shaped BELL MEMBER FUNCTION
      else if (mfname(1:4).eq."pimf") then
       if (npar.ne.4) then
        call erro("pimf need 4 parameters in a row vector.")
        ierr=1
       else
        call pimf(x,m,n,par,y,ierr)
       end if

c S-Shaped BELL MEMBER FUNCTION
      else if (mfname(1:3).eq."smf") then
       if (npar.ne.2) then
        call erro("smf need 2 parameters in a row vector.")
        ierr=1
       else
        call smf(x,m,n,par,y,ierr)
       end if

c Z-Shaped BELL MEMBER FUNCTION
      else if (mfname(1:3).eq."zmf") then
       if (npar.ne.2) then
        call erro("zmf need 2 parameters in a row vector.")
        ierr=1
       else
        call zmf(x,m,n,par,y,ierr)
       end if

c CONSTANT MEMBER FUNCTION
      else if (mfname(1:8).eq."constant") then
       if (npar.ne.1) then
        call erro("constant need 1 parameters in a row vector.")
        ierr=1
       else
        call constant(x,m,n,par,y,ierr)
       end if

c LINEAR MEMBER FUNCTION
      else if (mfname(1:6).eq."linear") then
       if (npar.ne.(n+1)) then
        call erro("incorrect number of parameters.")
        ierr=1
       else
        call linear(x,m,n,par,y,ierr)
       end if
       
c UNKNOW MEMBER FUNCTION
      else
       call erro("Unknow Member Function Type.")
       ierr=1
      end if
      
9999  return
      end


c **************************************************
c EVALUATE MEMBER FUNCTION USING ID
c **************************************************
      subroutine mfeval2(mfid,x,m,n,par,y,ierr)
      integer mfid,m,n,ierr
      double precision x(m,n),par(*),y(m,n)
       
c TRIANGULAR MEMBER FUNCTION
      if (mfid.eq.1) then       
       call trimf(x,m,n,par,y,ierr)

c TRAPEZOIDAL MEMBER FUNCTION
      else if (mfid.eq.2) then
       call trapmf(x,m,n,par,y,ierr)

c GAUSSIAN MEMBER FUNCTION
      else if (mfid.eq.3) then       
       call gaussmf(x,m,n,par,y,ierr)
       
c EXTENDED GAUSSIAN MEMBER FUNCTION
      else if (mfid.eq.4) then
       call gauss2mf(x,m,n,par,y,ierr)
       
c SIGMOIDAL MEMBER FUNCTION
      else if (mfid.eq.5) then
       call sigmf(x,m,n,par,y,ierr)
       
c PRODUCT OF TWO SIGMOIDAL MEMBER FUNCTION
      else if (mfid.eq.6) then
       call psigmf(x,m,n,par,y,ierr)
       
c DIFFERENCE OF TWO SIGMOIDAL MEMBER FUNCTION
      else if (mfid.eq.7) then
       call dsigmf(x,m,n,par,y,ierr)
     
c GENERALIZED BELL MEMBER FUNCTION
      else if (mfid.eq.8) then
       call gbellmf(x,m,n,par,y,ierr)

c Pi-Shaped BELL MEMBER FUNCTION
      else if (mfid.eq.9) then
       call pimf(x,m,n,par,y,ierr)

c S-Shaped BELL MEMBER FUNCTION
      else if (mfid.eq.10) then
       call smf(x,m,n,par,y,ierr)

c Z-Shaped BELL MEMBER FUNCTION
      else if (mfid.eq.11) then
       call zmf(x,m,n,par,y,ierr)

c CONSTANT
      else if (mfid.eq.12) then
       call constant(x,m,n,par,y,ierr)

c LINEAR
      else if (mfid.eq.13) then
       call linear(x,m,n,par,y,ierr)
      
c UNKNOW MEMBER FUNCTION
      else
       call erro("Unknow Member Function Type.")
       ierr=1
      end if
      
9999  return
      end

c **************************************************
c USED WITH SCICOS
c **************************************************
      subroutine smfeval(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,rpar,
     $nrpar,ipar,nipar,u,nu,y,ny)
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*),nipar,nu,ny
      integer ierr

      if (flag.eq.1) then
       call mfeval2(ipar(1),u,nu,1,rpar,y,ierr)
      endif

      return
      end 

c **************************************************
c error
c **************************************************
      subroutine flterr(nerr)
      integer nerr

      if (nerr.eq.0) then
       call erro("INTERNAL ERROR  PLEASE REPORT.")
      else if (nerr.eq.1) then
       call erro("Incorrect fls internal structure.")
      else if (nerr.eq.10) then
       call erro("Unknow fls type.")
      else if (nerr.eq.20) then
       call erro("Invalid type of type, must be string.")
      else if (nerr.eq.21) then
       call erro("Invalid type of SNorm class, must be string.")
      else if (nerr.eq.30) then
       call erro("Invalid type of SnormPar, must be sacalar.")
      else if (nerr.eq.40) then
       call erro("Unknow TNorm class.")
      else if (nerr.eq.41) then
       call erro("Invalid type of TNorm class, must be string.")
      else if (nerr.eq.50) then
       call erro("Invalid type of TNormPar, must be scalar.")
      else if (nerr.eq.60) then
       call erro("Unknow Complement class.")
      else if (nerr.eq.61) then
       call erro("Invalid type of Complement, must be string.")
      else if (nerr.eq.70) then
       call erro("Invalid type of CompPar must, be scalar.")
      else if (nerr.eq.80) then
       call erro("Unknow Implication method.")
      else if (nerr.eq.81) then
       call erro("Invalid type of ImpMethod, must be string.")
      else if (nerr.eq.90) then
       call erro("Unknow Aggregation method.")
      else if (nerr.eq.91) then
       call erro("Invalid type of AggMethod, must be string.")
      else if (nerr.eq.100) then
       call erro("Unknow Defuzzification method.")
      else if (nerr.eq.101) then
       call erro("Invalid defuzzMethod, must be string.")
      else if (nerr.eq.102) then
       call erro("Invalid Defuzzification due the fls type.")
      else if (nerr.eq.110) then
       call erro("Invalid rule type, must be a real matrix.")
      else if (nerr.eq.111) then
       call erro("Invalid size of rules.")
      else if (nerr.eq.112) then
       call erro("Invalid index in rule.")
      else if (nerr.eq.120) then
       call erro("Invalid range, must be a row vector with 2 elements.")
      else if (nerr.eq.130) then
       call erro("Invalid member function type, must be a string.")
      else if (nerr.eq.131) then
       call erro("Unknow member function type.")
      else if (nerr.eq.132) then
       call erro("Invalid member function in the IF or THEN part.")
      else if (nerr.eq.140) then
       call erro("Invalid  parameter, must be a row vector.")
      else if (nerr.eq.141) then
       call erro("Invalid parameter, the size is incorrect.")
      else if (nerr.eq.200) then
       call erro("Invalid size of input.")
      else if (nerr.eq.210) then
       call erro("The third par must have the same size as outputs.")
      else if (nerr.eq.211) then
       call erro("The third parameter must be a vector with integers.")
      else if (nerr.eq.999) then
       call erro("No more memory!")
      else if (nerr.eq.1000) then
       call erro("Invalid par, trimf need [a,b,c] with a<=b<=c.")
      else if (nerr.eq.1010) then
       call erro("Invalid par, trapmf need [a,b,c,d] with a<b<=c<d.")
      else if (nerr.eq.1020) then
       call erro("Invalid para, gaussmf need [a,b] with b<>0.")
      else if (nerr.eq.1030) then
       call erro("Invalid par, gaussmf need [a,b,c,d] with b<>0, d<>0.")
      else if (nerr.eq.1040) then
       call erro("Invalid parameters, gbellmf need [a,b,c] with b<>0.")
      else if (nerr.eq.2000) then
       call erro("Please choose a fls structure from a file.")
      else if (nerr.eq.2001) then
       call erro("The fls have  0 inputs or 0 outputs or 0 rules.")
      else if (nerr.eq.2002) then
       call erro("Incorrect number of inputs.")
      else
       call erro("UNKNOW ERROR")
      end if

9999  return
      end 
