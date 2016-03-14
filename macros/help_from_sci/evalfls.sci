function y=evalfls(x,fls,[npev])
//Evaluate fuzzy logic system
//Calling Sequence
//y=evalfls(x,fls,[npev])
//Parameters
//x:matrix of real. Input points.
//fls:fls structure to evaluate
//npev:scalar or vector, number of points to evaluate during defuzzification algorithm (mamdani)
//Description
//         <literal>evalfls </literal>evaluate the fuzzy logic system <literal>fls</literal>
//     in points <literal>x</literal> and return values in <literal>y</literal>. The
//     <literal>x</literal> parameters have dimension <literal>[npairs_of_inputs,
//     number_of_inputs]</literal>, the output <literal>y</literal> have dimension
//     <literal>[npairs_of_inputs, number_of_outputs]</literal>.
// 
//     
//     The <literal>npev</literal> parameter is optional in Mamdani case, the user
//     can set the number of partitions of the output variable domain to evaluate
//     the member functions for each output. This parameter can be a scalar (all
//     outputs are evaluated with the same number of partitions) or vector (each
//     element set the number of partitions for each output).The default value
//     for all outputs is 1001 points.
//Examples
// // GET A FLS
// fls=loadfls(flt_path()+"demos/fan1.fls");
// // EVALUATE
// y1=evalfls([50 50],fls)
// y2=evalfls([50 20;50 50],fls,100)
//See also
//fls_structure
//newfls
//scicos_fls
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt

