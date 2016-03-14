function y=sigmf(x,par)
//Sigmoidal member function
//Calling Sequence
//y=sigmf(x,par)
//Parameters
//x:matrix of real.
// par=[a,b]:2 element row vector of parameters.
//Description
//         <literal>sigmf </literal> compute the sigmoidal member function of
// 	    <literal>x</literal> with parameters <literal>[a,b]</literal>.
//         
//       <inlinemediaobject> <imageobject> <imagedata fileref="sigmf.gif" />
//         </imageobject> </inlinemediaobject>
//     
//Examples
//x=linspace(0,1,100)';
// y1=sigmf(x,[12 0.3]);
// y2=sigmf(x,[12 0.5]);
// y3=sigmf(x,[-12 0.5]);
// y4=sigmf(x,[-12 0.7]);
// scf();clf();
// plot2d(x,[y1 y2 y3 y4],leg="y1@y2@y3@y4");
// xtitle("Sigmoidal Member Function Example","x","mu(x)");
//See also
//member_functions
//mfeval
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

