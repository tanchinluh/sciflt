// Copyright (C) 2010 - H. Nahrstaedt
//




x=linspace(0,1,100)';
for a=[0 0.2 0.4 0.6 0.8 1],
	for b=[0.1 0.2 0.3 0.4 .5 0.6 0.7 0.8 0.9 1],
		for c=[0 0.1 0.2 0.3 0.4],
			par=[a-b-c a-c a+c a+b+c];
			Y1=trapmf(x,par);
			Y2=Y1;
			idx=find( (x>par(1)) & (x<par(2)) );
			Y2(idx)=(x(idx)-par(1))/(par(2)-par(1));
			idx=find( (x>=par(2)) & (x<=par(3)) );
			Y2(idx)=1;
			idx=find( (x>par(3)) & (x<par(4)) );
			Y2(idx)=(par(4)-x(idx))/(par(4)-par(3));
			computed = Y1;
			expected = Y2;

			assert_checkalmostequal ( computed , expected , %eps);	
		end
	end
end