function y=trapmf(x,par)
//Trapezoidal member function.
//Calling Sequence
//y=trapmf(x,par)
//Parameters
//x:matrix of real.
// par=[a,b,c,d]:4 element row vector of parameters.
//Description
//         <literal>trapmf </literal> compute the trapezoidal member function of
//     <literal>x</literal> with parameters <literal>[a,b,c,d]</literal>. This member
//     function need <literal>a&lt;b&lt;=c&lt;d</literal>.
//         
//       <inlinemediaobject> <imageobject> <imagedata fileref="trapmf.gif" />
//         </imageobject> </inlinemediaobject>
//     
// 
//Examples
//x=linspace(0,1,100)';
// y1=trapmf(x,[0 0.2 0.4 0.6]);
// y2=trapmf(x,[0.2 0.5 0.6 0.9]);
// y3=trapmf(x,[0.5 0.6 0.8 0.9 ]);
// scf();clf(); plot2d(x,[y1 y2 y3],leg="y1@y2@y3");
// xtitle("Trapezoidal Member Function Example","x","mu(x)");
//See also
//member_functions
//mfeval
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

