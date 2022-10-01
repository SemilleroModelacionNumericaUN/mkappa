// Gmsh project created on Sat Jan 11 19:59:08 2020
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 0.01};
//+
Point(2) = {0.09, 0, 0, 0.01};
//+
Point(3) = {0.09, 0.0135, 0, 0.01};
//+
Point(4) = {0.0043, 0.0135, 0, 0.01};
//+
Point(5) = {0.0043, 0.3865, 0, 0.01};
//+
Point(6) = {0.09/2, 0.3865, 0, 0.01};
//+
Point(7) = {0.09/2, 0.4, 0, 0.01};
//+
Point(8) = {0, 0.4, 0, 0.01};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 5};
//+
Line(5) = {5, 6};
//+
Line(6) = {6, 7};
//+
Line(7) = {7, 8};
//+
Line(8) = {8, 1};
//+
Curve Loop(1) = {1, 2, 3, 4, 5, 6, 7, 8};
//+
Plane Surface(1) = {1};
//+
Physical Surface("CATE IDCA=03") = {1};
//+
Characteristic Length {7, 6, 8, 5, 3, 2, 4, 1} = 0.01;
//+
Characteristic Length {1, 2, 3, 4, 5, 6, 7, 8} = 0.01;
//+
Characteristic Length {1, 2, 3, 4, 5, 6, 7, 8} = 0.002;
//+
Characteristic Length {1, 2, 3, 4, 5, 6, 7, 8} = 0.01;
