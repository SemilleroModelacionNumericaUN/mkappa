% Funci�n que calcula la sumatoria de fuerzas y de momentos en la secci�n para el
% paso de curvatura 0 de cada paso de deformaci�n axial
function [SFZ,SMX,SMY,EA,EIX,EIY,GJ,EPZZ,STZZ,ESTA,ESEC]=SUMF0(CAT,MAT,NELE,ECA,ELE,e,EPZZ,STZZ,ESTA,ESEC)
%
% Par�metros de entrada:
%  CAT: tabla del identificador IDCA de la categor�a en el archivo.msh de Gmsh.
%  MAT: tabla de par�metros de la categor�a en el archivo .m .
% NELE: n�mero de elementos de la malla.
%  ECA: tabla de las coordenadas del centroide y el �rea de cada elemento de la forma
%       [XCEN, YCEN, AREA].
%  ELE: tabla de categor�a y conectividades de los elementos de la forma
%       [ ICAT NUDI NUDJ NUDK NUDL ].
%    e: valor de deformaci�n axial del paso.
%   vn: posici�n del eje neutro respecto al sistema rotado de la iteraci�n .
% IPAS: n�mero del paso.
% EPZZ: matriz de deformaciones longitudinales en direcci�n z para cada fibra.
% STZZ: matriz de esfuerzos normales en direcci�n z para cada fibra.
% ESTA: matriz de estados del material para cada fibra.
% ESEC: matriz de m�dulos de elasticidad secantes.
%
% Par�metros de salida:
%  SFZ: resultado de la sumatoria de fuerzas en direcci�n z.
%  SMX: resultado de la sumatoria de momentos en direcci�n x.
%  SMY: resultado de la sumatoria de momentos en direcci�n y.
%   EA: coeficiente de rigidez EA del paso determinado.
%  EIX: coeficiente de rigidez EI en direcci�n X del paso determinado.
%  EIY: coeficiente de rigidez EI en direcci�n Y del paso determinado.
%   GJ: coeficiente de rigidez GJ del paso determinado.
% EPZZ: matriz actualizada de deformaciones longitudinales en direcci�n z para cada fibra.
% STZZ: matriz actualizada de esfuerzos normales en direcci�n z para cada fibra.
% ESTA: matriz actualizada de estados del material para cada fibra.

%Inicializaci�n de variables
SFZ=0;      %Sumatoria de fuerzas
SMX=0;      %Sumatoria de momentos en direcci�n x
SMY=0;      %Sumatoria de momentos en direcci�n y    
EA=0;       %Coeficiente de rigidez EA de la secci�n
EIX=0;      %Coeficiente de rigidez EI en direcci�n Y de la secci�n
EIY=0;      %Coeficiente de rigidez EI en direcci�n Z de la secci�n
GJ=0;       %Coeficiente de rigidez GJ de la secci�n

for IELE=1:NELE
    EPZZ(IELE,1)=e; %Deformaci�n longitudinal de la fibra
    [STZZ(IELE,1),ESTA(IELE,1)]=MCM(EPZZ(IELE,1),CAT(ELE(IELE,1),1),MAT); %Esfuerzo normal en MPa
    ESEC(IELE,1)=STZZ(IELE,1)/EPZZ(IELE,1); %M�dulo de elasticidad secante en MPa
    %Determinaci�n de la relaci�n de Poisson par el material
    if CAT(ELE(IELE,1),1)==01 || CAT(ELE(IELE,1),1)==02
        v=MAT(1,7);
    elseif CAT(ELE(IELE,1),1)==03
        v=MAT(3,9);
    else
        fprintf('\nError en la definici�n de las categor�as');
        fprintf('\nLa relaci�n de Poisson para la categor�a %i no existe',CAT(ELE(IELE,1),1));
        return
    end
    G=ESEC(IELE,1)/(2*(1+v));  %M�dulo de elasticidad a cortante, en MPa
    EA=EA+ESEC(IELE,1)*ECA(IELE,3);                  %T�rmino asociado a la matriz de rigidez (en desuso)
    EIX=EIX+ESEC(IELE,1)*ECA(IELE,3)*ECA(IELE,2)^2;  %T�rmino asociado a la matriz de rigidez (en desuso)
    EIY=EIY+ESEC(IELE,1)*ECA(IELE,3)*ECA(IELE,1)^2;  %T�rmino asociado a la matriz de rigidez (en desuso)
    GJ=GJ+G*ECA(IELE,3)*(ECA(IELE,1)^2+ECA(IELE,2)^2); %T�rmino asociado a la matriz de rigidez (en desuso)
    FZ=STZZ(IELE,1)*ECA(IELE,3);              %Diferencial de fuerza en la fibra
    MX=STZZ(IELE,1)*ECA(IELE,3)*ECA(IELE,2);  %Diferencial de momento en x
    MY=-STZZ(IELE,1)*ECA(IELE,3)*ECA(IELE,1); %Diferencial de momento en y
    SFZ=SFZ+FZ*1000;      %Sumatoria de fuerzas en kN
    SMX=SMX+MX*1000;      %Sumatoria de momentos en direcci�n x en kN-m
    SMY=SMY+MY*1000;      %Sumatoria de momentos en direcci�n y en kN-m
end
end