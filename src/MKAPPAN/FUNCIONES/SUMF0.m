% Función que calcula la sumatoria de fuerzas y de momentos en la sección para el
% paso de curvatura 0 de cada paso de deformación axial
function [SFZ,SMX,SMY,EA,EIX,EIY,GJ,EPZZ,STZZ,ESTA,ESEC]=SUMF0(CAT,MAT,NELE,ECA,ELE,e,EPZZ,STZZ,ESTA,ESEC)
%
% Parámetros de entrada:
%  CAT: tabla del identificador IDCA de la categoría en el archivo.msh de Gmsh.
%  MAT: tabla de parámetros de la categoría en el archivo .m .
% NELE: número de elementos de la malla.
%  ECA: tabla de las coordenadas del centroide y el área de cada elemento de la forma
%       [XCEN, YCEN, AREA].
%  ELE: tabla de categoría y conectividades de los elementos de la forma
%       [ ICAT NUDI NUDJ NUDK NUDL ].
%    e: valor de deformación axial del paso.
%   vn: posición del eje neutro respecto al sistema rotado de la iteración .
% IPAS: número del paso.
% EPZZ: matriz de deformaciones longitudinales en dirección z para cada fibra.
% STZZ: matriz de esfuerzos normales en dirección z para cada fibra.
% ESTA: matriz de estados del material para cada fibra.
% ESEC: matriz de módulos de elasticidad secantes.
%
% Parámetros de salida:
%  SFZ: resultado de la sumatoria de fuerzas en dirección z.
%  SMX: resultado de la sumatoria de momentos en dirección x.
%  SMY: resultado de la sumatoria de momentos en dirección y.
%   EA: coeficiente de rigidez EA del paso determinado.
%  EIX: coeficiente de rigidez EI en dirección X del paso determinado.
%  EIY: coeficiente de rigidez EI en dirección Y del paso determinado.
%   GJ: coeficiente de rigidez GJ del paso determinado.
% EPZZ: matriz actualizada de deformaciones longitudinales en dirección z para cada fibra.
% STZZ: matriz actualizada de esfuerzos normales en dirección z para cada fibra.
% ESTA: matriz actualizada de estados del material para cada fibra.

%Inicialización de variables
SFZ=0;      %Sumatoria de fuerzas
SMX=0;      %Sumatoria de momentos en dirección x
SMY=0;      %Sumatoria de momentos en dirección y    
EA=0;       %Coeficiente de rigidez EA de la sección
EIX=0;      %Coeficiente de rigidez EI en dirección Y de la sección
EIY=0;      %Coeficiente de rigidez EI en dirección Z de la sección
GJ=0;       %Coeficiente de rigidez GJ de la sección

for IELE=1:NELE
    EPZZ(IELE,1)=e; %Deformación longitudinal de la fibra
    [STZZ(IELE,1),ESTA(IELE,1)]=MCM(EPZZ(IELE,1),CAT(ELE(IELE,1),1),MAT); %Esfuerzo normal en MPa
    ESEC(IELE,1)=STZZ(IELE,1)/EPZZ(IELE,1); %Módulo de elasticidad secante en MPa
    %Determinación de la relación de Poisson par el material
    if CAT(ELE(IELE,1),1)==01 || CAT(ELE(IELE,1),1)==02
        v=MAT(1,7);
    elseif CAT(ELE(IELE,1),1)==03
        v=MAT(3,9);
    else
        fprintf('\nError en la definición de las categorías');
        fprintf('\nLa relación de Poisson para la categoría %i no existe',CAT(ELE(IELE,1),1));
        return
    end
    G=ESEC(IELE,1)/(2*(1+v));  %Módulo de elasticidad a cortante, en MPa
    EA=EA+ESEC(IELE,1)*ECA(IELE,3);                  %Término asociado a la matriz de rigidez (en desuso)
    EIX=EIX+ESEC(IELE,1)*ECA(IELE,3)*ECA(IELE,2)^2;  %Término asociado a la matriz de rigidez (en desuso)
    EIY=EIY+ESEC(IELE,1)*ECA(IELE,3)*ECA(IELE,1)^2;  %Término asociado a la matriz de rigidez (en desuso)
    GJ=GJ+G*ECA(IELE,3)*(ECA(IELE,1)^2+ECA(IELE,2)^2); %Término asociado a la matriz de rigidez (en desuso)
    FZ=STZZ(IELE,1)*ECA(IELE,3);              %Diferencial de fuerza en la fibra
    MX=STZZ(IELE,1)*ECA(IELE,3)*ECA(IELE,2);  %Diferencial de momento en x
    MY=-STZZ(IELE,1)*ECA(IELE,3)*ECA(IELE,1); %Diferencial de momento en y
    SFZ=SFZ+FZ*1000;      %Sumatoria de fuerzas en kN
    SMX=SMX+MX*1000;      %Sumatoria de momentos en dirección x en kN-m
    SMY=SMY+MY*1000;      %Sumatoria de momentos en dirección y en kN-m
end
end