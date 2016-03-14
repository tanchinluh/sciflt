function y=pimf(x,par)
//Pi-Shaped member function.
//Calling Sequence
//y=pimf(x,par)
//Parameters
//x:matrix of real.
// par=[a,b,c,d]:4 element row vector of parameters.
//Description
// <literal>zmf </literal> compute the z-shaped member function of <literal>x</literal>
//     with parameters <literal>[a,b,c,d]</literal>.
//         
//       <inlinemediaobject> <imageobject> <imagedata fileref="pimf.gif" />
//         </imageobject> </inlinemediaobject>
//     
//Examples
//x=linspace(0,1,100)';
// y1=pimf(x,[0.1 0.4 0.9 1.0]);
// y2=pimf(x,[0.3 0.6 0.7 0.8]);
// y3=pimf(x,[0.4 0.7 0.6 0.8]);
// scf();clf();
// plot2d(x,[y1 y2 y3],leg="y1@y2@y3");
// xtitle("Pi-Shaped Member Function Example","x","mu(x)");
//See also
//member_functions
//mfeval
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

