function y=complement( x , class [,class_par] )
//Fuzzy Logic Complemen
//Calling Sequence
//y=complement( x , class [,class_par] )
//Parameters
//x , y:matrix of real.
// class:string, complement class. The values can be: "one" for classic complement, "sugeno" for sugeno's complement class or "yager" for yager's complement class.
// class_par:scalar, complement class parameter. "sugeno" and "yager" class need this parameter.
//Description
//     <literal>complement </literal> compute complement <literal>class</literal> of
//     <literal>x</literal> with parameters <literal>class_par</literal>.
// 
// 
//          <literal>"yager"</literal> class need <literal>class_par&gt;0</literal>.
//     <literal>"sugeno" </literal>class need <literal>class_par&gt;-1</literal>.
//
//       <inlinemediaobject> <imageobject> <imagedata fileref="complement.gif" />
//         </imageobject> </inlinemediaobject>
//   
//Examples
//x=linspace(0,1,100)';
// y1=complement(x,"one");
// y2=complement(x,"sugeno",0.5);
// y3=complement(x,"yager",2);
// scf();clf();
// plot2d(x,[y1 y2 y3],leg="y1@y2@y3");
// xtitle("Complement Class Example","x","mu(x)");
//See also
// scicos_complement
// snorm
// tnorm
// fls_structure
// newfls
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

