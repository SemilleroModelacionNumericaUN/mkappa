% -----------------------------------------------------------------------------------
% MKAPPAF: Programa didáctico de análisis no lineal de secciones transversales en
% elementos estructurales a flexión y fuerza axial, aplicando el el método de las 
% fibras.
% Fiber model for beam-column elements
% (Kaba & Mahin 1984; Tausen,Spaco & Filippou, 1991)
% -----------------------------------------------------------------------------------
% Hernán S. Buitrago E.
% Universidad Nacional de Colombia
% Facultad de Ingeniería
% Todos los derechos reservados, 2022

function MKAPPAF (ADAT,TLEC)
% ADAT: nombre del archivo de entrada de datos sin extensión
% TLEC: identificador de la opción de lectura de datos. Este es un parámetro
%       que por defecto es igual a 0.
% -----------------------------------------------------------------------------------
% presentación inicial en pantalla
clc; % limpiar pantalla
fprintf('----------------------------------------------------------------- \n');
fprintf('       MKAPPAF. Universidad Nacional de Colombia 2022          \n');
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
    
    % Parámetro de análisis
    % -------------------------------------------------------------------------------
    NPAS = ANA(1); % Número de pasos de curvatura
    dcur = ANA(2); % Valor de los intervalos de la curvatura
    Beta = ANA(3); % Ángulo (beta) de la inclinación del eje neutro
    Faxz = ANA(4); % Fuerza axial sobre el elemento en dirección Z
    Tolf = ANA(5); % Tolerancia del error en la sumatoria de fuerza axial como fracción de la carga axial
    PosN = ANA(6); % Posición de la fuerza axial resultante
    Bili = ANA(7); % Parámetro que activa la obtención de la curva bilineal
    Mrep = ANA(8); % Indicador del momento representado
    % -------------------------------------------------------------------------------
    
    % Control de ingreso de parámetros
    % -------------------------------------------------------------------------------
    %Control de ANA(1)
    if NPAS<1 
        fprintf(2,'\nError en la definición del número de incrementos de curvatura ')
        fprintf(2,'\nEl valor debe ser un número entero positivo \n\n')
        return
    end
    if mod(NPAS,1)~=0
        fprintf(2,'\nError en la definición del número de incrementos de curvatura ')
        fprintf(2,'\nEl valor debe ser un número entero positivo \n\n')
        return
    end
    
    %Control de ANA(2)
    if dcur<0
        fprintf(2, '\nError en la definición del valor de los intervalos de curvatura ')
        fprintf(2, '\nEl valor debe ser positivo \n\n')
        return
    elseif dcur>1
        fprintf('\nAdvertencia: el valor de lo intervalos de curvatura es muy grande (mayor a 1/m)\n\n')
    end
    
%     %Control de ANA(3)
%     if Ndef<1
%         fprintf(2, '\nError en la definición del número de incrementos de deformación axial ')
%         fprintf(2,'\nEl valor debe ser un número entero positivo \n\n')
%         return
%     end
%     if mod(Ndef,1)~=0
%         fprintf(2,'\nError en la definición del número de incrementos de deformación axial ')
%         fprintf(2,'\nEl valor debe ser un número entero positivo \n\n')
%         return
%     end
%     
%     %Control de ANA(4)
%     if Ndef>1 && dcur==0
%         fprintf(2, '\nError en la definición del valor de los intervalos de deformación axial ')
%         fprintf(2, '\nEl valor no puede ser 0 \n\n')
%         return
%     end
%     
%     %Control de ANA(5)
%     if abs(thed)>360
%         fprintf(2,'\nError en la definición del ángulo theta \n\n')
%         return
%     elseif thed<0
%         thed=thed+360;
%         fprintf('\nPara el cálculo se utiliza el ángulo positivo: %i \n\n',thed)
%     end
%     
%     %Control de ANA(6)
%     if Tolt>1
%         fprintf('\nAdvertencia: el valor de tolerancia para el ángulo theta puede ser muy grande (mayor a 1º)\n\n')
%     elseif Tolt<0.000001
%         fprintf('\nAdvertencia: el valor de tolerancia para el ángulo theta puede ser muy pequeño (menor a 1E-6º)\n\n')
%     end
%         
%     %Control de ANA(7)
%     if Tolf>1
%         fprintf('\nAdvertencia: el valor de tolerancia para la fuerza axial puede ser muy grande (mayor a 1 kN)\n\n')
%     elseif Tolf<0.000001
%         fprintf('\nAdvertencia: el valor de tolerancia para la fuerza axial puede ser muy pequeño (menor a 1E-6 Kn)\n\n')
%     end

    %Determinación de la posición de la resultante de fuerza axial y control del parámetro
    % -------------------------------------------------------------------------------
    switch PosN
        case 1 %En el Centroide
            [POSX,POSY,ECA]=CENT(NNUE,NELE,ELE,XYZ);
            
        case 2 %En el Centro Ponderado por el Módulo de Elasticidad Inicial
            [POSX,POSY,ECA]=CPMEI(MAT,CAT,NNUE,NELE,ELE,XYZ,ANA);
            
        case 3 %En el punto variable donde la carga axial no produce momento
            [POSX,POSY,ECA]=CPMEI(MAT,CAT,NNUE,NELE,ELE,XYZ,ANA);
            
        case 4 %En un punto fijo definido por el usuario
            [~,~,ECA]=CENT(NNUE,NELE,ELE,XYZ);
            POSX=PX; POSY=PY;
        otherwise
            fprintf(2,'\nError en la definición del parámetro ANA(8) \n\n')
            return
    end
    
    fprintf('Malla de %g nudos, %g elementos,\n',NNUD,NELE);
    fprintf('%g pasos de curvatura y %g kN de carga axial',NPAS,Faxz)
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

