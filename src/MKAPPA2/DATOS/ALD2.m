% Par�metros de entrada para el programa MKAPPA2
% �ngulo de Lados Desiguales, con configuraci�n de malla #2
% -----------------------------------------------------------------------------------
% Bloque de categor�as definidas en la malla
% -----------------------------------------------------------------------------------

% Propiedades de la categor�a: Concreto inconfinado,
% definida en GMSH como
MAT(1,1) = 01;                % identificador de la categor�a IDCA
% -----------------------------------------------------------------------------------
MAT(1,2) = 0;                 % identificador del modelo material
                              % 101 Modelo de Mander et al. a compresi�n y tensi�n
                              % 102 Modelo de Mander et al. a compresi�n y de Liang 
                              %     a tensi�n
MAT(1,3) = 0;                 % f'co resistencia a la compresi�n inconfinada [MPa]
MAT(1,4) = 0;                 % f't resistencia a la tensi�n [MPa]
MAT(1,5) = 0;                 % eco Deformaci�n al esfuerzo f'co
MAT(1,6) = 0;                 % esp Deformaci�n al esfuerzo de aplastamiento
MAT(1,7) = 0;                 % v Relaci�n de Poisson del concreto (nu)

% -----------------------------------------------------------------------------------
% Propiedades de la categor�a: Concreto confinado,
% definida en GMSH como:
MAT(2,1) = 02;           % identificador de la categor�a IDCA
% -----------------------------------------------------------------------------------
MAT(2,2) = 0;            % identificador del modelo material
                         % 201 Modelo de Mander et al. a compresi�n
                         % 202 Modelo de Susantha et al. para secci�n de tuber�a
                         %     cuadrada a compresi�n
                         % 203 Modelo de Susantha et al. para secci�n de tuber�a 
                         %     circular a compresi�n
%Caracteristicas del refuerzo (modificar si se utiliza el modelo de Mander et al.)
MAT(2,3) = 0;            % Asx area total estribos transversales a lo largo de x [m2]
MAT(2,4) = 0;            % dc altura del n�cleo [m]
MAT(2,5) = 0;            % Asy area total estribos transversales a lo largo de y [m2]
MAT(2,6) = 0;            % bc base del n�cleo [m]
MAT(2,7) = 0;            % s Separaci�n promedio [m]
MAT(2,8)= 0;             % fy esfuerzo transversal de fluencia [MPa]
MAT(2,9)= 0;             % ke Coeficiente de efectividad 
MAT(2,10)= 0;            % esfuerzo m�ximo de los estribos [MPa]
%Propiedades geom�tricas (modificar si se utiliza el modelo de Susantha et al.)
MAT(2,11)= 0;            % D Ancho de la secci�n rectangular o di�metro exterior [mm]
MAT(2,12)= 0;            % t Espesor de la tuber�a [mm]

% -----------------------------------------------------------------------------------
% Propiedades de la categor�a: Acero estructural,
% definida en GMSH como:
MAT(3,1) = 03;                % identificador de la categor�a IDCA
% -----------------------------------------------------------------------------------
MAT(3,2) = 301;               % identificador del modelo material
                              % 301 Modelo de King a compresi�n y tensi�n
                              % 302 Modelo de Liang a compresi�n y tensi�n
MAT(3,3) = 250;               % fy esfuerzo de fluencia [MPa]
MAT(3,4) = 206.85e3;          % m�dulo de elasticidad [MPa]
MAT(3,5) = 0.100;             % deformaci�n de inicio de endurecimiento
MAT(3,6) = 0.100;             % deformaci�n m�xima
MAT(3,7) = 250;               % esfuerzo m�ximo [MPa]
MAT(3,8) = MAT(3,3)/MAT(3,4); % Deformaci�n de fluencia 
MAT(3,9) = 0.3;               % Relaci�n de Poisson

% -----------------------------------------------------------------------------------
% Bloque de par�metros de an�lisis num�rico
% -----------------------------------------------------------------------------------
ANA(1) = 35;        % N�mero de pasos de curvatura
ANA(2) = 0.002;     % Valor del incremento en la curvatura [1/m]
ANA(3) = 0.001;     % Tolerancia del error en la sumatoria de fuerza axial [kN]
ANA(4) = 0;         % �ngulo (theta) definido de la resultante de momentos [0�,360�]
ANA(5) = 0.0001;    % Tolerancia del error del �ngulo theta [�]

% final de datos
% -----------------------------------------------------------------------------------
