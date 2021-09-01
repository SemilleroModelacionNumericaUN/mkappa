// Gmsh project created on Sun Nov 10 06:03:21 2019
SetFactory("OpenCASCADE");
//+
Rectangle(1) = {0, 0, 0, 0.6, 0.8, 0};
//+
Rectangle(2) = {0.05, 0.05, 0, 0.5, 0.7, 0.012};
//+
Disk(3) = {0.05+0.012, 0.05+0.012, 0, 0.012, 0.012};
//+
Disk(4) = {0.300, 0.050+0.012, 0, 0.012, 0.012};
//+
Disk(5) = {0.550-0.012, 0.050+0.012, 0, 0.012, 0.012};
//+
Disk(6) = {0.050+0.012, 0.750-0.012, 0, 0.012, 0.012};
//+
Disk(7) = {0.550-0.012, 0.750-0.012, 0, 0.012, 0.012};
//+
BooleanDifference{ Surface{1}; Delete; }{ Surface{2}; }
//+
BooleanDifference{ Surface{2}; Delete; }{ Surface{3}; Surface{4}; Surface{5}; Surface{6}; Surface{7}; }
//+
Physical Surface("CATE IDCA=01") = {1};
//+
Physical Surface("CATE IDCA=02") = {2};
//+
Physical Surface("CATE IDCA=03") = {3, 4, 5, 6, 7};
//+
Characteristic Length {5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24} = 0.02;
