% -----------------------------------------------------------------------------------
% MKAPPA1: Programa didáctico de análisis no lineal de secciones transversales 
% simétricas en elementos estructurales a flexión uniaxial, aplicando el el método de
% las fibras.
% Fiber model for beam-column elements 
% (Kaba & Mahin, 1984; Tausen, Spaco & Filippou, 1991)
% -----------------------------------------------------------------------------------
% Dorian L. Linero S.
% Universidad Nacional de Colombia
% Facultad de Ingeniería
% Todos los derechos reservados, 2019
% Modificado por Hernán Buitrago y David Gómez 2020
% Modificado por Hernán Buitrago 2022

function MKAPPA1 (ADAT,TLEC)
% ADAT: nombre del archivo de entrada de datos sin extensión
% TLEC: identificador de la opción de lectura de datos. Este es un parámetro
%       que por defecto es igual a 0.
% -----------------------------------------------------------------------------------
% presentación inicial en pantalla
clc; % limpiar pantalla
fprintf('----------------------------------------------------------------- \n');
fprintf('       MKAPPA1. Universidad Nacional de Colombia 2022          \n');
fprintf('----------------------------------------------------------------- \n');
% fprintf('=10: opción habilitada \n');
% fprintf('=11: otras opciones no habilitadas \n');
% fprintf('=12: otras opciones no habilitadas \n');
% fprintf('Si <opciones lectura> se omite adquiere un valor de 10. \n');
% fprintf('------------------------------------------------------------------\n');
% -----------------------------------------------------------------------------------
% control de ausencia de argumentos
if exist('ADAT') == 0
    fprintf('MKAPPA. La función requiere <nombre archivo datos>.\n')
    return
end
if exist('TLEC') == 0
    TLEC='10';
    % fprintf('MKAPPA. La funcion tomarÃ¡ por defecto a <opciones lectura>=10.\n')
end
ADAD = strcat('./DATOS/',ADAT);
TLEN = str2num(TLEC);

% adicionar carpetas y tomar tiempo inicial
addpath('./FUNCIONES');
addpath('./DATOS');
TINT = IMTIEM('Inicio de ejecución del programa \n',0);

% -----------------------------------------------------------------------------------
TINI = IMTIEM('Lectura de datos de archivos .m y .msh de GMSH \n',0);
% -----------------------------------------------------------------------------------
if TLEN==10
    % opción habilitada
    % lectura de entrada de datos de archivo .m
    run(ADAT); % crea las tablas MAT, FLE, y ANA
    
    % opción de lectura de entrada de datos de archivo .msh de GMSH
    [NNUD,NELE,NCAT,NNUE,XYZ,ELE,CAT,SUP] = LEGMSH(ADAD);
    
    %condicional para garantizar el uso de elementos implementados
    if NNUE==3
    else
        fprintf('La malla contiene elementos que no son triangulares');
        fprintf('Actualmente, solo se permite el uso de elementos triangulares');
        fprintf('Modifique la malla y ejecute nuevamente el programa');
        return
    end
    
    % Construcción de tabla completa de categorías, donde el número de la fila
    % corresponde con el número de la categoría asociado al elemento en la
    % primera columna de la tabla de conectividades ELE.
    % Incluye unicamente las categorías de los materiales presentes en la sección.
    CAE = CATEGO(CAT,MAT);
    
    % construcción de tabla de centroides y áreas de los elementos
    % ECA=[XCEN,YCEN,AREA] en cada fila IELE.
    % cálculo del centro de rigidez de la sección SUMX,SUMY como la sumatoria
    % de (Ei Ai yi) dividido entre la sumatoria de (Ei Ai), siendo Ei el
    % módulo de elasticidad del material, Ai el área del elemento y yi la
    % posición en dirección y de su centroide.
    % -------------------------------------------------------------------------------
    SUMX = 0; SUMY= 0; SUMA=0;
    ECA = zeros(NELE,3); XYE = zeros(NNUE,2);
    for IELE=1:NELE
        % tabla de coordenadas de los nudos del elemento IELE
        for INUE=1:NNUE
            XYE(INUE,1) = XYZ(ELE(IELE,INUE+1),1);
            XYE(INUE,2) = XYZ(ELE(IELE,INUE+1),2);
        end % endfor INUE
        % tabla de centroide y área del elemento IELE
        ECA(IELE,1:3) = PBARCE(XYE);
        SUMX = SUMX + CAE(ELE(IELE,1),4) * ECA(IELE,3) * ECA(IELE,1) ;
        SUMY = SUMY + CAE(ELE(IELE,1),4) * ECA(IELE,3) * ECA(IELE,2) ;
        SUMA = SUMA + CAE(ELE(IELE,1),4) * ECA(IELE,3);
    end % endfor IELE
    CENX = SUMX / SUMA; %Posición en x del centroide 
    CENY = SUMY / SUMA; %Posición en y del centroide 
    % -------------------------------------------------------------------------------
    
    % Parámetros de análisis
    NPAS = ANA(1); % Número de pasos de curvatura (adicionales al paso 0)
    Dk   = ANA(2); % Valor del intervalo de curvatura, delta kappa
    Tolf = ANA(3); % Tolerancia de la sumatoria de fuerza axial
    Ntip = ANA(4); % Parámetro del tipo de malla: 1 completo, 2 media sec.
    
    fprintf('Malla de %g nudos, %g elementos y %g pasos ', NNUD,NELE,NPAS);
