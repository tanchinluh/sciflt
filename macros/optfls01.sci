function [THETA,PSI,Ck,fls]=optfls01(X,Y,mj,epsilon,maxiter,verbose)
//Create an optimized FLS system
//Calling Sequence
//[THETA,PSI,Ck,fls]=optfls01(X,Y,mj [,epsilon, [maxiter, [verbose]]])
//Parameters
//X:matrix of real with size [m,n].
// Y:matrix of real with size [m,1].
// mj:Number of partitions for each input components.
// epsilon:Minimum objetive function change
// maxiter:Maximum of iterations.
// verbose:Show information on screen (boolean).
//Description
//FLS Optimization
//Examples
//x = (0:0.1:10)';
// y = sin(2*x)./exp(x/5);
// [THETA,PSI,Ck,fls]=optfls01(x,y,5,%eps,20);
// scf();clf();
// plot(x,y);
// plot(x,evalfls(x,fls),'g');
// legend('Training Data','optfls01 Output');
//See also
//fls_structure
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// FLS OPTIMIZATION -- FIRST STEPS
// ----------------------------------------------------------------------
// This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
// Copyright (C) @YEARS@ Jaime Urzua Grez
// mailto:jaime_urzua@yahoo.com
// 
// 2011 Holger Nahrstaedt
// ----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// ----------------------------------------------------------------------

// Check arguments
rhs=argn(2);

if (rhs<3) then
	error("optfls01 need at least 3 paramaters...");
end

if (size(X,1)~=size(Y,1))|(size(Y,2)~=1) then
	error("Incorrect X or Y size...");
end

if (length(mj)==1) then
	mj=ones(1,size(X,2))*mj;
elseif size(mj,2)~=size(X,2) then
	error("mj parameter incorrect size");
end

if (find(mj<2)~=[]) then
	error("Incorrect number of partitions mj");
end

if (rhs==3) then
	epsilon=sqrt(%eps);
	maxiter=10;
	verbose=%f;
end

if (rhs==4) then
	maxiter=10;
	verbose=%f;
end

if (rhs==5) then
	verbose=%f;
end


// Distance calculation
d=[max(X,'r')-min(X,'r')] ./ (mj-1); 
Nrul=prod(mj);

// Esta rutina regresa los valores en forma matricial de los centros y de
// las desviaciones 
function [MC,MS]=mcms(th2,mj2)
	ncomp=length(mj2);
	id=mj2(ncomp)-1;
	MC=th2(($-id):$,1);
	MS=th2(($-id):$,2);
	id2=id+1;
	th2=th2(1:$-id2,:);
	for p=(ncomp-1):-1:1,
		id=mj2(p)-1;
		non1=ones(size(MC,1),1);
		non2=ones(id+1,1);
		lv=th2(($-id):$,:);
		MC=[lv(:,1).*.non1 non2.*.MC];
		MS=[lv(:,2).*.non1 non2.*.MS];
		th2=th2(1:$-id2,:);
	end
endfunction

// Esta rutina calcula una gran matriz con la evaluacion de las reglas
// hay que tener cuidado cuando no se disparan una regla por completo!
function RR=evvrul(X,MC,MS)
	nmc=size(MC,1);
	RR=[];
	for p=1:size(X,1),
		q=prod(exp(-((repvec(nmc,X(p,:))-MC)./MS).^2),'c');
		RR=[RR q/sum(q)];
	end	
endfunction

// ESTA ES LA FUNCION OBJETIVO QUE SE DESEA OPTIMIZAR
function [ck]=ee1(TH,X,Y,PSI2,mj)
//function [ck,g,ind]=ee1(TH,ind,X,Y,PSI2,mj)
	TH2=matrix(TH,size(TH,1)/2,-1);
	[MC,MS]=mcms(TH2,mj);
	RR=evvrul(X,MC,MS)';
	PSI=matrix(PSI2,length(mj)+1,-1)';
	EE1=[X ones(size(X,1),1)]*PSI';
	Ya=(RR .* EE1); // Salida calculada...
	ck=sum((Y-sum(Ya,'c')).^2);
//	Add the gradiend
//	g=ones(TH); // DUMMY!
endfunction

// PASO 1
// Inicializa la matriz de coeficientes THETA buscando
// distribuir uniformemente las funciones de pertenencia
TH2=[]; 
for q=1:length(mj),
	cc=(0:(mj(q)-1))'*d(q)+min(X(:,q));
	ss=ones(cc)*d(q)/(2*sqrt(log(2)));
	TH2=[TH2; cc ss];
end

// Inicializa matrix Ck para obtener datos
Ck=[0;%inf];
niter=1;

if verbose
	write(%io(2),'   Starting Iterations...');
end

ncomp=size(X,2);
while (niter<=maxiter)&(abs(Ck($)-Ck($-1))>epsilon)
	// Find PSI using last squares
	tic();
	Q=[];
	npt=size(X,1);
	[MC,MS]=mcms(TH2,mj);
	RR=evvrul(X,MC,MS)';
	for i=1:Nrul,
		Q=[Q repvecc(ncomp,RR(:,i)) .* X RR(:,i)];
	end
	PSI2=lsq(Q,Y);

	// Find THETA using optimization alg.
	//[Ckk,TH]=optim(list(ee1,X,Y,PSI2,mj),TH2(:));
	if verbose then
		[Ckk,TH]=optim(list(NDcost,ee1,X,Y,PSI2,mj),TH2(:),imp=3);
		//[Ckk,TH]=optim(list(ee1,X,Y,PSI2,mj),TH2(:),imp=3);
	else
		[Ckk,TH]=optim(list(NDcost,ee1,X,Y,PSI2,mj),TH2(:));
		//[Ckk,TH]=optim(list(ee1,X,Y,PSI2,mj),TH2(:));	
	end

	// Resize results for internal use
	TH2=matrix(TH,size(TH,1)/2,-1);
	Ck=[Ck;Ckk];

	t=toc();	
	if verbose then
		write(%io(2),'  Iteration #'+string(niter)+' calculation time ='+string(t)+' objetive function = '+string(Ck($)));
	end
	niter=niter+1;
end

if verbose then
	if niter>maxiter then
		write(%io(2),'  The maximum of iterations was reached');
	end

	if (abs(Ck($)-Ck($-1))<=epsilon) then
		write(%io(2),'  The minimum objetive change was reached');
	end
end

// Update Outputs
THETA=TH2;
PSI=matrix(PSI2,length(mj)+1,-1)';
Ck=Ck(3:$);

// Due this process is slow only return on demmand
if (argn(1)==4) then
	if verbose
		write(%io(2),'  CREATING FLS STRUCTURE...');
	end
	fls=newfls('ts','opfls');
	fls.comment='Created by optfls01';
	fls=addvar(fls,'output','y',[min(Y) max(Y)]);
	for p=1:Nrul,
		fls=addmf(fls,'output',1,'y_'+string(p),'linear',PSI(p,:));
	end
	h=1;
	for p=1:length(mj),
		fls=addvar(fls,'input','X_'+string(p),[min(X(:,p),'r') max(X(:,p),'r')]);
		for q=1:mj(p),
			fls=addmf(fls,'input',p,'u_('+string(p)+','+string(q)+')','gaussmf',THETA(h,:));
			h=h+1;
		end
	end
	ru=[1:mj($)]';
	for p=(length(mj)-1):-1:1,
		non1=ones(size(ru,1),1);
		non2=ones(mj(p),1);
		ru=[((1:mj(p))').*.non1 non2.*.ru];
	end
	fls.rule=[ru (1:size(ru,1))' ones(size(ru,1),2)];
end

endfunction


