function y=smf(x,par)
//S-Shaped member function.
//Calling Sequence
//y=smf(x,par)
//Parameters
//x:matrix of real.
//par=[a,b]:2 element row vector of parameters.
//Description
//  <literal>smf </literal> compute the s-shaped member function of <literal>x</literal>
//     with parameters <literal>[a,b]</literal>.
//              
//       <inlinemediaobject> <imageobject> <imagedata fileref="smf.gif" />
//         </imageobject> </inlinemediaobject>
//     
//Examples
//x=linspace(0,1,100)';
// y1=smf(x,[0.2 0.3]);
// y2=smf(x,[0.2 0.6]);
// y3=smf(x,[0.2 0.8]);
// y4=smf(x,[0.8 0.4]);
// scf();clf();
// plot2d(x,[y1 y2 y3 y4],leg="y1@y2@y3");
// xtitle("S-Shaped Member Function Example","x","mu(x)");
//See also
//member_functions
//mfeval
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

