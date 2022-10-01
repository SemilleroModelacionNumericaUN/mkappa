// Gmsh project created on Fri Jan 10 01:00:41 2020
SetFactory("OpenCASCADE");
//+
Rectangle(1) = {0, 0, 0, 0.150, 0.400, 0};
//+
Rectangle(2) = {0, 0.050-0.011, 0, 0.100+0.013, 0.300+0.013+0.011, 0};
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
Coherence;
//+
//+
Recursive Delete {
  Surface{15}; Surface{14}; 
}
//+
Physical Surface("CATE IDCA=01") = {8};
//+
Physical Surface("CATE IDCA=02") = {9, 11, 13};
//+
Physical Surface("CATE IDCA=03") = {4, 5, 6, 7, 10, 12};
//+
//+
Characteristic Length {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18} = 0.01;

//+
Transfinite Curve {25} = 10 Using Progression 1;
//+
Transfinite Curve {18} = 7 Using Progression 1;
//+
Transfinite Curve {17} = 7 Using Progression 1;
//+
Transfinite Curve {26} = 7 Using Progression 1;
//+
Transfinite Curve {19} = 21 Using Progression 1;
//+
Transfinite Curve {22} = 24 Using Progression 1;
//+
Transfinite Curve {21} = 21 Using Progression 1;
//+
Transfinite Curve {20} = 19 Using Progression 1;
//+
Transfinite Curve {24} = 7 Using Progression 1;
//+
Transfinite Curve {15} = 7 Using Progression 1;
//+
Transfinite Curve {14} = 7 Using Progression 1;
//+
Transfinite Curve {23} = 8 Using Progression 1;
//+
Show "*";
//+
Show "*";
//+
Show "*";
//+
Show "*";
//+
Show "*";
