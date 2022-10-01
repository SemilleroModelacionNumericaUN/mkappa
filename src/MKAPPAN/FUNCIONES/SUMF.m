% Funci�n que calcula la sumatoria de fuerzas y de momentos en la secci�n para el
% paso de curvatura e iteraci�n correspondientes
function [SFZ,SMX,SMY,EA,EIX,EIY,GJ,EPZZ,STZZ,ESTA,ESEC,X,Y]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,vn,Icur,EPZZ,STZZ,ESTA,ESEC)
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
% Icur: n�mero del paso.
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
% ESEC: matriz actualizada de m�dulos de elasticidad secantes.
%    X: posici�n en x del Centro Ponderado por el M�dulo de Elasticidad Secante CPMES
%    Y: posici�n en x del Centro Ponderado por el M�dulo de Elasticidad Secante CPMES

%Inicializaci�n de variables
SFZ=0;      %Sumatoria de fuerzas
SMX=0;      %Sumatoria de momentos en direcci�n x
SMY=0;      %Sumatoria de momentos en direcci�n y
EA=0;       %Coeficiente de rigidez EA de la secci�n
EIX=0;      %Coeficiente de rigidez EI en direcci�n X de la secci�n
EIY=0;      %Coeficiente de rigidez EI en direcci�n Y de la secci�n
GJ=0;       %Coeficiente de rigidez GJ de la secci�n
EAX=0;      %Numerador para el c�lculo de X
EAY=0;      %Numerador para el c�lculo de Y

for IELE=1:NELE
    EPZZ(IELE,Icur)=k*(vn-CROT(IELE,2)); %Deformaci�n longitudinal de la fibra
    [STZZ(IELE,Icur),ESTA(IELE,Icur)]=MCM(EPZZ(IELE,Icur),CAT(ELE(IELE,1),1),MAT); %Esfuerzo en MPa
    %M�dulo de elasticidad secante de la fibra en MPa
    ESEC(IELE,Icur)=(STZZ(IELE,Icur)-STZZ(IELE,Icur-1))/(EPZZ(IELE,Icur)-EPZZ(IELE,Icur-1));
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
    G=ESEC(IELE,Icur)/(2*(1+v));  %M�dulo de elasticidad a cortante, en MPa
    EA=EA+ESEC(IELE,Icur)*ECA(IELE,3);                 %T�rmino asociado a la matriz de rigidez (en desuso)
    EIX=EIX+ESEC(IELE,Icur)*ECA(IELE,3)*ECA(IELE,2)^2; %T�rmino asociado a la matriz de rigidez (en desuso)
    EIY=EIY+ESEC(IELE,Icur)*ECA(IELE,3)*ECA(IELE,1)^2; %T�rmino asociado a la matriz de rigidez (en desuso)
    GJ=GJ+G*ECA(IELE,3)*(ECA(IELE,1)^2+ECA(IELE,2)^2); %T�rmino asociado a la matriz de rigidez (en desuso)
    FZ=STZZ(IELE,Icur)*ECA(IELE,3);              %Diferencial de fuerza en la fibra
    MX=STZZ(IELE,Icur)*ECA(IELE,3)*ECA(IELE,2);  %Diferencial de momento en x
    MY=-STZZ(IELE,Icur)*ECA(IELE,3)*ECA(IELE,1); %Diferencial de momento en y
    SFZ=SFZ+FZ*1000;      %Sumatoria de fuerzas en kN
    SMX=SMX+MX*1000;      %Sumatoria de momentos en direcci�n x en kN-m
    SMY=SMY+MY*1000;      %Sumatoria de momentos en direcci�n y en kN-m
    EAX=EAX+ESEC(IELE,Icur)*ECA(IELE,3)*ECA(IELE,1); %Numerador para el c�lculo de X
    EAY=EAY+ESEC(IELE,Icur)*ECA(IELE,3)*ECA(IELE,2); %Numerador para el c�lculo de Y
    EA=EA+ESEC(IELE,Icur)*ECA(IELE,3); %Denominador para el c�lculo de X y Y
end
X=EAX/EA; %Posici�n en x del CPMES
Y=EAY/EA; %Posici�n en y del CPMES
end