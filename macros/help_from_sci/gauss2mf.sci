function y=gauss2mf(x,par)
//Extended Gaussian member function
//Calling Sequence
//y=gauss2mf(x,par)
//Parameters
//x:matrix of real.
//par=[sig1,c1,sig2,c2]:4 element row vector of parameters.
//Description
//         <literal>gauss2mf </literal> compute the extended gaussian member function of
//     <literal>x</literal> with parameters <literal>[sig1,c1,sig2,c2]</literal>. This member
//     function need <literal>sig1, c1, sig2,c2</literal>.
//     
//     f(x,sig,c)=exp(-(x-c)^2/(2*sig^2))
//     
//     gauss2mf is the compination of both curves.
//Examples
//x=linspace(0,1,100)';
// y1 = gauss2mf(x, [2 4 1 8]);
//         y2 = gauss2mf(x, [2 5 1 7]);
//         y3 = gauss2mf(x, [2 6 1 6]);
//         y4 = gauss2mf(x, [2 7 1 5]);
//         y5 = gauss2mf(x, [2 8 1 4]);
// scf();clf();
// plot2d(x, [y1 y2 y3 y4 y5]);
// xtitle("Extended Gaussian Member Function Example","x","mu(x)");
//See also
//member_functions
//mfeval
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

