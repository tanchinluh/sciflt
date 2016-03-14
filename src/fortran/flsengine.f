c -----------------------------------------------------------------------
c EVALUATE FLS STRUCTURE
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
c CHANGES:
c 2004-10-06 Change S-Norm and T-Norm call
c 2004-11-03 Change matrix initialization subroutine
c 2004-11-07 Change some internal subroutines to use BLAS primitives
c -----------------------------------------------------------------------

      subroutine flsengine(x,mid1,mid2,mew,mrule,mdomo,mpari,mparo,
     $nparo,npev,ninputs,noutputs,nrules,npoints,tmp1,tmp2,tmp3,tmp4,
     $maxnpev,y,ierr)
      integer ninputs,noutputs,nrules,npoints,ierr,maxnpev
      integer npev(noutputs),mid1(7),nparo
      double precision x(npoints,ninputs),mid2(3),mew(nrules)
      double precision mrule(nrules,ninputs+noutputs+1)
      double precision mdomo(noutputs,2),mpari(4,ninputs*nrules)
      double precision mparo(nparo,noutputs*nrules)
      double precision y(npoints,noutputs)
      double precision tmp1(npoints,ninputs)
      double precision tmp2(npoints,noutputs*nrules)
      double precision tmp3(npoints)
      double precision tmp4(maxnpev,3)
      double precision eprod1,eprod2,esum
      
      integer rul,inp,outp,idx1,idx2,pt1,i,ip
      double precision idx3,tmp_idx3
      double precision dd1
      logical dowarning

c -----------------------------------------------------------------------
c COMPUTE THE IF PART
c -----------------------------------------------------------------------
      do 200, rul=1, nrules
       do 100, inp=1, ninputs   
        idx1=abs(int(mrule(rul,inp)))
        idx2=isgn(int(mrule(rul,inp)))
c        idx3=hedge(mrule(rul,inp))
        idx3=dnint(1.0D2*(abs(mrule(rul,inp))-
     $dint(abs(mrule(rul,inp)))))/1.0D1
c       EVALUATE MEMBER FUNCTION
        if (idx1.gt.0) then         
         pt1=(inp-1)*nrules+rul         
         call mfeval2(idx1,x(1,inp),npoints,1,mpari(1,pt1),tmp1(1,inp),
     $ierr)
         if (ierr.gt.0) goto 9999
         if (idx3.gt.0.0D0) then
          do 90, i=1, npoints
           tmp1(i,inp)=tmp1(i,inp)**idx3
90        continue
         endif
c        DO COMPLEMENT IF IS REQUIRED        
         if (idx2.lt.0) then
          call complement2(mid1(4),tmp1(1,inp),npoints,1,mid2(3),
     $tmp1(1,inp),ierr)
          if (ierr.gt.0) goto 9999
         endif        
        else              
         dd1=dble(int(mrule(rul,ninputs+noutputs+1)))
         call uinival(tmp1(1,inp),npoints,dd1)
        endif
100    continue
c      DO THE S-NORM OR THE T-NORM
       if (int(mrule(rul,ninputs+noutputs+1)).eq.0) then
         call csnorm2(mid1(2),tmp1,npoints,ninputs,mid2(1),tmp2(1,rul),
     $ierr)
         if (ierr.gt.0) goto 9999
       else
         call ctnorm2(mid1(3),tmp1,npoints,ninputs,mid2(2),tmp2(1,rul),
     $ierr)
         if (ierr.gt.0) goto 9999
       endif
       do 110, i=1, npoints
        tmp2(i,rul)=tmp2(i,rul)*mew(rul)
110     continue
200   continue       

      do 500, outp=2, noutputs
       do 400, i=1, npoints
        do 300, rul=1, nrules
         tmp2(i,rul+(outp-1)*nrules)=tmp2(i,rul)
300     continue 
400    continue 
500   continue 

c -----------------------------------------------------------------------
c COMPUTE THE THEN PART
c -----------------------------------------------------------------------
      if (mid1(1).eq.1) then 
       goto 2000
      endif
c **************************
c    IT'S A MAMDANI
c **************************
      call uinival(tmp4,maxnpev*3,0.0D0)
      call uinival(y,npoints*noutputs,1.0D0)
      do 1300, ip=1, npoints
       do 1200, outp=1, noutputs
        call dolinspa(mdomo(outp,1),mdomo(outp,2),npev(outp),tmp4(1,3)) 
        call uinival(tmp4,npev(outp),0.0D0)
        
        do 1100, rul=1, nrules
         idx1=abs(int(mrule(rul,ninputs+outp)))
         idx2=isgn(int(mrule(rul,ninputs+outp)))
c         idx3=hedge(mrule(rul,ninputs+outp))
         idx3=dnint(1.0D2*(abs(mrule(rul,ninputs+outp))-
     $dint(abs(mrule(rul,ninputs+outp)))))/1.0D1
