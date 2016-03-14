c -----------------------------------------------------------------------
c UTILITY
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
c 2004-11-03 Change matrix initialization -> Unrolled
c            Fix isgn error
c 2004-11-04 Unroll getmr, optimize getmw, add dicopy, add idcopy,
c            Unroll dolinspa
c 2006-08-28 Add repvec function
c 2006-09-03 Add repvecc function
c 2006-09-06 Change dcopy by fltcd
c -----------------------------------------------------------------------

c --------------------------------------------------
c Repeat a column vector y(:,1:n)=x
c --------------------------------------------------
       subroutine repvecc(y,x,m,n)
       integer m,n
       double precision x(m),y(m,n)
       integer j
       do 10, j=1, n
        call dcopy(m,x,1,y(1,j),1)
c        call fltcd(y(1,j),x,m)
10     continue
       end

c --------------------------------------------------
c Repeat a row vector y(1:m,:)=x
c --------------------------------------------------
       subroutine repvec(y,x,m,n)
       integer m,n
       double precision y(m,n),x(n)
       integer i,j
       do 10, j=1 , n
        call uinival(y(1,j),m,x(j))
10     continue
       end

c --------------------------------------------------
c Unrolled matrix initialization
c --------------------------------------------------
       subroutine uinival(x,sz,va)
       integer sz
       double precision x(*),va
       integer m,i
       m=mod(sz,5)
       if (m.eq.0) goto 20
       do 10, i=1, m
        x(i)=va
10     continue
       if (sz.lt.5) return
20     m=m+1
       do 30, i=m, sz, 5
        x(i)=va
        x(i+1)=va
        x(i+2)=va
        x(i+3)=va
        x(i+4)=va
30     continue
       return
       end
     
C --------------------------------------------------       
C INTEGER SIGN
C --------------------------------------------------
      function isgn(n)
      integer isgn,n
      if (n.gt.0) then
       isgn=1
      elseif (n.eq.0) then
       isgn=0
      else
       isgn=-1
      endif
      return
      end

C --------------------------------------------------       
C INTEGER SIGN
C --------------------------------------------------
      function hedge(n)
      double precision hedge,n
      hedge=dnint(1.0D2*(abs(n)-dint(abs(n))))/1.0D1
      return
      end

      
C --------------------------------------------------       
C GET MATRIX OF WEIGTHS
C --------------------------------------------------
       subroutine getmw(rule,nrules,ninputs,noutputs,mwe)
       integer nrules,ninputs,noutputs
       double precision rule(nrules,*),mwe(*)

       call dcopy(nrules,rule(1,ninputs+noutputs+2),1,mwe,1)       

       return
       end

C --------------------------------------------------
C Make x=int(y(1:sz))
C --------------------------------------------------
       subroutine dicopy(x,y,sz)
       double precision x(*)
       integer y(*),sz       
       integer m,i

       m=mod(sz,5)
       if (m.eq.0) goto 20
       do 10, i=1, m
        y(i)=int(x(i))
10     continue
       if (sz.lt.5) return
20     m=m+1
       do 30, i=m, sz, 5
        y(i)=int(x(i))
        y(i+1)=int(x(i+1))
        y(i+2)=int(x(i+2))
        y(i+3)=int(x(i+3))
        y(i+4)=int(x(i+4))
30     continue
       return
       end

C --------------------------------------------------
C Make x=dble(y(1:sz))
C --------------------------------------------------
       subroutine idcopy(x,y,sz)
       double precision y(*)
       integer x(*),sz       
       integer m,i

       m=mod(sz,5)
       if (m.eq.0) goto 20
       do 10, i=1, m
        y(i)=dble(x(i))
10     continue
       if (sz.lt.5) return
20     m=m+1
       do 30, i=m, sz, 5
        y(i)=dble(x(i))
        y(i+1)=dble(x(i+1))
        y(i+2)=dble(x(i+2))
        y(i+3)=dble(x(i+3))
        y(i+4)=dble(x(i+4))
30     continue
       return
       end
       
C --------------------------------------------------
C Make x=(y(1:sz))
C --------------------------------------------------
       subroutine ddcopy(x,y,sz)
       double precision x(*)
       double precision y(*)
       integer sz       
       integer m,i

       m=mod(sz,5)
       if (m.eq.0) goto 20
       do 10, i=1, m
        y(i)=(x(i))
10     continue
       if (sz.lt.5) return
20     m=m+1
       do 30, i=m, sz, 5
        y(i)=(x(i))
        y(i+1)=(x(i+1))
        y(i+2)=(x(i+2))
        y(i+3)=(x(i+3))
        y(i+4)=(x(i+4))
30     continue
       return
       end


C --------------------------------------------------       
C CREATE A LINEAR SPACE
C --------------------------------------------------
       subroutine dolinspa(minDom,maxDom,npart,x)
       integer npart
       double precision x(*),minDom,MaxDom

       integer m,i
       double precision dt
       dt=(maxDom-minDom)/(npart-1)
       m=mod(npart,5)
       if (m.eq.0) goto 20
       do 10, i=1, m
        x(i)=minDom+dt*(i-1)
10     continue
       if (npart.lt.5) return
20     m=m+1
       do 30, i=m, npart, 5
        x(i)=minDom+dt*(i-1)
        x(i+1)=minDom+dt*(i)
        x(i+2)=minDom+dt*(i+1)
        x(i+3)=minDom+dt*(i+2)
        x(i+4)=minDom+dt*(i+3)
30     continue
       return
       end

