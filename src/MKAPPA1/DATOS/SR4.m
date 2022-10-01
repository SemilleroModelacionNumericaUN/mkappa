% Parámetros de entrada para el programa MKAPPA1
% Sección rectangular de 30x40 de concreto reforzado, con configuración de malla #4
% -----------------------------------------------------------------------------------
% Bloque de categorías definidas en la malla
% -----------------------------------------------------------------------------------

% Propiedades de la categoría: Concreto inconfinado,
% definida en GMSH como
MAT(1,1) = 01;                % identificador de la categoría IDCA
% -----------------------------------------------------------------------------------
MAT(1,2) = 101;               % identificador del modelo material
                              % 101 Modelo de Mander et al. a compresión y tensión
                              % 102 Modelo de Mander et al. a compresión y de Liang 
                              %     a tensión
MAT(1,3) = 28;                % f'co resistencia a la compresión inconfinada [MPa]
MAT(1,4) = 0;                 % f'co resistencia a la tensión [MPa]
MAT(1,5) = 0.002;             % eco Deformación al esfuerzo f'co
MAT(1,6) = 0.005;             % esp Deformación al esfuerzo de aplastamiento
MAT(1,7) = 0.25;              % v Relación de Poisson del concreto (nu)

% -----------------------------------------------------------------------------------
% Propiedades de la categoría: Concreto confinado,
% definida en GMSH como:
MAT(2,1) = 02;           % identificador de la categoría IDCA
% -----------------------------------------------------------------------------------
MAT(2,2) = 201;          % identificador del modelo material
                         % 201 Modelo de Mander et al. a compresión
                         % 202 Modelo de Susantha et al. para sección de tubería
                         %     cuadrada a compresión
                         % 203 Modelo de Susantha et al. para sección de tubería 
                         %     circular a compresión
%Caracteristicas del refuerzo (modificar si se utiliza el modelo de Mander et al.)
MAT(2,3) = 2.58e-4;      % Asx area total estribos transversales a lo largo de x [m2]
MAT(2,4) = 0.324;        % dc altura del núcleo [m]
MAT(2,5) = 2.58e-4;      % Asy area total estribos transversales a lo largo de y [m2]
MAT(2,6) = 0.226;        % bc base del núcleo [m]
MAT(2,7) = 0.1;          % s Separación promedio [m]
MAT(2,8)= 420;           % fy esfuerzo transversal de fluencia [MPa]
MAT(2,9)= 0.6192;        % ke Coeficiente de efectividad 
MAT(2,10)= 0.100;        % esfuerzo máximo de los estribos [MPa]
%Propiedades geométricas (modificar si se utiliza el modelo de Susantha et al.)
MAT(2,11)= 0;            % D Ancho de la sección rectangular o diámetro exterior [mm]
MAT(2,12)= 0;            % t Espesor de la tubería [mm]

% -----------------------------------------------------------------------------------
% Propiedades de la categoría: Acero estructural,
% definida en GMSH como:
MAT(3,1) = 03;                % identificador de la categoría IDCA
% -----------------------------------------------------------------------------------
MAT(3,2) = 301;               % identificador del modelo material
                              % 301 Modelo de King a compresión y tensión
                              % 302 Modelo de Liang a compresión y tensión
MAT(3,3) = 450;               % fy esfuerzo de fluencia [MPa]
MAT(3,4) = 200e3;             % módulo de elasticidad [MPa]
MAT(3,5) = 0.008;             % deformación de inicio de endurecimiento
MAT(3,6) = 0.100;             % deformación máxima
MAT(3,7) = 600;               % esfuerzo máximo [MPa]
MAT(3,8) = MAT(3,3)/MAT(3,4); % Deformación de fluencia 
MAT(3,9) = 0.3;               % Relación de Poisson

% -----------------------------------------------------------------------------------
% Bloque de parámetros de análisis numérico
% -----------------------------------------------------------------------------------
ANA(1) = 40;        % Número de pasos de curvatura
ANA(2) = 0.001;     % Valor de los intervalos de curvatura [1/m]
ANA(3) = 0.001;     % Tolerancia del error en la sumatoria de fuerza axial [kN]
ANA(4) = 2;         % Tipo de malla: 1 sección completa, 2 media sección

% final de datos
% -----------------------------------------------------------------------------------
