// Gmsh project created on Mon Mar 07 02:02:34 2022
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 0.005, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {0.1016, 0, 0, 1.0};
//+
Point(3) = {0.1016, 0.0127, 0, 1.0};
//+
Point(4) = {0.0127, 0.0127, 0, 1.0};
//+
Point(5) = {0.0127, 0.1524, 0, 1.0};
//+
Point(6) = {0, 0.1524, 0, 1.0};
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
Line(6) = {6, 1};
//+
Curve Loop(1) = {1, 2, 3, 4, 5, 6};
//+
Plane Surface(1) = {1};
//+
Physical Surface("CATE IDCA=03") = {1};//+
Characteristic Length {6, 5, 4, 1, 3, 2} = 0.05;
//+
Characteristic Length {6, 5, 4, 1, 3, 2} = 0.005;
//+
Characteristic Length {6, 5, 4, 1, 3, 2} = 0.008;
