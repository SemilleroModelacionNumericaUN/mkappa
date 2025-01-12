% Parámetros de entrada para el programa MKAPPA 1.0

% -------------------------------------------------------------------------
% Bloque de categorías definidas en la malla
% -------------------------------------------------------------------------

% propiedades de la categoría: Concreto inconfinado con modelo de Mander
% definida en GMSH como
MAT(1,1) = 01;          % identificador de la categoría IDCA
% -------------------------------------------------------------------------
MAT(1,2) = 101;          % identificador del modelo material
                         % 101 Modelo de Mander et al.
MAT(1,3) = 30;           % f'co resistencia a la compresión inconfinada (MPa)
MAT(1,4) = 3;            % f't resistencia a la tensi�n del concreto
%Deformaciones caracteristicas del concreto(modificar si se utiliza el modelo de Mander et al.)
MAT(1,5) = 0.002;        % eco Deformaci�n al esfuerzo f'co
MAT(1,6) = 0.005;        % esp Deformaci�n al esfuerzo de aplastamiento

% -------------------------------------------------------------------------
% propiedades de la categoría: Concreto confinado con modelo activo de Mander
% definida en GMSH como:
MAT(2,1) = 02;           % identificador de la categoria IDCA
% -------------------------------------------------------------------------
MAT(2,2) = 122;          % identificador del modelo material
                         % 121 Modelo de Mander et al.
                         % 122 Modelo de Susantha et al. para CFST tipo box
                         % 123 Modelo de Susantha et al. para CFST circular
%Caracteristicas del refuerzo (modificar si se utiliza el modelo de Mander et al.)
MAT(2,3) = 2.58e-4;      % Asx area total barras transversales a lo largo de x
MAT(2,4) = 0.324;        % dc altura del nucleo
MAT(2,5) = 2.58e-4;      % Asy area total barras transversales a lo largo de y
MAT(2,6) = 0.211;        % bc base del nucleo
MAT(2,7) = 0.1;          % s Separaci�n promedio
MAT(2,8)= 420;           % fy esfuerzo transversal de fluencia [MPa]
MAT(2,9)= 0.75;          % ke Coeficiente de efectividad 
%Propiedades geom�tricas (modificar si se utiliza el modelo de Susantha et al.)
MAT(2,10)= 200;          % D Ancho de la secci�n rectangular o di�metro exterior en mm
MAT(2,11)= 10;           % t Espesor de la tuber�a en mm

% -------------------------------------------------------------------------
% propiedades de la categoría: Acero estructural
% definida en GMSH como:
MAT(3,1) = 03;            % identificador de la categoría IDCA
% -------------------------------------------------------------------------
MAT(3,2) = 202;               % identificador del modelo material
                              % 201 Modelo de King
                              % 202 Modelo de Liang
MAT(3,3) = 250;               % fy esfuerzo de fluencia [MPa]
MAT(3,4) = 200e3;             % m�dulo de elasticidad [MPa]
MAT(3,5) = 0.005;            % deformación de inicio de endurec
MAT(3,6) = 0.1;             % deformación máxima
MAT(3,7) = 450;               % esfuerzo máximo [MPa]
MAT(3,8) = MAT(3,3)/MAT(3,4); % deformaci�n Fluencia 
MAT(3,9) = 0.30;              % Relaci�n de Poisson

% -------------------------------------------------------------------------
% Bloque de parámetros de las acciones externas
% -------------------------------------------------------------------------
NYM(1) = 0.00;      % fuerza axial N

% -------------------------------------------------------------------------
% Bloque de parámetros de análisis numérico
% -------------------------------------------------------------------------
ANA(1) = 30;        % número de pasos de curvatura
ANA(2) = 0.001;     % tolerancia del error en la sumatoria de fuerza axial
ANA(3) = 0.002;     % Valor de los intervalor de curvatura

% final de datos
% -------------------------------------------------------------------------
