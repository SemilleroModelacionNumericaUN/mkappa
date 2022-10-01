// Gmsh project created on Tue Apr 13 05:55:48 2021
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 0.005, Name "Parameters/lc" ];
//+
Point(1) = {0.154, 0, 0, lc};
//+
Point(2) = {0.154, 0.0206, 0, lc};
//+
Point(3) = {0.00655, 0.0206, 0, lc};
//+
Point(4) = {0.00655, 0.2977, 0, lc};
//+
Point(5) = {0.154, 0.2977, 0, lc};
//+
Point(6) = {0.154, 0.3183, 0, lc};
//+
Point(7) = {-0.154, 0.3183, 0, lc};
//+
Point(8) = {-0.154, 0.2977, 0, lc};
//+
Point(9) = {-0.00655, 0.2977, 0, lc};
//+
Point(10) = {-0.00655, 0.0206, 0, lc};
//+
Point(11) = {-0.154, 0.0206, 0, lc};
//+
Point(12) = {-0.154, 0, 0, lc};
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
Line(8) = {8, 9};
//+
Line(9) = {9, 10};
//+
Line(10) = {10, 11};
//+
Line(11) = {11, 12};
//+
Line(12) = {12, 1};
//+
Curve Loop(1) = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
//+
Plane Surface(1) = {1};
//+
Physical Surface("CATE IDCA=03") = {1};