else
    % opciones no habilitadas
    
end %endif
TFIN = IMTIEM('',TINI);

% -----------------------------------------------------------------------------------
TINI = IMTIEM('Escribir la malla en el archivo .pos \n',0);
% -----------------------------------------------------------------------------------
% abrir archivo .pos
GMSH = strcat(ADAD,'.pos'); % nombre archivo GMSH .pos de los resultados
FIDE = fopen(GMSH,'w'); % abrir archivo y establecer identificador
% escribir geometría de la malla en .pos
IMPGEO(FIDE,NNUD,NELE,NNUE,NCAT,XYZ,ELE,SUP);
TFIN = IMTIEM('',TINI);

% -----------------------------------------------------------------------------------
TINI = IMTIEM('Análisis por incrementos de curvatura \n',0);
% -----------------------------------------------------------------------------------

%Inicialización de variables
MV=zeros(NPAS+1,1);    %Vector de momentos para cada paso de curvatura
KV=zeros(NPAS+1,1);    %Vector de curvaturas de cada paso
EAV=zeros(NPAS+1,1);   %Vector coef. de rigidez EA de cada paso de curvatura
EIXV=zeros(NPAS+1,1);  %Vector coef. de rigidez EI en dirección Y de cada paso de curvatura
EIYV=zeros(NPAS+1,1);  %Vector coef. de rigidez EI en dirección Z de cada paso de curvatura
GJV=zeros(NPAS+1,1);   %Vector coef. de rigidez GJ de cada paso de curvatura
EPZZ=zeros(NELE,NPAS+1);   %Matriz de deformaciones en dirección z
STZZ=zeros(NELE,NPAS+1);   %Matriz de esfuerzos en dirección z
ESTA=zeros(NELE,NPAS+1);   %Matriz del estado del material
E=zeros(NELE,NPAS+1);      %Matriz de módulos secantes

%Determinación de la coordenada y para las fibras extremas
ymax=max(ECA(:,2)); %Coordenada y de la fibra extrema superior
ymin=min(ECA(:,2)); %Coordenada y de la fibra extrema inferior

