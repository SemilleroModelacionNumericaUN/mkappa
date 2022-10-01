% Funci�n que calcula la sumatoria de fuerzas y de momentos en la secci�n para el
% paso e iteraci�n correspondientes
function [SFZ,SMX,SMY,EA,EIX,EIY,GJ,EPZZ,STZZ,ESTA]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,vn,IPAS,EPZZ,STZZ,ESTA,E)
%
% Par�metros de entrada:
%  CAT: tabla del identificador IDCA de la categor�a en el archivo.msh de Gmsh.
%  MAT: tabla de par�metros de la categor�a en el archivo .m .
% NELE: n�mero de elementos de la malla.
%  ECA: tabla de las coordenadas del centroide y el �rea de cada elemento de la forma
%       [XCEN, YCEN, AREA].
% CROT: tabla de las coordenadas del centroide en el sistema rotado de la forma
%       [UCEN, VCEN].
%  ELE: tabla de categor�a y conectividades de los elementos de la forma
%       [ ICAT NUDI NUDJ NUDK NUDL ].
%    k: valor de curvatura del paso.
%   vn: posici�n del eje neutro respecto al sistema rotado de la iteraci�n .
% IPAS: n�mero del paso.
% EPZZ: matriz de deformaciones longitudinales en direcci�n z para cada fibra.
% STZZ: matriz de esfuerzos normales en direcci�n z para cada fibra.
% ESTA: matriz de estados del material para cada fibra.
%    E: matriz de m�dulos de elasticidad secantes.
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
    EPZZ(IELE,IPAS)=k*(vn-CROT(IELE,2)); %Deformaci�n longitudinal de la fibra
    [STZZ(IELE,IPAS),ESTA(IELE,IPAS)] = ...
                 MCM(EPZZ(IELE,IPAS),CAT(ELE(IELE,1),1),MAT); %Esfuerzos en MPa
    %C�lculo del m�dulo de elasticidad secante
    if IPAS>1
        DEPZZ = EPZZ(IELE,IPAS) - EPZZ(IELE,IPAS-1);
        DSTZZ = STZZ(IELE,IPAS) - STZZ(IELE,IPAS-1);
        if DEPZZ==0
          E(IELE,IPAS)=0;
        else
          E(IELE,IPAS) = DSTZZ/DEPZZ; %En MPa
        end
    else
        if EPZZ(IELE,IPAS)==0
          E(IELE,IPAS)=0;
        else
          E(IELE,IPAS)=STZZ(IELE,IPAS)/EPZZ(IELE,IPAS); %En MPa
        end
    end
    %Determinaci�n de la relaci�n de Poisson para el material
    if CAT(ELE(IELE,1),1)==01 || CAT(ELE(IELE,1),1)==02
        v=MAT(1,7);
    elseif CAT(ELE(IELE,1),1)==03
        v=MAT(3,9);
    else
        fprintf('\nError en la definici�n de las categor�as');
        fprintf('\nLa relaci�n de Poisson para la categor�a %i no existe',CAT(ELE(IELE,1),1));
        return
    end
    G=E(IELE,IPAS)/(2*(1+v));  %M�dulo de elasticidad a cortante, en MPa
    EA=EA+E(IELE,IPAS)*ECA(IELE,3);                    %T�rmino asociado a la matriz de rigidez (en desuso)
    EIX=EIX+E(IELE,IPAS)*ECA(IELE,3)*ECA(IELE,2)^2;    %T�rmino asociado a la matriz de rigidez (en desuso)
    EIY=EIY+E(IELE,IPAS)*ECA(IELE,3)*ECA(IELE,1)^2;    %T�rmino asociado a la matriz de rigidez (en desuso)
    GJ=GJ+G*ECA(IELE,3)*(ECA(IELE,1)^2+ECA(IELE,2)^2); %T�rmino asociado a la matriz de rigidez (en desuso)
    FZ=STZZ(IELE,IPAS)*ECA(IELE,3);              %Diferencial de fuerza en el elemento
    MX=STZZ(IELE,IPAS)*ECA(IELE,3)*ECA(IELE,2);  %Diferencial de momento en x
    MY=-STZZ(IELE,IPAS)*ECA(IELE,3)*ECA(IELE,1); %Diferencial de momento en y
    SFZ=SFZ+FZ*1000;      %Sumatoria de fuerzas en kN
    SMX=SMX+MX*1000;      %Sumatoria de momentos en direcci�n a x en kN-m
    SMY=SMY+MY*1000;      %Sumatoria de momentos en direcci�n a y en kN-m
end
end