%% ----------------------------------------------------------------------------------
% Inicialización de variables
% -----------------------------------------------------------------------------------
MV=zeros(NPAS+1,1);    %Vector de momentos para cada paso de curvatura
KV=zeros(NPAS+1,1);    %Vector de curvaturas de cada paso
TV=zeros(NPAS+1,1);    %Vector de ángulos theta de los momentos resultantes
EAV=zeros(NPAS+1,1);   %Vector coef. de rigidez EA de cada paso de curvatura
EIYV=zeros(NPAS+1,1);  %Vector coef. de rigidez EI en dirección Y de cada paso de curvatura
EIZV=zeros(NPAS+1,1);  %Vector coef. de rigidez EI en dirección Z de cada paso de curvatura
GJV=zeros(NPAS+1,1);   %Vector coef. de rigidez GJ de cada paso de curvatura
EPZZ=zeros(NELE,NPAS+1);   %Matriz de deformaciones en dirección z
STZZ=zeros(NELE,NPAS+1);   %Matriz de esfuerzos en dirección z
ESTA=zeros(NELE,NPAS+1);   %Matriz del estado del material
ESEC=zeros(NELE,NPAS+1);   %Matriz de módulos secantes

pf=0;               %Parámetro de control para la primera fluencia
cf=0;               %Parámetro de control para el criterio de falla
if Bili==1
    npf=0;        %Número de pasos a la primera fluencia
    kp=0;         %Curvatura a la primera fluencia
    Mp=0;         %Momento a la primera fluencia
    ncf=0;        %Número de pasos al criterio de falla
    ku=0;         %Curvatura al criterio de falla
    Mu=0;         %Momento al criterio de falla
    not=0;              %Parámetro de control para la notificación en pantalla
end

