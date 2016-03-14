function y=defuzzm( x, mf_value, method)
//Returns a defuzzified value,
//Calling Sequence
//y=defuzzm( x, mf_value, method)
//Parameters
//x:column vector.
// mf_value:member function evaluated at x.
// method:string. Defuzzification method. "centroide" for centroide of area, "bisector" for bisection of area, "mom" for mean of maximum, "lom" for largest of maximum and "som" for smallest of maximum.
//Description
// <literal>defuzzm </literal> returns a defuzzified value <literal>y</literal>, of a
//     member function value <literal>mf_value</literal> at associated variable value
//     <literal>x</literal>, using <literal>method</literal> defuzzification strategies.
//Examples
//x=linspace(0,1,100)';
// mf_value=max(0.6*trimf(x,[0 0.2 0.4]),0.4*trimf(x,[0.3 0.6 0.9]));
// y_centroide=defuzzm(x,mf_value,"centroide");
// y_bisector=defuzzm(x,mf_value,"bisector");
//See also
//member_functions
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

