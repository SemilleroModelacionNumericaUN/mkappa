// Gmsh project created on Fri Nov  8 15:44:25 2019
SetFactory("OpenCASCADE");
//+
Rectangle(1) = {-0.5, -0.5, 0, 1, 2, 0};
//+
Disk(2) = {-0.2, -0, 0, 0.1, 0.1};
//+
Disk(3) = {-0.2, 1, 0, 0.1, 0.1};
//+
BooleanDifference{ Surface{1}; Delete; }{ Surface{3}; Surface{2}; }
//+
Physical Surface("CATE IDCA=05") = {1};
//+
Physical Surface("CATE IDCA=10") = {2, 3};
