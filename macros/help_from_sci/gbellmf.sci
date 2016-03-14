function y=gbellmf(x,par)
//Generalized Bell member function
//Calling Sequence
//y=gbellmf(x,par)
//Parameters
//x:matrix of real.
//par=[a,b,c]:3 element row vector of parameters.
//Description
//  <literal>gbellmf </literal> compute the generalized bell member function of
//     <literal>x</literal> with parameters <literal>[a,b,c]</literal>. This member function
//     need <literal>a, b, c.</literal>
//     
//     f(x,a,b,c)=1/(1+abs((x-c)/a)^(2*b))
//     
//Examples
//x=linspace(0,1,100)';
// y1=gbellmf(x,[0.5 10 1]);
// y2=gbellmf(x,[0.5 10 0.5]);
// y3=gbellmf(x,[0.5 10 1]);
// scf();clf();
// plot2d(x,[y1 y2 y3],leg="y1@y2@y3");
// xtitle("Generalized Bell Member Function Example","x","mu(x)");
//See also
//member_functions
//mfeval
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

//         
//       <inlinemediaobject> <imageobject> <imagedata fileref="gbellmf.gif" />
//         </imageobject> </inlinemediaobject>