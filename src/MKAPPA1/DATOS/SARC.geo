// Gmsh project created on Tue Jan 19 11:23:03 2021
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {0.1, 0, 0, 1.0};
//+
Point(3) = {0.1, 0.4, 0, 1.0};
//+
Point(4) = {0, 0.4, 0, 1.0};
//+
Point(5) = {0, 0.01, 0, 1.0};
//+
Point(6) = {0.09, 0.01, 0, 1.0};
//+
Point(7) = {0.09, 0.39, 0, 1.0};
//+
Point(8) = {0, 0.39, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 8};
//+
Line(5) = {8, 5};
//+
Line(6) = {5, 1};
//+
Line(7) = {5, 6};
//+
Line(8) = {6, 7};
//+
Line(9) = {7, 8};
//+
Curve Loop(1) = {4, -9, -8, -7, 6, 1, 2, 3};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {5, 7, 8, 9};
//+
Curve Loop(3) = {8, 9, 5, 7};
//+
Plane Surface(2) = {3};
//+
Physical Surface("CATE IDCA=03") = {1};
//+
Physical Surface("CATE IDCA=02") = {2};
//+
Characteristic Length {1, 8, 7, 6, 5, 4, 3, 2} = 0.01;
