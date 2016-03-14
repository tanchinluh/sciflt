// Copyright (C) 2010 - H. Nahrstaedt
//


x=linspace(-1,1,100)';
for a=linspace(-1,1,20),
	for b=linspace(-1,1,40),
		par=[a b b a];
		Y1=pimf(x,par);
		
		if (par(1)>=par(2)) then
			Y2=1*(x>=((par(1)+par(2))/2));
		else
			Y2=ones(x);
			idx=find(x<=par(1));
			Y2(idx)=0;
			idx=find((par(1)<x)&(x<=(par(1)+par(2))/2));
			tmp=((x(idx)-par(1))/(par(2)-par(1)));
			Y2(idx)=2*tmp.*tmp;
			idx=find((((par(1)+par(2))/2)<x)&(x<=par(2)));
			tmp=((par(2)-x(idx))/(par(2)-par(1)));
			Y2(idx)=1-2*tmp.*tmp;		
		end

		if (par(3)>=par(4)) then
			Y3=1*(x<=((par(3)+par(4))/2));
		else
			Y3=zeros(x);
			idx=find(x<=par(3));
			Y3(idx)=1;
			idx=find((par(3)<x)&(x<=(par(3)+par(4))/2));
			Y3(idx)=1-2*((x(idx)-par(3))/(par(4)-par(3))).^2;
			idx=find((((par(3)+par(4))/2)<x)&(x<=par(4)));
			Y3(idx)=2*((par(4)-x(idx))/(par(4)-par(3))).^2;		
		end	
			
		Y2= Y2 .* Y3;

		computed = Y1;
		expected = Y2;

		assert_checkalmostequal ( computed , expected , %eps);		
	end
end