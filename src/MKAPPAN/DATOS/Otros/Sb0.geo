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
Physical Surface("CATE IDCA=01") = {8, 11, 13};
//+
Physical Surface("CATE IDCA=02") = {9};
//+
Physical Surface("CATE IDCA=03") = {4, 5, 6, 7, 10, 12};
//+
//+
Characteristic Length {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18} = 0.01;
//+
Characteristic Length {12, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 1, 13, 14, 15, 16, 17, 18} = 0.01;
