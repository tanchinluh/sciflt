function y=gaussmf(x,par)
//Gaussian member function
//Calling Sequence
//y=gaussmf(x,par)
//Parameters
//x:matrix of real.
//par=[sig,c]:2 element row vector of parameters.
//Description
// <literal>gaussmf </literal> compute the gaussian member function of
//     <literal>x</literal> with parameters <literal>[sig,c]</literal>. This member function
//     need sig and c. 
//     
//     gaussmf(x,[sig,c])=exp(-(x-c)^2/(2*sig^2))
//
//Examples
//x=linspace(0,1,100)';
// y1=gaussmf(x,[2 5]);
// y2=gaussmf(x,[3 6]);
// y3=gaussmf(x,[5 8]);
// scf();clf();
// plot2d(x,[y1 y2 y3],leg="y1@y2@y3");
// xtitle("Gaussian Member Function Example","x","mu(x)");
//See also
//member_functions
//mfeval
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

//         
//       <inlinemediaobject> <imageobject> <imagedata fileref="gaussmf.gif" />
//         </imageobject> </inlinemediaobject>
//     