%% ----------------------------------------------------------------------------------
% Análisis por incrementos de curvatura con fuerza axial constante
TINI = IMTIEM('Análisis por incrementos de curvatura con fuerza axial constante\n',0);
% -----------------------------------------------------------------------------------

    for IPAS = 1:NPAS+1 %Ciclo de pasos de curvatura
        TEXT = strcat('... paso de curvatura:',int2str(IPAS-1)); TINI = IMTIEM(TEXT,0);
        k=-dcur*(IPAS-1); %Valor de la curvatura alrededor del eje neutro oblicuo
        b=Beta;           %Ángulo (beta) de la inclinación del eje neutro
        if IPAS==1
            [e]=DAI(ANA,MAT,NELE,CAT,ELE,ECA);
            EF=1.1*Tolf;
            ni=1;
            while EF>Tolf
                if ni==100 %Control de convergencia
                    fprintf('\nNúmero máximo de iteraciones alcanzado (100 iteraciones)')
                    fprintf('\nNo fue posible determinar la deformación axial del paso %i\n',0)
                    fprintf('para la fuerza axial de %g kN.\n',Faxz)
                    return
                end
                [SFZ,SMX,SMY,EA,EIY,EIZ,GJ,EPZZ,STZZ,ESTA,ESEC]...
                    =SUMF0(CAT,MAT,NELE,ECA,ELE,e,EPZZ,STZZ,ESTA,ESEC);

                FZ=SFZ;
                DF=Faxz-FZ;
                EF=abs(DF);
                De=DF/(1000*EA);         
                if EF>Tolf %Sumatoria de fuerzas mayor a la tolerancia +
                    %Actualización de valores y cálculo del e con el método de la secante
                    e1=e;
                    DF1=DF;
                    e2=e+De;
                    %Valor necesario para el punto 2 del método de la secante
                    [SF2,~,~,~,~,~,~,~,~,~,~]=SUMF0(CAT,MAT,NELE,ECA,ELE,e2,EPZZ,STZZ,ESTA,ESEC);
                    DF2=Faxz-SF2;
                    e=e2-DF2*((e2-e1)/(DF2-DF1)); %Nuevo vn por el m. de la secante
                else
                end %endif
                ni=ni+1; %Actualizar el número de iteraciones para FZ
            end %endwhile
        else
            TR=[cosd(b) -sind(b);   %Matriz de transformación de coordenadas
                sind(b) cosd(b)];
            CROT=ECA(:,1:2)*TR;      %Coordenadas rotadas de cada fibra
            v1max=max(CROT(:,2));    %Fibra extrema superior respecto al sistema rotado
            v1min=min(CROT(:,2));    %Fibra extrema inferior respecto al sistema rotado
            vn=(v1max+v1min)/2;      %Distancia inicial al eje neutro en flexión pura
            F0=1.1*Tolf;             %Valor inicial de la fuerza axial
            ni=1;                    %Valor inicial del número de iteraciones para F0
            
            while F0>Tolf %Proceso iterativo respecto a la fuerza F0
                if ni==100 %Control de convergencia
                    fprintf('\nNúmero máximo de iteraciones alcanzado (100 iteraciones)')
                    fprintf('\nNo fue posible determinar la posición del eje neutro ')
                    fprintf('para la condición de flexión pura \n')
                    return
                end
                [SFZ,~,~,~,~,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,vn,IPAS,EPZZ,STZZ,ESTA,ESEC);
                
                F0=abs(SFZ); %Fuerza equivalente en la sección a flexión pura
                
                if SFZ>Tolf %Sumatoria de fuerzas mayor a la tolerancia +
                    %Actualización de valores y cálculo del yn con el método de la secante
                    v2max=v1max; %Valor necesario para el punto 2 del método de la secante
                    v1max=vn;    %Valor necesario para el punto 1 del método de la secante
                    SF1=SFZ;     %Valor necesario para el punto 1 del método de la secante
                    %Valor necesario para el punto 2 del método de la secante
                    [SF2,~,~,~,~,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,v2max,IPAS,EPZZ,STZZ,ESTA,ESEC);
                    vn=v2max-SF2*((v2max-v1max)/(SF2-SF1)); %Nuevo vn por el m. de la secante
                elseif SFZ<-Tolf %Sumatoria de fuerzas menor a la tolerancia -
                    %Actualización de valores y cálculo del yn con el método de la secante
                    v2min=v1min; %Valor necesario para el punto 2 del método de la secante
                    v1min=vn;    %Valor necesario para el punto 1 del método de la secante
                    SF1=SFZ;    %Valor necesario para el punto 1 del método de la secante
                    %Valor necesario para el punto 2 del método de la secante
                    [SF2,~,~,~,~,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,v2min,IPAS,EPZZ,STZZ,ESTA,ESEC);
                    vn=v2min-SF2*((v2min-v1min)/(SF2-SF1)); %Nuevo vn por el m. de la secante
                else
                end
                ni=ni+1; %Actualizar el número de iteraciones para FZ
            end %endwhile FZ>Tolf
            EF=1.1*Tolf;
            ni=1;
            while EF>Tolf %Proceso iterativo respecto a la fuerza FZ
                if ni==10 %Control de convergencia
                    fprintf('\nNúmero máximo de iteraciones alcanzado (100 iteraciones)')
                    fprintf('\nNo fue posible determinar la inclinación del eje neutro ')
                    fprintf('para la condición con cargas combinadas\n')
                    return
                end
                vnc=vn+e/k;
                
                [SFZ,SMX,SMY,EA,EIY,EIZ,GJ,EPZZ,STZZ,ESTA,ESEC,X,Y]...
                    =SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,vnc,IPAS,EPZZ,STZZ,ESTA,ESEC);

                FZ=SFZ;      %Fuerza equivalente en la sección en dirección z
                DF=Faxz-FZ;
                EF=abs(DF);
                De=DF/(1000*EAV(IPAS-1,1));
                if EF>Tolf %Sumatoria de fuerzas mayor a la tolerancia +
                    %Actualización de valores y cálculo del e con el método de la secante
                    e1=e;
                    DF1=DF;
                    e2=e+De;
                    vn2=vn+e2/k;
                    %Valor necesario para el punto 2 del método de la secante
                    [SF2,~,~,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,vn2,IPAS,EPZZ,STZZ,ESTA,ESEC);
                    DF2=Faxz-SF2;
                    e=e2-DF2*((e2-e1)/(DF2-DF1)); %Nuevo vn por el m. de la secante
                else
                end %endif
                ni=ni+1; %Actualizar el número de iteraciones para FZ
            end %endwhile                    %Valor inicial del número de iteraciones para F0
            
            if PosN==3  %Actualizar los valores de POSX y POSY
                POSX=X; %Posición en x de la resultante de fuerza axial
                POSY=Y; %Posición en y de la resultante de fuerza axial
            end
            
        end %endif Icur
            MX=SMX-FZ*POSY; %Momento equivalente en la sección en dirección x
            MY=SMY+FZ*POSX; %Momento equivalente en la sección en dirección y
            M1=MX*cosd(b)+MY*sind(b);  %Momento alrededor del eje neutro
            M2=-MX*sind(b)+MY*cosd(b); %Momento alrededor del eje perpendicular al eje neutro
            M=(MX^2+MY^2)^(1/2); %Momento resultante en la sección
            
            %Selección del momento representado
            switch Mrep
                case 1
                    MR=M1;
                    rep="Momento alrededor del EN, kN-m";
                case 2
                    MR=M2;
                    rep="Momento alrededor del eje perpen. al EN, kN-m";
                case 3                    
                    MR=M;
                    rep="Momento resultante en dirección theta, kN-m";
                case 4
                    MR=MX;
                    rep="Momento alrededor del eje x, kN-m";
                case 5
                    MR=MY;
                    rep="Momento alrededor del eje y, kN-m";
            end 
            
            %Condicionales para el cálculo adeacuado del ángulo theta
            if MX==0 && MY>0
                th=90;   %Momento en dirección x
            elseif MX==0 && MY<0
                th=270;  %Momento en dirección -x
            elseif MX==0 && MY==0
                th=0/0; %No Aplica, ya que no hay momento
            elseif MX>0 && MY>=0     %Momento con dirección dentro del 1er cuadrante
                th=atand(MY/MX);     %Ángulo theta en el rango [0º - 90º)
            elseif MX<0 && MY>=0     %Momento con dirección dentro del 2do cuadrante
                th=atand(MY/MX)+180; %Ángulo theta en el rango (90º - 180º]
            elseif MX<0 && MY<0      %Momento con dirección dentro del 3er cuadrante
                th=atand(MY/MX)+180; %Ángulo theta en el rango (180º - 270º)
            else  %MX>0 && MY<0      Momento con dirección dentro del 4to cuadrante
                th=atand(MY/MX)+360; %Ángulo theta en el rango (270º - 360º)
            end
            
            if Bili==1
                %Control para determinar la curvatura a primera fluencia
                if pf==0
                    if max(ESTA(:,IPAS)==3)==1 %Comprobar ablandamiento en el concreto inconfinado
                        pf=1;             %Establecer que ha ocurrido la primera fluencia
                        npf=IPAS; %Guardar el paso donde ocurrió la primera fluencia
                        kp=-k;    %Guardar la curvatura de primera fluencia
                        Mp=MR;     %Guardar el momento de primera fluencia
                    elseif max(ESTA(:,IPAS)==7)==1 %Comprobar ablandamiento en el concreto confinado
                        pf=1;             %Establecer que ha ocurrido la primera fluencia
                        npf=IPAS; %Guardar el paso donde ocurrió la primera fluencia
                        kp=-k;    %Guardar la curvatura de primera fluencia
                        Mp=MR;     %Guardar el momento de primera fluencia
                    elseif max(ESTA(:,IPAS)==10)==1 %Comprobar fluencia a tensión en el acero
                        pf=1;             %Establecer que ha ocurrido la primera fluencia
                        npf=IPAS; %Guardar el paso donde ocurrió la primera fluencia
                        kp=-k;    %Guardar la curvatura de primera fluencia
                        Mp=MR;     %Guardar el momento de primera fluencia
                    elseif max(ESTA(:,IPAS)==14)==1 %Comprobar fluencia a compresión en el acero
                        pf=1;             %Establecer que ha ocurrido la primera fluencia
                        npf=IPAS; %Guardar el paso donde ocurrió la primera fluencia
                        kp=-k;    %Guardar la curvatura de primera fluencia
                        Mp=MR;     %Guardar el momento de primera fluencia
                    end
                end %endif pf
                
                %Control para determinar la curvatura al criterio de falla
                if cf==0
                    if max(ESTA(:,IPAS)==4)==1
                        cf=1;             %Establecer que se ha alcanzado el criterio de falla
                        ncf=IPAS; %Guardar el paso donde se alcanzó el criterio de falla
                        ku=-k;    %Guardar la curvatura última de falla
                        Mu=MR;     %Guardar el momento último de falla
                        crit="Se ha alcanzado el criterio de falla en el concreto inconfinado";
                        mfalla="Concreto inconfinado";
                    elseif max(ESTA(:,IPAS)==8)==1
                        cf=1;             %Establecer que se ha alcanzado el criterio de falla
                        ncf=IPAS; %Guardar el paso donde se alcanzó el criterio de falla
                        ku=-k;    %Guardar la curvatura última de falla
                        Mu=MR;     %Guardar el momento último de falla
                        crit="Se ha alcanzado el criterio de falla en el concreto confinado";
                        mfalla="Concreto confinado";
                    elseif max(ESTA(:,IPAS)==12)==1
                        cf=1;             %Establecer que se ha alcanzado el criterio de falla
                        ncf=IPAS; %Guardar el paso donde se alcanzó el criterio de falla
                        ku=-k;    %Guardar la curvatura última de falla
                        Mu=MR;     %Guardar el momento último de falla
                        crit="Se ha alcanzado el criterio de falla en el acero a tensión";
                        mfalla="Acero en tensión";
                    elseif max(ESTA(:,IPAS)==16)==1
                        cf=1;             %Establecer que se ha alcanzado el criterio de falla
                        ncf=IPAS; %Guardar el paso donde se alcanzó el criterio de falla
                        ku=-k;    %Guardar la curvatura última de falla
                        Mu=MR;     %Guardar el momento último de falla
                        crit="Se ha alcanzado el criterio de falla en el acero a compresión";
                        mfalla="Acero en compresión";
                    end
                end %endif cf
            end %endif Bili
            
        %Asignar resultados del paso de curvatura a los vectores respectivos
        MV(IPAS,1)=MR;     %Resultado de momento en dirección del ángulo theta
        KV(IPAS,1)=-k;    %Resultado de curvatura
        TV(IPAS,1)=th;    %ResulTado de ángulo theta
        %Resutados de los coeficientes relacionados con al rigidez
        EAV(IPAS,1)=EA;
        EIYV(IPAS,1)=EIY;
        EIZV(IPAS,1)=EIZ;
        GJV(IPAS,1)=GJ;
        
        % tabla de resultados por elemento de un paso
        % ---------------------------------------------------------------------------
        % [ EPZZ STZZ ESTA ]
        
        REL = zeros(NELE,3);
        REL = [EPZZ(:,IPAS),STZZ(:,IPAS),ESTA(:,IPAS)];
        
        % escribir resultados en .pos
        % ---------------------------------------------------------------------------
        STEP = IPAS-1; % paso de curvatura (en GMSH empieza en 0)
        TIME = -k;     % el tiempo en GMSH puede representar otra variable
        IMPREL(FIDE,NELE,NNUE,REL,TIME,STEP);
        
        TFIN = IMTIEM('',TINI);
    
        if (IPAS>=2) && (max(STZZ(:,2)~=0)==0) %Control de fallo súbito de la sección
            fprintf('\nSe ha detenido repentinamente el cálculo en el paso: %i, ',IPAS-1)
            fprintf('para un valor de curvatura de: %g \n',k)
            fprintf('Todas las fibras tienen un esfuerzo normal igual a 0. \n')
            break
        end
        
        if Bili==1 && cf==1 && not==0 %Mostrar si se ha alcanzado el criterio de falla
            if IPAS==NPAS
            fprintf('\n%s', crit)    
            fprintf('. \n')
            else
            fprintf('    Advertencia: ')
            fprintf(crit) 
            fprintf('. \n')    
            end
            not=1;
        end
        
    end % endfor IPAS

