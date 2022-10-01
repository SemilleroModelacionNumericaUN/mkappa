% Función que determina el esfuerzo normal, la deformación al máximo y la deformación
% última para una fibra de concreto en una sección tipo CFST.
function [fcc,ecc,ecu]=CFST(MAT,e,mcc)
%
% Parámetros de entrada:
% MAT:  tabla de parámetros de la categoría en el archivo .m .
%   e:  deformación longitudinal de la fibra de concreto considerada al ejecutar MCM.
% mcc:  identificador del modelo de concreto confinado
%
% Parámetros de salida:
% fcc:  esfuerzo normal de la fibra para el paso e iteración correspondientes.
% ecc:  deformación longitudinal del material correspondiente al máximo
%       valor de esfuerzo de compresión.
% ecu:  deformación última del material.

%Modelo constitutivo del concreto para CFST cirulares o cuadrados
fcop=MAT(1,3);  %Resistencia del concreto inconfinado en MPa
fy=MAT(3,3);    %Esfuerzo de fluencia del acero en MPa
Es=MAT(3,4);    %Módulo de Young del acero en MPa
v=MAT(3,9);     %Relación de Poisson
D=MAT(2,11);    %Ancho de la sección rectangular o diámetro exterior en mm
t=MAT(2,12);    %Espesor de la tubería en mm
cp=0;           %Criterio que considera el pandeo 
                %0 No hay pandeo
                %1 Si hay pandeo
                
%Convención: son positivas las deformaciones asociadas con esfuerzos
%de tracción en el material.
ec=abs(e);

if fcop<=28
    eco=0.002;
elseif fcop<=82
    eco=0.002+(fcop-28)/5400;
else
    eco=0.003;
end

switch mcc
    case 202 %Tubería compuesta cuadrada
        
        R=(D/t)*(12*(1-v^2)/(4*pi^2))^(1/2)*(fy/Es)^(1/2);
        frp=-6.5*R*fcop^1.46/fy+0.12*fcop^1.03;
        
        fccp=fcop+4*frp;
        ecc=eco*(1+5*((fccp/fcop)-1));
        FR=R*fcop/fy;
        
        if R>0.85
            cp=1;
            fprintf('Error. La sección actual produce pandeo local en el elemento\n');
            return
        end
        
        if FR<=0.0039
            Z=0;
        else
            Z=23400*FR-91.26;
        end
        
        if FR<0.042
            ecu=0.04;
        elseif FR<0.073
            ecu=14.50*FR^2-2.4*FR+0.116;
        else
            ecu=0.018;
        end
        
    case 203 %Tubería compuesta circular
        
        vep=0.881*(10^-6)*(D/t)^3-2.58*(10^-4)*(D/t)^2+1.953*10^-2*(D/t)+0.4011;
        ve=0.2312+0.3582*vep-0.1524*(fcop/fy)+4.843*vep*(fcop/fy)-9.169*(fcop/fy)^2;
        vs=0.5;
        
        if D/t<=47
            frp=0.7*(ve-vs)*2*fy*t/(D-2*t);
        elseif D/t<=150
            frp=(0.006241-0.0000357*(D/t))*fy;
        else
            fprintf('Error. La relación D/t es mayor que 150\n');
            fprintf('En consecuencia, el modelo no es aplicable\n');
            return
        end
        
        fccp=fcop+4*frp;
        ecc=eco*(1+5*((fccp/fcop)-1));
        ecu=0.025;
        Rt=(3*(1-v^2))^(1/2)*fy*D/(Es*2*t);
        FR=Rt*fcop/fy;
        
        if Rt>0.125
            cp=1;
            fprintf('Error. La sección actual produce pandeo local en el elemento\n');
            return
        end
        
        if FR<=0.006
            Z=0;
        else
            if fy<=283
                Z=1*10^5*FR-600;
            elseif fy<=336
                Z=(fy/283)^13.4*(1*10^5*FR-600);
            else
                Z=1*10^6*FR-6000;
            end
        end
    otherwise
        fprintf('Error. Identificador del modelo desconocido');
        return
end

if ec<ecc
    x=ec/ecc;
    Esec=fccp/ecc;
    Ec=3320*((fcop)^(1/2))+6900; %En MPa%
    r=Ec/(Ec-Esec);
    fcc=fccp*x*r/(r-1+x^r);
elseif ec<ecu
    fcc=fccp-Z*(ec-ecc);
else
    fcc=fccp-Z*(ecu-ecc);
end
end