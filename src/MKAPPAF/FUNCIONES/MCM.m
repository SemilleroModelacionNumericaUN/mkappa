% Función que determina el esfuerzo normal y el estado del material de una fibra por 
% medio de las ecuaciones de los modelos constitutivos unidimensionales no lineales
function [STZZ,ESTA]=MCM(EZZ,CAT,MAT)
%
% Parámetros de entrada:
% EZZ:  deformación longitudinal de la fibra para el paso e iteración 
%       correspondientes.
% CAT:  tabla del identificador IDCA de la categoría en el archivo.msh de Gmsh.
% MAT:  tabla de parámetros de la categoría en el archivo .m . 
%       
% Parámetros de salida:
% STZZ: esfuerzo normal de la fibra para el paso e iteración
%       correspondientes.
% ESTA: número relacionado al estado del material de la fibra para el paso e
%       iteración correspondientes.

%Propiedades del concreto inconfinado
mci=MAT(1,2);  %identificador del modelo de concreto inconfinado
fcop=MAT(1,3); %Resistencia máxima a la compresión inconfinada [MPa]
ftp=MAT(1,4);  %Resistencia a la tensión del concreto [MPa]
eco=MAT(1,5);  %Deformación al esfuerzo máximo a compresión
esp=MAT(1,6);  %Deformación al esfuerzo de aplastamiento

%Propiedades del concreto confinado
mcc=MAT(2,2);  %identificador del modelo de concreto confinado
Asx=MAT(2,3);  %Área total estribos transversales a lo largo de x [m^2]
dc=MAT(2,4);   %Altura del núcleo [m]
Asy=MAT(2,5);  %Área total estribos transversales a lo largo de y [m^2]
bc=MAT(2,6);   %Ancho del núcleo [m]
s=MAT(2,7);    %Separación promedio [m]
fyh=MAT(2,8);  %Esfuerzo transversal de fluencia [MPa]
ke=MAT(2,9);   %Coeficiente de efectividad
euh=MAT(2,10); %Esfuerzo máximo o esfuerzo último del estribo [MPa]

%Propiedades del acero
ms=MAT(3,2);   %identificador del modelo de acero
fy=MAT(3,3);   %Esfuerzo de fluencia en [MPa]
Es=MAT(3,4);   %Módulo de elasticidad del acero [MPa]
esh=MAT(3,5);  %Deformación de inicio endurecimiento o hardening
esu=MAT(3,6);  %Deformación máxima del acero
fsu=MAT(3,7);  %Esfuerzo máximo o esfuerzo último [MPa]
ey=MAT(3,8);   %Deformación de fluencia

n=CAT;
e=EZZ;

