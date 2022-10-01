% Parámetros de entrada para el programa MKAPPA 1.0

% ------------------------------------------
% Bloque de categorías definidas en la malla
% ------------------------------------------

% propiedades de la categoría: Concreto inconfinado con modelo de Mander
% definida en GMSH como
MAT(1,1) = 01;          % identificador de la categoría IDCA
% ------------------------------------------
MAT(1,2) = 101;               %  identificador del modelo material      
MAT(1,3) = 28;         % f'co resistencia a la compresión inconfinada (MPa)
MAT(1,4) = 0.002;            %eco Deformaci�n al esfuerzo f'co
MAT(1,5) = 0.005;        %esp Deformaci�n al esfuerzo de aplastamiento
MAT(1,6) = MAT(1,3)/MAT(1,4);                 %  Eseco M�dulo Secante inconfinado
% ------------------------------------------
% propiedades de la categoría: Concreto confinado con modelo activo de Mander
% definida en GMSH como:
MAT(2,1) = 02;            % identificador de la categoria IDCA
% ---------------------------------------------
MAT(2,2) = 121;               % identificador del modelo material      
MAT(2,3) = 28;              %  resistencia a la compresi�n inconfinada (MPa)
MAT(2,4) = 0.002;           %eco Deformaci�n al esfuerzo f'co
MAT(2,5) = 3.87e-4;                 %  Asx area total barras transversales a lo largo de x
MAT(2,6) = 0.0677;                 %  dc altura del nucleo
MAT(2,7) = 2.58e-4;                 %  Asy area total barras transversales a lo largo de y
MAT(2,8) = 0.045;               %  bc base del nucleo
MAT(2,9) = 0.1;                 %  Separaci�n promedio
MAT(2,10)= 420;          % fy esfuerzo transversal de fluencia [MPa]
MAT(2,11)= 0.75;         %Coeficiente de efectividad ke
% ------------------------------------------
% propiedades de la categoría: Acero de refuerzo
% definida en GMSH como:
MAT(3,1) = 03;            % identificador de la categoría IDCA
% ---------------------------------------------
MAT(3,2) = 201;           % identificador del modelo material
MAT(3,3) = 450;         % fy esfuerzo de fluencia [MPa]
MAT(3,4) = 200e3;         % m�dulo de elasticidad [MPa]
MAT(3,5) = 0.008;         % deformación de inicio de endurec
MAT(3,6) = 0.100;         % deformación máxima
MAT(3,7) = 600;         % esfuerzo máximo [MPa]
MAT(3,8) =MAT(3,3)/MAT(3,4) ;           % deformaci�n Fluencia 


% -----------------------------------------------
% Bloque de parámetros de las acciones externas
% -----------------------------------------------
NYM(1) = 0.00;      % fuerza axial N

% ------------------------------------------
% Bloque de parámetros de análisis numérico
% ------------------------------------------
ANA(1) = 30;        % número de pasos de curvatura
ANA(2) = 0.001;     % tolerancia del error en la sumatoria de fuerza axial
ANA(3) = 0.0003;       % Valor de los intervalor de curvatura

% final de datos
% -----------------------------------------------------------------------------



