// ====================================================================
// Copyright INRIA 2008
// Allan CORNET
// This file is released into the public domain
// ====================================================================
demopath = get_absolute_file_path("sciFLT.dem.gateway.sce");

subdemolist = ["mf Gallery"             ,"flt_mfgallery.sce"; ..
                "S-Norm Gallery"             ,"flt_snorm.sce"; ..
               "T-Norm Gallery"                  ,"flt_tnorm.sce"     ; ..
               "Defuzzification Gallery"            ,"flt_defuzzm.sce" ; ..
               "Function Fuzzy Approximation 1"               ,"flt_fuzzap1.sce" ; ..
               "Function Fuzzy Approximation 2"               ,"flt_fuzzap2.sce" ; ..
               "FIS Imported"                  ,"flt_tiptest.sce"     ; ..
               "Normalized PID"            ,"flt_npid.sce" ; ..
               "Box and Jenkins Fuzzy Approx"               ,"flt_bj.sce" ; ..
               "Scicos 1"               ,"flt_scicos1.sce" ; ..
               "Scicos 2"               ,"flt_scicos2.sce" ; ..
  //             "Scicos Ball and Beam"               ,"flt_scicos3.sce" ; ..
               "C-Means Example"               ,"flt_fcmeans.sce" ; ..
               "Subtractive Clustering"               ,"flt_subclust.sce" ; ..
               "Fuzzy Logic System Optimized"               ,"flt_optfls01.sce" ; ..
               "Cubic Approximation",      "cubic_approx_demo.sce";..
               "Heart Disease Demo1",      "heart_disease_demo1.sce";..
               "Heart Disease Demo2",      "heart_disease_demo2.sce";..
               "Linear Tip Demo",      "linear_tip_demo.sce";..
               "Mamdani Tip Demo",      "mamdani_tip_demo.sce";..
               "Sugeno Tip Demo",      "sugeno_tip_demo.sce";..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
// ====================================================================