switch n
    
    case 1  %Concreto inconfinado. Mander et al.
        if mci==101||mci==102
            if e<0 %Fibra a compresión
                %Cálculo del esfuerzo a compresión inconfinada
                ec=abs(e);
                xo=ec/eco;
                Eseco=fcop/eco;
                Ec=5000*(fcop)^(1/2); %En MPa%
                ro=Ec/(Ec-Eseco);
                if ec<2*eco
                    fci=fcop*xo*ro/(ro-1+xo^ro);
                elseif ec<esp
                    fp=fcop*2*ro/(ro-1+2^ro);
                    fci=fp*(ec-esp)/(2*eco-esp); %Interpolación lineal%
                else
                    fci=0;
                end
            else %Fibra a tensión
                pt=mci-101;
                Ec=5000*(fcop)^(1/2); %En MPa%
                et=e;
                eto=ftp/Ec;
                etu=10*eto*pt;
                
                if et<eto
                    ft=ftp*et/eto; %=Ec*et%
                elseif et<etu
                    ft=ftp*(etu-et)/(etu-eto);
                else
                    ft=0;
                end
            end
                        
        elseif mci==103
            if e<0 %Fibra a compresión
                %Agregar en esta zona el nuevo modelo con eco, esp y fci como resultados
                %y eliminar las dos líneas de código que se muestran a continuación
                fprintf('Error. El identificador 103 aún no tiene un modelo asignado a compresión. \n')
                return
            else %Fibra a tensión
                %Agregar en esta zona el nuevo modelo con ft como resultado
                %y eliminar las tres líneas de código que se muestran a continuación
                fprintf('Error. El identificador 103 aún no tiene un modelo asignado a tensión. \n')
                fprintf('Nota: El modelo del concreto inconfinado a tensión es igual al del concreto confinado. \n')
                return
            end
        else
            fprintf('Error. El identificador del modelo no existe. \n')
            return 
        end
        
        %Asignación del estado y el esfuerzo
        if e>=0
            ESTA=1;     %C. inconfinado a tensión
            STZZ=ft;
        elseif e>-eco
            ESTA=2;     %C. inconfinado en endurecimeinto
            STZZ=-fci;
        elseif e>-esp
            ESTA=3;     %C. inconfinado en ablandamiento
            STZZ=-fci;
        else
            ESTA=4;     %C. inconfinado en desprendimiento sup.
            STZZ=-fci;
        end
        
    case 2  %Concreto confinado. 
       
        if e<0 %Fibra a compresión
            if mcc==201 %Modelo de Mander et al.
                ec=abs(e);
                px=Asx/(s*dc);
                py=Asy/(s*bc);
                flx=px*fyh;
                fly=py*fyh;
                flxp=ke*flx;
                flyp=ke*fly;
                flp=0.5*(flxp+flyp);
                fccp=fcop*(-1.254+2.254*(1+(7.94*flp/fcop))^(1/2)-(2*flp/fcop));
                ecc=eco*(1+5*((fccp/fcop)-1));
                ecu=0.004+1.4*(px+py)*fyh*euh/fccp; %Modificado de CUMBIA 2007
                x=ec/ecc;
                Esec=fccp/ecc;
                Ec=5000*(fcop)^(1/2); %En MPa%
                r=Ec/(Ec-Esec);
                fcc=fccp*x*r/(r-1+x^r);
                
            elseif mcc==202||mcc==203 %Modelo de Susantha et al.%
                [fcc,ecc,ecu]=CFST(MAT,e,mcc); %Función del MC para un CFST
            elseif mcc==204 
                %Agregar en esta zona el nuevo modelo con ecc, ecu y fcc como resultados
                %y eliminar las dos líneas de código que se muestran a continuación
                fprintf('Error. El identificador 124 aún no tiene un modelo asignado a compresión. \n')
                return
            else
                fprintf('Error. El identificador del modelo no existe. \n')
                return
            end
            
            %Asignación de estados y esfuerzos
            if e>-ecc
                ESTA=6;     %C. confinado en endurecimeinto
                STZZ=-fcc;
            elseif e>-ecu
                ESTA=7;     %C. confinado en ablandamiento
                STZZ=-fcc;
            else
                ESTA=8;     %C. confinado en aplastamiento
                STZZ=0;
            end
            
        else %Fibra a tensión
            if mci==101||mcc==102                
                pt=mci-101;
                Ec=5000*(fcop)^(1/2); %En MPa%
                et=e;
                eto=ftp/Ec;
                etu=10*eto*pt;
                
                if et<eto
                    ft=ftp*et/eto; %=Ec*et%
                elseif et<etu
                    ft=ftp*(etu-et)/(etu-eto);
                else
                    ft=0;
                end
            elseif mci==103
                %Agregar en esta zona el nuevo modelo con ft como resultado
                %y eliminar las tres líneas de código que se muestran a continuación
                fprintf('Error. El identificador 103 aún no tiene un modelo asignado a tensión. \n')
                fprintf('Nota: El modelo del concreto confinado a tensión es igual al del concreto inconfinado. \n')
                return
            else
                fprintf('Error. El identificador del modelo no existe. \n')
                return
            end
            
            %Asignación del estado y el esfuerzo
            ESTA=5;     %C. inconfinado a tensión
            STZZ=ft;
        end
        
    case 3  %Acero estructural
        
        if ms==301 %Modelo de King
            if e<0 %Fibra a compresión
                es=abs(e);
            else %Fibra a tensión
                es=e;
            end
            if es<=ey
                fs=Es*es; %Rango elastico
            elseif es<=esh
                fs=fy;    %Fluencia
            elseif es<=esu
                rs=esu-esh;    %Factor r para el modelo de King
                m=((fsu/fy)*(30*rs+1)^2-60*rs-1)/(15*rs^2); %Factor m
                fs=fy*(((m*(es-esh)+2)/(60*(es-esh)+2))+(((es-esh)*...
                    (60-m))/(2*(30*rs+1)^2))); %Endurecimiento King%
            else
                fs=0;
            end
        elseif ms==302 %Modelo de Liang
            if e<0 %Fibra a compresión
                es=abs(e);
            else %Fibra a tensión
                es=e;
            end
            if es<=ey
                fs=Es*es; %Rango elastico
            elseif es<=esh
                fs=fy;    %Fluencia
            elseif es<=esu
                fs=fy+(fsu-fy)*(es-esh)/(esu-esh); %Endurecimiento Liang%
            else
                fs=0;
            end
        elseif ms==303
            if e<0 %Fibra a compresión
                %Agregar en esta zona el nuevo modelo con ey, esh, esu y fs como resultado
                %y eliminar las dos líneas de código que se muestran a continuación
                fprintf('Error. El identificador 203 aún no tiene un modelo asignado a compresión. \n')
                return
            else %Fibra a tensión
                %Agregar en esta zona el nuevo modelo con ey, esh, esu y fs como resultado
                %y eliminar las dos líneas de código que se muestran a continuación
                fprintf('Error. El identificador 203 aún no tiene un modelo asignado a tensión. \n')
                return
            end
        else
            fprintf('Error. El identificador del modelo no existe. \n')
            return
        end
        
        %Asignación del estado y el esfuerzo
        if e>=0 %Acero a tensión
            if e<ey
                ESTA=9;     %Acero a tensión en linealidad
                STZZ=fs;
            elseif e<esh    %Acero a tensión en fluencia
                ESTA=10;
                STZZ=fs;
            elseif e<esu    %Acero a tensión en endurecimiento
                ESTA=11;
                STZZ=fs;
            else
                ESTA=12;    %Acero a tensión en rótura
                STZZ=fs;
            end
        else %Acero a compresión
            if e>-ey
                ESTA=13;     %Acero a compresión en linealidad
                STZZ=-fs;
            elseif e>-esh
                ESTA=14;    %Acero a compresión en fluencia
                STZZ=-fs;
            elseif e>-esu
                ESTA=15;    %Acero a compresión en endurecimiento
                STZZ=-fs;
            else
                ESTA=16;    %Acero a compresión en rótura
                STZZ=-fs;
            end
        end
        
    case 4  %Categoría auxiliar
        %Agregar en esta zona la nueva categoría donde al final se asigne
        %el estado y el esfuerzo de la fibra, y eliminar las dos líneas de código 
        %que se muestran a continuación
        fprintf('Error. El identificador de categoría 4 aún no tiene asignadas sus propiedades \n')
        return
    otherwise
        fprintf('Error. El identificador de la categoría no existe. \n')
        return
end
end