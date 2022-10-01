// Gmsh project created on Fri Jan 10 01:00:41 2020
SetFactory("OpenCASCADE");
//+
Rectangle(1) = {-0.150, 0, 0, 0.300, 0.400, 0};
//+
Rectangle(2) = {-0.100-0.013, 0.050-0.011, 0, 0.200+0.026, 0.300+0.013+0.011, 0};
//+
Disk(3) = {0, 0.050, 0, 0.011, 0.011};
//+
Disk(4) = {0.100+0.002, 0.050, 0, 0.011, 0.011};
//+
Disk(5) = {0.100+0.002, 0.200, 0, 0.0095, 0.0095};
//+
Disk(6) = {0.100+0.002, 0.300, 0, 0.011, 0.011};
//+
Disk(7) = {0.100, 0.350, 0, 0.013, 0.013};
//+
Disk(8) = {0.0, 0.350, 0, 0.013, 0.013};
//+
Disk(9) = {-0.100, 0.350, 0, 0.013, 0.013};
//+
Disk(10) = {-0.100-0.002, 0.300, 0, 0.011, 0.011};
//+
Disk(11) = {-0.100-0.002, 0.200, 0, 0.0095, 0.0095};
//+
Disk(12) = {-0.100-0.002, 0.050, 0, 0.011, 0.011};
//+
Coherence;
//+
Physical Surface("CATE IDCA=01") = {13};
//+
Physical Surface("CATE IDCA=02") = {14, 15, 16, 17, 18};
//+
Physical Surface("CATE IDCA=03") = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
//+
//+
Characteristic Length {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20} = 0.01;
//+
Transfinite Curve {30} = 21 Using Progression 1;
//+
Transfinite Curve {29} = 7 Using Progression 1;
//+
Transfinite Curve {27} = 21 Using Progression 1;
//+
Transfinite Curve {37} = 7 Using Progression 1;
//+
Transfinite Curve {31} = 21 Using Progression 1;
//+
Transfinite Curve {36} = 24 Using Progression 1;
//+
Transfinite Curve {26} = 21 Using Progression 1;
//+
Transfinite Curve {39} = 7 Using Progression 1;
//+
Transfinite Curve {34} = 21 Using Progression 1;
//+
Transfinite Curve {35} = 7 Using Progression 1;
//+
Transfinite Curve {24} = 14 Using Progression 1;
//+
Transfinite Curve {25} = 7 Using Progression 1;
//+
Transfinite Curve {38} = 7 Using Progression 1;
//+
Transfinite Curve {32} = 14 Using Progression 1;
//+
Transfinite Curve {33} = 14 Using Progression 1;
//+
Transfinite Curve {28} = 21 Using Progression 1;
//+
Transfinite Curve {21} = 7 Using Progression 1;
//+
Transfinite Curve {22} = 7 Using Progression 1;
//+
Transfinite Curve {23} = 14 Using Progression 1;

Field[1] = Box;
//+
Field[1].Thickness = 1;
//+
Field[1].VIn = 0.01;
//+
Field[1].VOut = 0.01;
//+
Field[1].XMax = 0.08;
//+
Field[1].XMin = -0.08;
//+
Field[1].YMax = 0.33;
//+
Field[1].YMin = 0.07;
//+
Background Field = 1;
