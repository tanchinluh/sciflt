// Copyright (C) 2010 - H. Nahrstaedt
//





x=linspace(0,1,100)';
for a=[0 0.2 0.4 0.6 0.8 1],
	for b=[0.1 0.2 0.3 0.4 .5 0.6 0.7 0.8 0.9 1],
		par=[-b+a,a,b+a];
		Y1=trimf(x,par);
		Y2=zeros(x);
		idx=find( (x>par(1)) & (x<par(2)) );
		Y2(idx)=(x(idx)-par(1))/(par(2)-par(1));
		idx=find( x==par(2) );
		Y2(idx)=1;
		idx=find( (x>par(2)) & (x<par(3)) );
		Y2(idx)=(par(3)-x(idx))/(par(3)-par(2));		
		computed = Y1;
		expected = Y2;

		assert_checkalmostequal ( computed , expected , %eps);		
	end
end