status = fclose(FIDE); % cierre de archivo .pos

fprintf('Fin del análisis \n\n')

if Bili==1 && cf==0 %Mostrar si no se ha alcanzado el criterio de falla
    fprintf('Advertencia: no se ha podido realizar el proceso de bilinealización\n')
    fprintf('No se ha alcanzado el criterio de falla en ningún material\n')
    fprintf('para los %i incrementos de curvatura. \n\n',NPAS-1)
end

%% ----------------------------------------------------------------------------------
% curva de resultados en función del tiempo
% -----------------------------------------------------------------------------------
% Relación M-KAPPA
CUR=[KV,MV];
%% ----------------------------------------------------------------------------------
% abrir archivo .pos.opt y escribir curva M-kappa
% -----------------------------------------------------------------------------------
IMPOPT(ADAD,CUR);

%% ----------------------------------------------------------------------------------
% Proceso de bilinealización
% -----------------------------------------------------------------------------------
GB=0;
if Bili==1 && cf==1 && (PosN==2 || PosN==3)
    fprintf('... proceso de bilinealización')
    GB=1;
    A=0;
    for i=2:ncf
        A=A+(KV(i,1)-KV(i-1,1))*(MV(i,1)+MV(i-1,1))/2;
    end
    m=Mp/kp;
    ke=(2*A-ku*Mu)/(m*ku-Mu);
    Me=m*ke;
    KB=[0; ke; ku];
    MB=[0; Me; Mu];
    
    ker=round(ke*10/dcur)*dcur/10;
    Mer=round(Me,2);
    Mur=round(Mu,2);
    
    fprintf('\n    El momento de fluencia efectiva es igual a %g \n',Mer)
    fprintf('    para una curvatura de fluencia efectiva igual a %g \n',ker)
    fprintf('    El momento de falla es igual a %g \n',Mur)
    fprintf('    para una curvatura de falla igual a %g \n\n',ku)
    
