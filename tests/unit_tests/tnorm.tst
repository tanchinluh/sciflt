// Copyright (C) 2010 - H. Nahrstaedt
//

// MIN CLASS
x=rand(100,2);
Y1=tnorm(x,"min");
Y2=min(x,"c");
computed = Y1;
expected = Y2;

assert_checkalmostequal ( computed , expected ,[], %eps);


// ALGEBRAIC PRODUCT CLASS
x=rand(100,2);
Y1=tnorm(x,"aprod");
Y2=prod(x,"c");

// EINSTEIN PRODUCT CLASS
x=rand(100,2);
Y1=tnorm(x,"eprod");
Y2=x(:,1);
for j=2:size(x,2),
	tmp=Y2 .* x(:,j);
	Y2= tmp ./ ( 2 - ( Y2 + x(:,j) - Y2 .* x(:,j) ) );
end
computed = Y1;
expected = Y2;

assert_checkalmostequal ( computed , expected ,[], %eps);


// DRASTIC PRODUCT CLASS
x=[rand(100,3); zeros(100,1) rand(100,1) zeros(100,1)];
Y1=tnorm(x,"dprod");
Y2=x(:,1);
for j=2:size(x,2),
	T=Y2;
	idx=find(Y2==1);
	T(idx)=x(idx,j);
	idx=find( (Y2~=1) & (x(:,j)~=1) );
	T(idx)=0;
	Y2=T;
end
computed = Y1;
expected = Y2;

assert_checkalmostequal ( computed , expected ,[], %eps);

// YAGER CLASS
x=rand(100,2);
for p=[1 5 10 %inf],
	Y1=tnorm(x,"yager",p);
	Y2=x(:,1);
	for j=2:size(x,2),
		tmp=(1-Y2).^p + (1-x(:,j)).^p;
		tmp=tmp.^(1/p);
		tmp2=ones(Y2);
		idx=find(tmp<1);
		tmp2(idx)=tmp(idx);
		Y2=1-tmp2;
		
	end	
	computed = Y1;
	expected = Y2;

	assert_checkalmostequal ( computed , expected , [],%eps*200);
end

// DUBOIS SUM CLASS
x=rand(100,2);
for p=linspace(0,1,10),
	Y1=tnorm(x,"dubois",p);
	Y2=x(:,1);
	for j=2:size(x,2),
		tmp=Y2 .* x(:,j);
		Y2=tmp ./ max([Y2 x(:,j) ones(Y2)*p],"c");
	end	
	computed = Y1;
	expected = Y2;

	assert_checkalmostequal ( computed , expected , [],%eps*200);
end
