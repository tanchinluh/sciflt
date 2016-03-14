// Copyright (C) 2010 - H. Nahrstaedt
//

// MAX CLASS

x=rand(100,100);
Y1=snorm(x,"max");
Y2=max(x,"c");
computed = Y1;
expected = Y2;

assert_checkalmostequal ( computed , expected , %eps);
// ALGEBRAIC SUM CLASS

x=rand(100,100);
Y1=snorm(x,"asum");
Y2=x(:,1);
for j=2:size(x,2),
	Y2=Y2+x(:,j)-Y2.*x(:,j);
end
computed = Y1;
expected = Y2;

assert_checkalmostequal ( computed , expected , %eps);

// EINSTEIN SUM CLASS
x=rand(100,100);
Y1=snorm(x,"esum");
Y2=x(:,1);
for j=2:size(x,2),
	Y2=(Y2+x(:,j))./(1+Y2.*x(:,j));
end
computed = Y1;
expected = Y2;

assert_checkalmostequal ( computed , expected , %eps);

// DRASTIC SUM CLASS
x=[rand(100,100); zeros(100,50) rand(100,25) zeros(100,25)];
Y1=snorm(x,"dsum");
Y2=x(:,1);
for j=2:size(x,2),
	T=Y2;
	idx=find(Y2==0);
	T(idx)=x(idx,j);
	idx=find( (Y2~=0) & (x(:,j)~=0) );
	T(idx)=1;
	Y2=T;
end
computed = Y1;
expected = Y2;

assert_checkalmostequal ( computed , expected , %eps);

// YAGER SUM CLASS

x=rand(50,3);
for p=[1 5 10 20],
	Y1=snorm(x,"yager",p);
	Y2=x(:,1);
	for j=2:size(x,2),
		tmp=Y2.^p + x(:,j).^p;
		tmp=tmp.^(1/p);
		Y2=min([ones(Y2) tmp],"c");
	end	
	computed = Y1;
	expected = Y2;

	assert_checkalmostequal ( computed , expected , %eps*5);	
end

// DUBOIS SUM CLASS
x=rand(50,3);
for p=linspace(0.1,0.9,5),
	Y1=snorm(x,"dubois",p);
	Y2=x(:,1);
	for j=2:size(x,2),
		tmp=Y2+x(:,j)-Y2.*x(:,j)-min([Y2 x(:,j) ones(Y2)*(1-p)],"c");
		Y2=tmp ./ max([1-Y2 1-x(:,j) ones(Y2)*p],"c");
	end	
	computed = Y1;
	expected = Y2;

	assert_checkalmostequal ( computed , expected , %eps);
end