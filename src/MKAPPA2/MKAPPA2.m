% -----------------------------------------------------------------------------------
% MKAPPA2: Programa didáctico de análisis no lineal de secciones transversales en
% elementos estructurales a flexión, aplicando el el método de las fibras.
% Fiber model for beam-column elements
% (Kaba & Mahin, 1984; Tausen,Spaco & Filippou, 1991)
% -----------------------------------------------------------------------------------
% Hernán S. Buitrago E.
% Universidad Nacional de Colombia
% Facultad de Ingeniería
% Todos los derechos reservados, 2022

function MKAPPA2 (ADAT,TLEC)
% ADAT: nombre del archivo de entrada de datos sin extensión
% TLEC: identificador de la opción de lectura de datos. Este es un parámetro
%       que por defecto es igual a 0.
% -----------------------------------------------------------------------------------
% presentación inicial en pantalla
clc; % limpiar pantalla
fprintf('----------------------------------------------------------------- \n');
fprintf('       MKAPPA2. Universidad Nacional de Colombia 2022          \n');
fprintf('----------------------------------------------------------------- \n');
% fprintf('=10: opcion habilitada \n');
% fprintf('=11: otras opciones no habilitadas \n');
% fprintf('=12: otras opciones no habilitadas \n');
% fprintf('Si <opciones lectura> se omite adquiere un valor de 10. \n');
% fprintf('------------------------------------------------------------------\n');
% -----------------------------------------------------------------------------------
% control de ausencia de argumentos
if exist('ADAT') == 0
    fprintf('MKAPPA. La funcion requiere <nombre archivo datos>.\n')
    return
end
if exist('TLEC') == 0
    TLEC='10';
    % fprintf('MKAPPA. La funcion tomará por defecto a <opciones lectura>=10.\n')
end
ADAD = strcat('./DATOS/',ADAT);
TLEN = str2num(TLEC);

% adicionar carpetas y tomar tiempo inicial
addpath('./FUNCIONES');
addpath('./DATOS');
TINT = IMTIEM('Inicio de ejecucion del programa \n',0);

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
    
    % construcción de tabla completa de categorías, donde el número de la fila
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
    CENX = SUMX / SUMA;  %Posición en x del centroide 
    CENY = SUMY / SUMA;  %Posición en y del centroide 
    % -------------------------------------------------------------------------------
    
    % Parámetros de análisis
    NPAS = ANA(1); % Número de pasos de curvatura
    Dk   = ANA(2); % Valor del incremento en la curvatura
    Tolf = ANA(3); % Tolerancia del error en la sumatoria de fuerza axial
    thd  = ANA(4); % Ángulo definido de la resultante de momentos
    Tolt = ANA(5); % Tolerancia del error del ángulo theta
    
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
TINI = IMTIEM('Analisis por incrementos de curvatura \n',0);
% -----------------------------------------------------------------------------------

%Inicialización de variables
MV=zeros(NPAS+1,1);    %Vector de momentos para cada paso de curvatura
KV=zeros(NPAS+1,1);    %Vector de curvaturas de cada paso
EAV=zeros(NPAS+1,1);   %Vector coef. de rigidez EA de cada paso de curvatura
EIYV=zeros(NPAS+1,1);  %Vector coef. de rigidez EI en dirección Y de cada paso de curvatura
EIZV=zeros(NPAS+1,1);  %Vector coef. de rigidez EI en dirección Z de cada paso de curvatura
GJV=zeros(NPAS+1,1);   %Vector coef. de rigidez GJ de cada paso de curvatura
EPZZ=zeros(NELE,NPAS+1);   %Matriz de deformaciones en dirección z
STZZ=zeros(NELE,NPAS+1);   %Matriz de esfuerzos en dirección z
ESTA=zeros(NELE,NPAS+1);   %Matriz del estado del material
E=zeros(NELE,NPAS+1);      %Matriz de módulos secantes

%condicional para garantizar un adecuado ángulo theta
if abs(thd)>360
    fprintf('\nError en la definición del ángulo theta \n\n')
    return
elseif thd<0
    thd=thd+360;
    fprintf('\nPara el cálculo se utiliza el ángulo positivo: %i \n\n',thd)
end