end
%% ----------------------------------------------------------------------------------
% Creación del gráfico Momento-curvatura
% -----------------------------------------------------------------------------------
close                   %Borrar figuras anteriores
figure('Name','MKAPPAF')%Nombrar ventana
hold on

plot(KV,MV,'-*','Color','b')
if pf==1
    plot(KV(npf,1),MV(npf,1),'-d','MarkerEdgeColor','g','MarkerFaceColor','g')
end
if cf==1
    plot(KV(ncf,1),MV(ncf,1),'-d','MarkerEdgeColor','r','MarkerFaceColor','r')
end
if GB==1    
    plot(KB,MB,'Color','r')
    dim = [0 0.125 0.895 0];
    str = {'Fuerza axial constante:', [num2str(Faxz) ' kN'],...
        'Inclinación del eje neutro:', [num2str(Beta) 'º'], ...
        'Material que falla:',mfalla, ...
        'Curvatura de fluencia efectiva:', [num2str(ker) ' 1/m'], ...
        'Momento de fluencia efectiva:', [num2str(Mer) ' kN-m'], ...
        'Curvatura de falla:', [num2str(ku) ' 1/m'], ...
        'Momento de falla:', [num2str(Mur) ' kN-m']};
    annotation('textbox',dim,'String',str,'FitBoxToText','on',...
    'VerticalAlignment','bottom','HorizontalAlignment','right',...
    'BackgroundColor','w');
end
title('M vs Kappa')
grid on
xlabel('Curvatura, 1/m')
ylabel(rep)

hold off

if Mrep==3
    figure('Name','MKAPPAF')
    plot(KV(2:NPAS+1,1),TV(2:NPAS+1,1),'-*','Color','b')
    title('theta vs Kappa')
    grid on
    xlabel('Curvatura, 1/m')
    ylabel('Dirección del momento resultante, º')
    
end

%% ----------------------------------------------------------------------------------
% Exportar resultados de la curva M-kappa en archivo .txt
% -----------------------------------------------------------------------------------
RESUL=[KV , MV];
NAME=strcat('DATOS/',ADAT,'.txt');
save(NAME, 'RESUL', '-ascii')

%% ----------------------------------------------------------------------------------
% mostrar tiempo final
TFIN = IMTIEM('Tiempo total de ejecucion del programa ',TINT);
end