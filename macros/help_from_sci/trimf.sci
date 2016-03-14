function y=trimf(x,par)
//Triangular member function
//Calling Sequence
//y=trimf(x,par)
//Parameters
//x:matrix of real.
// par=[a,b,c]:3 element row vector of parameters.
//Description
//      <literal>trimf </literal> compute the triangular member function of
//     <literal>x</literal> with parameters <literal>[a,b,c]</literal>. This member function
//     need <literal>a&lt;b&lt;c</literal>.
//
//         
//       <inlinemediaobject> <imageobject> <imagedata fileref="trimf.gif" />
//         </imageobject> </inlinemediaobject>
//     
//Examples
//x=linspace(0,1,100)';
// y1=trimf(x,[0 0.2 0.4]);
// y2=trimf(x,[0.2 0.5 0.9]);
// y3=trimf(x,[0.5 0.6 0.9 ]);
// scf();clf();
// plot2d(x,[y1 y2 y3],leg="y1@y2@y3");
// xtitle("Triangular Member Function Example","x","mu(x)");
//See also
//member_functions
//mfeval
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

