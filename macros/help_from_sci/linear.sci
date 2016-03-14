function y=linear(x,par)
//Linear output for Takagi-Sugeno fuzzy logic systems.
//Calling Sequence
//y=linear(x,par)
//Parameters
//x:matrix of real with size [m,n].
// par:row vector with n+1 elements .
//Description
//         <literal>constant </literal> compute the linear output of a Takagi-Sugeno fls
//     due the evaluations of rules stored in <literal>x</literal>. This is a util
//     function.
//     
//      The number of parameters are equal to the number of inputs plus 1.
// 
//    The output have the form:
//     <literal>y=x*par(1:n)+ones(m,1)*par(n+1)</literal>
//See also
//member_functions
//mfeval
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