for IPAS = 1:NPAS+1 %Ciclo de pasos de curvatura
    TEXT = strcat('... paso de curvatura:',int2str(IPAS-1)); TINI = IMTIEM(TEXT,0);
    
    % instrucciones de cálculo para el análisis incremental 
    % -------------------------------------------------------------------------------
    k=-Dk*(IPAS-1); %Valor de curvatura del paso
    yn=CENY;     %Valor inicial del eje neutro
    y1s=ymax;    %Valor necesario para el método de la secante si SFZ>0
    y1i=ymin;    %Valor necesario para el método de la secante si SFZ<0
    FZ=1.1*Tolf; %Valor inicial de la fuerza axial
    ni=1;        %Valor inicial del número de iteraciones para FZ
    
    while FZ>Tolf %Proceso iterativo respecto a la fuerza FZ
        %Control de convergencia
        if ni==100
            fprintf('\nNúmero máximo de iteraciones alcanzado (100 iteraciones)\n')
                fprintf('\nNo fue posible determinar la posición del eje neutro ')
                fprintf('para la carga axial igual a cero \n')
            return
        end      
        [SFZ,SMX,EA,EIX,EIY,GJ,EPZZ,STZZ,ESTA]...
            =SUMF(CAT,MAT,NELE,ECA,ELE,k,yn,IPAS,EPZZ,STZZ,ESTA,E);
       
        FZ=abs(SFZ); %Fuerza equivalente en la sección
        M=SMX;       %Momento equivalente en la sección
        
        if SFZ>Tolf %Sumatoria de fuerzas mayor a la tolerancia +
            %Actualización de valores y cálculo del yn con el método de la secante
            y2s=y1s; %Valor necesario para el punto 2 del método de la secante
            y1s=yn;  %Valor necesario para el punto 1 del método de la secante
            SF1=SFZ; %Valor necesario para el punto 1 del método de la secante
            %Valor necesario para el punto 2 del método de la secante
            [SF2,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,ELE,k,y2s,IPAS,EPZZ,STZZ,ESTA,E);
            yn=y2s-SF2*((y2s-y1s)/(SF2-SF1)); %Nuevo yn por el m. de la secante
        elseif SFZ<-Tolf %Sumatoria de fuerzas menor a la tolerancia -
            %Actualización de valores y cálculo del yn con el método de la secante
            y2i=y1i; %Valor necesario para el punto 2 del método de la secante
            y1i=yn;  %Valor necesario para el punto 1 del método de la secante
            SF1=SFZ; %Valor necesario para el punto 1 del método de la secante
            %Valor necesario para el punto 2 del método de la secante
            [SF2,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,ELE,k,y2i,IPAS,EPZZ,STZZ,ESTA,E);
            yn=y2i-SF2*((y2i-y1i)/(SF2-SF1)); %Nuevo yn por el m. de la secante
        else
        end
        ni=ni+1; %Actualizar el número de iteraciones para FZ
    end %endwhile
    
    if IPAS==1
    else %Para los pasos posteriores al primero, es decir k distinto de 0
        if STZZ(:,IPAS)==0
            fprintf('\nSe ha detenido repentinamente el cálculo en el paso: %i, ',IPAS-1)
            fprintf('para un valor de curvatura de: %g \n',k)
            fprintf('Todas las fibras tienen un esfuerzo normal igual a 0. \n')
            break
        end
    end
    
    %Asignar resultados del paso a los vectores respectivos
    MV(IPAS,1)=M;  %Resultado de momento en dirección x
    KV(IPAS,1)=-k; %Resultado de curvatura
    %Resutados de los coeficientes relacionados con al rigidez
    EAV(IPAS,1)=EA;
    EIXV(IPAS,1)=EIX;
    EIYV(IPAS,1)=EIY;
    GJV(IPAS,1)=GJ;
    
    % tabla de resultados por elemento de un paso
    % -------------------------------------------------------------------------------
    % [ EPZZ STZZ ESTA ]
    
    REL = zeros(NELE,3);
    REL = [EPZZ(:,IPAS),STZZ(:,IPAS),ESTA(:,IPAS)];
    
    % escribir resultados en .pos
    % -------------------------------------------------------------------------------
    STEP = IPAS-1; % el paso en GMSH empieza en 0
    TIME = -k;   % el tiempo en GMSH puede representar otra variable
    IMPREL(FIDE,NELE,NNUE,REL,TIME,STEP);
    
    TFIN = IMTIEM('',TINI);
        
end % endfor IPAS

status = fclose(FIDE); % cierre de archivo .pos
% -----------------------------------------------------------------------------------

% curva de resultados en función del tiempo
% -----------------------------------------------------------------------------------
CUR = zeros(IPAS,2);
% CURVA M-KAPPA
MVT=Ntip.*MV;  %Vector de momentos totales
CUR=[KV,MVT];  %Relación momento total - curvatura

% abrir archivo .pos.opt y escribir curva M-kappa
% -----------------------------------------------------------------------------------
IMPOPT(ADAD,CUR);

% Guardar resultado en archivo .txt y graficar
close                    %Borrar figuras anteriores
figure('Name','MKAPPA1') %Nombrar ventana
plot([KV],[MVT],'-o')
title('M vs Kappa')
grid on
xlabel('Curvatura, 1/m')
ylabel('Momento resultante M, kN-m')

NAME=strcat('DATOS/',ADAT,'.txt'); %Nombre y ubicación del archivo a guardar
save(NAME, 'CUR', '-ascii')        %Guardar el archivo

% mostrar tiempo final
TFIN = IMTIEM('Tiempo total de ejecución del programa ',TINT);
end