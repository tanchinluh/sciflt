function y=snorm( x , class [,class_par] )
//Fuzzy Logic S-Norm (OR)
//Calling Sequence
//y=snorm( x , class [,class_par] )
//Parameters
//x: matrix of real with size [m,n].
// y: matrix of real with size [m,1].
// class: string, s-norm class. The values can be: "dubois" for Dubois-Prade S-Norm, "yager" for Yager S-Norm, "dsum" for drastic sum S-Norm, "esum" for Einstein sum S-Norm, "asum" for algebraic sum S-Norm, "max" for maximum S-Norm.
// class_par: scalar, S-Norm class parameter. "dubois" and "yager" class need this parameter.
//Description
// <literal>snom </literal> compute S-Norm <literal>class</literal> of <literal>x</literal>
//     with parameter <literal>class_par</literal>. The calculation was made taking the
//     j row of <literal>x</literal> as input and put the resulting value in the j row
//     of <literal>y</literal> (row oriented calculation).
// 
//          <literal>"dubois"</literal> class need <literal>0&lt;=class_par&lt;=1</literal>.
//     <literal>"yager" </literal>class need <literal>class_par&gt;0</literal>.
//         
//       <inlinemediaobject> <imageobject> <imagedata fileref="snorm.gif" />
//         </imageobject> </inlinemediaobject>
//     
// 
//Examples
//x=rand(5,2);
// y1=snorm(x,"dubois",0.5);
// y2=snorm(x,"yager",2);
// y3=snorm(x,"dsum");
// y4=snorm(x,"asum");
// y5=snorm(x,"max");
//See also
//fls_structure
//tnorm
//newfls
//scicos_snorm
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

