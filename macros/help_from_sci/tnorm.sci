function y=tnorm( x , class [,class_par] )
//Fuzzy Logic S-Norm (AND)
//Calling Sequence
//y=tnorm( x , class [,class_par] )
//Parameters
//x:matrix of real with size [m,n].
// y:matrix of real with size [m,1].
// class:string, t-norm class. The values can be: "dubois" for Dubois-Prade T-Norm, "yager" for Yager T-Norm, "dprod" for drastic product T-Norm, "eprod" for Einstein product T-Norm, "aprod" for algebraic product T-Norm, "min" for minimum S-Norm.
// class_par:scalar, T-Norm class parameter. "dubois" and "yager" class need this parameter.
//Description
//  <literal>tnorm </literal> compute T-Norm <literal>class</literal> of <literal>x</literal>
//     with parameter <literal>class_par</literal>. The calculation was made taking the
//     j row of <literal>x</literal> as input and put the resulting value in the j row
//     of <literal>y</literal> (row oriented calculation).
// 
//          <literal>"dubois"</literal> class need <literal>0&lt;=class_par&lt;=1</literal>.
//     <literal>"yager" </literal>class need <literal>class_par&gt;0</literal>.
//         
//       <inlinemediaobject> <imageobject> <imagedata fileref="tnorm.gif" />
//         </imageobject> </inlinemediaobject>
//     
// 
//Examples
//x=rand(5,2);
// y1=tnorm(x,"dubois",0.5);
// y2=tnorm(x,"yager",2);
// y3=tnorm(x,"dprod");
// y4=tnorm(x,"aprod");
// y5=tnorm(x,"min");
//See also
//fls_structure
//snorm
//newfls
//scicos_snorm
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

