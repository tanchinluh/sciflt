// Copyright (C) 2010 - H. Nahrstaedt
//

//  ONE CLASS
x=linspace(0,1,1000)';

computed = complement(x,"one");
expected = 1-x;

assert_checkalmostequal ( computed , expected , %eps );

// YAGER CLASS
x=linspace(0,1,1000)';
for h=[1 5 10 100 1000 100000],
	Y1=complement(x,"yager",h);
	Y2=(1-x.^h).^(1/h);
        computed = Y1;
        expected = Y2;

        assert_checkalmostequal ( computed , expected , %eps*5 );
end;


// SUGENO CLASS


x=linspace(0,1,1000)';
for h=[1 5 10 100 1000 100000],
	Y1=complement(x,"sugeno",h);
	Y2=(1-x)./(1+h*x);
        computed = Y1;
        expected = Y2;

        assert_checkalmostequal ( computed , expected , %eps );
end;

