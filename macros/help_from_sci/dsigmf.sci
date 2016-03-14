function y=dsigmf(x,par)
//Absolute Difference of Two Sigmoidal member function
//Calling Sequence
//y=dsigmf(x,par)
//Parameters
//x:matrix of real.
//par=[a,b,c,d]:4 element row vector of parameters.
//Description
//<literal>dsigmf </literal> compute the absolute difference of two sigmoidal
//     member function of <literal>x</literal> with parameters
//     <literal>[a,b,c,d]</literal>.
//              
//       <inlinemediaobject> <imageobject> <imagedata fileref="dsigmf.gif" />
//         </imageobject> </inlinemediaobject>
//     
//Examples
//x=linspace(0,1,100)';
// y1=dsigmf(x,[15 0.1 15 0.3]);
// y2=dsigmf(x,[15 0.5 15 0.7]);
// y3=dsigmf(x,[15 0.5 -15 0.7]);
// scf();clf();
// plot2d(x,[y1 y2 y3],leg="y1@y2@y3");
// xtitle("Absolute Difference of Two Sigmoidal Member Function Example","x","mu(x)");
//See also
//
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