c        EVALUATE MEMBER FUNCTION
         if (idx1.gt.0) then
          pt1=(outp-1)*nrules+rul
          call mfeval2(idx1,tmp4(1,3),npev(outp),1,mparo(1,pt1),
     $tmp4(1,2),ierr)
          if (ierr.gt.0) goto 9999
          if (idx3.gt.0.0D0) then
           do 900, i=1, npev(outp)
            tmp4(i,2)=tmp4(i,2)**idx3
900       continue
          endif
          if (idx2.lt.0) then
           call complement2(mid1(4),tmp4(1,2),npev(outp),1,mid2(3),
     $tmp4(1,2),ierr)
           if (ierr.gt.0) goto 9999
          endif           
c         MAKE IMPLICATION
          if (mid1(5).eq.0) then
c          minimum
           do 1000, i=1, npev(outp)
            tmp4(i,2)=min(tmp4(i,2),tmp2(ip,rul))
1000       continue
          elseif (mid1(5).eq.1) then
c          product
           call dscal(npev(outp),tmp2(ip,rul),tmp4(1,2),1)
          else
c          einstein product
           do 1010, i=1, npev(outp)
            eprod1=tmp4(i,2)*tmp2(ip,rul)
            eprod2=2.0D0-(tmp4(i,2)+tmp2(ip,rul)-eprod1)
            tmp4(i,2)=eprod1/(eprod2)
1010       continue
          endif           
c         MAKE AGGREGATION
          if (mid1(6).eq.0) then
c          maximum
           do 1020, i=1, npev(outp)
            tmp4(i,1)=max(tmp4(i,1),tmp4(i,2))
1020       continue    
          elseif (mid1(6).eq.1) then
c          sum
           do 1030, i=1, npev(outp)
            tmp4(i,1)=tmp4(i,1)+tmp4(i,2)
1030       continue
          elseif (mid1(6).eq.2) then
c          einstein sum
           do 1040, i=1, npev(outp)
            esum=1.0D0+tmp4(i,1)*tmp4(i,2)
            tmp4(i,1)=(tmp4(i,1)+tmp4(i,2))/esum
1040       continue
          else
c          probor
           do 1050, i=1, npev(outp)
            tmp4(i,1)=tmp4(i,1)+tmp4(i,2)-tmp4(i,1)*tmp4(i,2)
1050       continue
          endif
         endif         
1100    continue
c       MAKE DEFUZZIFICATION
        call defuzzm2(mid1(7),tmp4(1,3),npev(outp),tmp4(1,1),y(ip,outp),
     $ierr)
        if (ierr.gt.0) goto 9999
1200   continue
1300  continue
      goto 9999
      
c **************************
c    IT'S A TAKAGI-SUGENO
c **************************
2000  dowarning=.false.
c     COMPUTE EACH THEN PART OF RULE FOR ALL OUTPUTS (NOT WEIGTHED)
      call uinival(y,npoints*noutputs,0.0D0)
      do 2200, rul=1, nrules
       do 2100, outp=1, noutputs
        idx1=abs(int(mrule(rul,ninputs+outp)))
        idx3=dnint(1.0D2*(abs(mrule(rul,ninputs+outp))-
     $dint(abs(mrule(rul,ninputs+outp)))))/1.0D1
        if (idx1.gt.0) then
         pt1=(outp-1)*nrules+rul 
         call mfeval2(idx1,x,npoints,ninputs,mparo(1,pt1),tmp3,ierr)
         if (ierr.gt.0) goto 9999
         if (idx3.gt.0.0D0) then 
          do 2005, i=1, npoints
           tmp_idx3=tmp2(i,rul+(outp-1)*nrules)**(1.0D0/idx3)
           tmp2(i,rul+(outp-1)*nrules)=tmp_idx3
2005      continue
         endif
         do 2010, i=1, npoints
          y(i,outp)=y(i,outp)+tmp2(i,rul+(outp-1)*nrules)*tmp3(i)
2010     continue
        endif
2100   continue
2200  continue
        
c DEFUZZIFICATION METHOD IS WAVER ? 
c      goto 9999
      if (mid1(7).eq.7) goto 9999      
      do 2280, outp=1, noutputs
       call uinival(tmp3,npoints,0.0D0)
       do 2260, rul=1, nrules
        if (int(mrule(rul,ninputs+outp)).ne.0) then
         call daxpy(npoints,mew(rul),
     $tmp2(1,rul+(outp-1)*nrules),1,tmp3,1)
        endif
2260   continue        
       do 2270, i=1, npoints
        y(i,outp)=y(i,outp)/tmp3(i)
2270   continue        
2280  continue       
      
9999  return
      end

      
