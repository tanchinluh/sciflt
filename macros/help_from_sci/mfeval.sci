function y=mfeval(x,mf_type,mf_par,hedge, not_flag)
//Evaluate Member Function.
//Calling Sequence
//y=mfeval(x,mf_type,mf_par)
//y=mfeval(x,mf_type,mf_par,hedge, not_flag)
//Parameters
//x:matrix of real.
// mf_type:string. Name of the member function.
// mf_par:row vector. Member function parameters.
//Description
//<literal>mfeval </literal> compute the member function <literal>mf_type</literal> of
//     <literal>x</literal> with parameters <literal>mf_par</literal>.
//   
//Examples
//x=linspace(0,1,100)';
// y1=mfeval(x,"zmf",[0.2 0.3]);
// y2=mfeval(x,"trimf",[0.2 0.6 0.9]);
// y3=mfeval(x,"trapmf",[0.2 0.3 0.5 0.8]);
// scf();clf();
// plot2d(x,[y1 y2 y3],leg="y1@y2@y3");
// xtitle("Member Function Evaluation","x","mu(x)");
//See also
//member_functions
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