for IPAS = 1:NPAS+1 %Ciclo de pasos de curvatura
    TEXT = strcat('... paso de curvatura:',int2str(IPAS-1)); TINI = IMTIEM(TEXT,0);
    
    % instrucciones de cálculo para el análisis incremental 
    % -------------------------------------------------------------------------------
    k=-Dk*(IPAS-1); %Valor de la curvatura alrededor del eje neutro oblicuo
    bls=thd+45;     %Valor inicial del límite superior del método de la bisección
    bli=thd-45;     %Valor inicial del límite inferior del método de la bisección
    Et=1.1*Tolt;    %Valor inicial del error absoluto para theta
    ni=1;           %Valor inicial del número de iteraciones para theta
    
    while Et>Tolt %Proceso iterativo respecto al ángulo theta
        if ni==100 %Control de convergencia
            fprintf('\nNúmero máximo de iteraciones alcanzado (100 iteraciones)')
            fprintf('\nNo fue posible determinar la inclinación del eje neutro ')
            fprintf('para la condición con cargas combinadas\n')
            return
        end
        b=(bls+bli)/2; % Cálculo del ángulo b considerando m. de la bisección
        TR=[cosd(-b) sind(-b);   %Matriz de transformación de coordenadas
            -sind(-b) cosd(-b)]; 
        CROT=ECA(:,1:2)*TR;      %Coordenadas rotadas de cada fibra
        v1max=max(CROT(:,2));    %Fibra extrema superior respecto al sistema rotado
        v1min=min(CROT(:,2));    %Fibra extrema inferior respecto al sistema rotado   
        vn=(v1max+v1min)/2;      %Valor inicial del eje neutro en el sistema rotado
        FZ=1.1*Tolf;             %Valor inicial de la fuerza axial
        nj=1;                    %Valor inicial del número de iteraciones para FZ
        
        while FZ>Tolf %Proceso iterativo respecto a la fuerza FZ
            if nj==100 %Control de convergencia
                fprintf('\nNúmero máximo de iteraciones alcanzado (100 iteraciones)\n')
                fprintf('\nNo fue posible determinar la posición del eje neutro ')
                fprintf('para la carga axial igual a cero \n')
                return
            end
            [SFZ,SMX,SMY,EA,EIY,EIZ,GJ,EPZZ,STZZ,ESTA]...
                =SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,vn,IPAS,EPZZ,STZZ,ESTA,E);
            
            FZ=abs(SFZ); %Fuerza equivalente en la sección
            MX=SMX;      %Momento equivalente en la sección en dirección x
            MY=SMY;      %Momento equivalente en la sección en dirección y
            
            if SFZ>Tolf %Sumatoria de fuerzas mayor a la tolerancia +
                %Actualización de valores y cálculo del yn con el método de la secante
                v2max=v1max; %Valor necesario para el punto 2 del método de la secante
                v1max=vn;    %Valor necesario para el punto 1 del método de la secante
                SF1=SFZ;     %Valor necesario para el punto 1 del método de la secante
                %Valor necesario para el punto 2 del método de la secante
                [SF2,~,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,v2max,IPAS,EPZZ,STZZ,ESTA,E);
                vn=v2max-SF2*((v2max-v1max)/(SF2-SF1)); %Nuevo vn por el m. de la secante
            elseif SFZ<-Tolf %Sumatoria de fuerzas menor a la tolerancia -
                %Actualización de valores y cálculo del yn con el método de la secante
                v2min=v1min; %Valor necesario para el punto 2 del método de la secante
                v1min=vn;    %Valor necesario para el punto 1 del método de la secante
                SF1=SFZ;     %Valor necesario para el punto 1 del método de la secante
                %Valor necesario para el punto 2 del método de la secante
                [SF2,~,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,v2min,IPAS,EPZZ,STZZ,ESTA,E);
                vn=v2min-SF2*((v2min-v1min)/(SF2-SF1)); %Nuevo vn por el m. de la secante
            else
            end
            nj=nj+1; %Actualizar el número de iteraciones para FZ
        end %endwhile FZ>Tolf
        
        %Condicionales para el cálculo adeacuado del ángulo theta
        thn=0;  %Variable que guarda el ángulo negativo (solo para MX>0 y MY<0)
        if k==0 %En el paso 0 no hay curvatura ni momento
            th=thd;
        elseif MX==0 && MY>0
            th=90;  %Momento en dirección x
        elseif MX==0 && MY<0
            th=270; %Momento en dirección -x
        elseif MX==0 && MY==0
            fprintf('\nError en el paso %i para curvatura de %g \n ',IPAS-1,k)
            fprintf('Los momentos en X y en Y son iguales a 0. \n')
            break
        elseif MX>0 && MY>=0     %Momento con dirección dentro del 1er cuadrante 
            th=atand(MY/MX);     %Ángulo theta en el rango [0º - 90º)
        elseif MX<0 && MY>=0     %Momento con dirección dentro del 2do cuadrante
            th=atand(MY/MX)+180; %Ángulo theta en el rango (90º - 180º]
        elseif MX<0 && MY<0      %Momento con dirección dentro del 3er cuadrante
            th=atand(MY/MX)+180; %Ángulo theta en el rango (180º - 270º)
        else  %MX>0 && MY<0      Momento con dirección dentro del 4to cuadrante 
            th=atand(MY/MX)+360; %Ángulo theta en el rango (270º - 360º)
            thn=atand(MY/MX);    %Ángulo theta negativo en el rango (-90º - 0º)
        end
        
        %Condicionales para la actualización de límites
        %Condicional específico para la convergencia cuando thd es cercano a 0.
        if thd<90 && thn<0 
            bli=b; %Actualizar el límite inferior
        %Condicional  específico para la convergencia cuando thd es cercano a 360.
        elseif thd>270 && th<90 
            bls=b; %Actualizar el límite superior
        elseif th<thd
            bli=b; %Actualizar el límite inferior
        else
            bls=b; %Actualizar el límite superior
        end
        Et=abs(th-thd); %Calcular el error absoluto para theta
        ni=ni+1;        %Actualizar el número de iteraciones para theta
              
    end %endwhile Et>Tolt
    
    if IPAS==1
    else %Para los pasos posteriores al primero, es decir k distinto de 0
        if STZZ(:,IPAS)==0
            fprintf('\nSe ha detenido repentinamente el cálculo en el paso: %i, ',IPAS-1)
            fprintf('para un valor de curvatura de: %g \n',k)
            break
        end
    end
    %Asignar resultados del paso de curvatura a los vectores respectivos
    M=(MX^2+MY^2)^(1/2); %Calcular la magnitud del momento resultante
    MV(IPAS,1)=M;     %Resultado de momento en dirección del ángulo theta
    KV(IPAS,1)=-k;    %Resultado de curvatura
    B(IPAS,1)=b;      %Resultado de inclinación del eje neutro
    %Resutados de los coeficientes relacionados con al rigidez
    EAV(IPAS,1)=EA;   
    EIYV(IPAS,1)=EIY;
    EIZV(IPAS,1)=EIZ;
    GJV(IPAS,1)=GJ;
    % tabla de resultados por elemento de un paso
    % -------------------------------------------------------------------------------
    % [ EPZZ STZZ ESTA ]
    
    REL = zeros(NELE,3);
    REL = [EPZZ(:,IPAS),STZZ(:,IPAS),ESTA(:,IPAS)];
    
    % escribir resultados en .pos
    % -------------------------------------------------------------------------------
    STEP = IPAS-1; % el paso en GMSH empieza en 0
    TIME = -k;     % el tiempo en GMSH puede representar otra variable
    IMPREL(FIDE,NELE,NNUE,REL,TIME,STEP);
    
    TFIN = IMTIEM('',TINI);

end % endfor IPAS

status = fclose(FIDE); % cierre de archivo .pos
% -----------------------------------------------------------------------------------

% curva de resultados en función del tiempo
% -----------------------------------------------------------------------------------
CUR = zeros(IPAS,2);
% CURVA M-KAPPA
CUR=[KV,MV]; %Relación momento resultante - curvatura

% abrir archivo .pos.opt y escribir curva M-kappa
% -----------------------------------------------------------------------------------
IMPOPT(ADAD,CUR);

% Guardar resultado en archivo .txt y graficar
close                    %Borrar figuras anteriores
figure('Name','MKAPPA2') %Nombrar ventana
plot([KV],[MV],'-o')
title('M vs Kappa')
grid on
xlabel('Curvatura, 1/m')
ylabel('Momento resultante M, kN-m')

NAME=strcat('DATOS/',ADAT,'.txt'); %Nombre y ubicación del archivo a guardar
save(NAME, 'CUR', '-ascii')        %Guardar el archivo

% mostrar tiempo final
TFIN = IMTIEM('Tiempo total de ejecucion del programa ',TINT);
end