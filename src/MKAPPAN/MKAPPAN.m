% -----------------------------------------------------------------------------------
% MKAPPAN: Programa didáctico de análisis no lineal de secciones transversales en
% elementos estructurales a flexión y fuerza axial, aplicando el el método de las 
% fibras.
% Fiber model for beam-column elements
% (Kaba & Mahin 1984; Tausen,Spaco & Filippou, 1991)
% -----------------------------------------------------------------------------------
% Hernán S. Buitrago E.
% Universidad Nacional de Colombia
% Facultad de Ingeniería
% Todos los derechos reservados, 2022

function MKAPPAN (ADAT,TLEC)
% ADAT: nombre del archivo de entrada de datos sin extensión
% TLEC: identificador de la opción de lectura de datos. Este es un parámetro
%       que por defecto es igual a 0.
% -----------------------------------------------------------------------------------
% presentación inicial en pantalla
clc; % limpiar pantalla
fprintf('----------------------------------------------------------------- \n');
fprintf('       MKAPPAN. Universidad Nacional de Colombia 2022          \n');
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
    Ncur = ANA(1)+1; % Número de pasos de curvatura
    dcur = ANA(2); % Valor de los intervalos de la curvatura
    Ndef = ANA(3)+1; % Número de pasos de deformación axial
    ddef = ANA(4); % Valor de los intervalos de deformación axial
    thed = ANA(5); % Ángulo (theta) definido de la resultante de momentos
    Tolt = ANA(6); % Tolerancia del error del ángulo theta
    Tolf = ANA(7); % Tolerancia del error en la sumatoria de fuerza axial
    PosN = ANA(8); % Posición de la fuerza axial resultante
    % -------------------------------------------------------------------------------
    
    % Control de ingreso de parámetros
    % -------------------------------------------------------------------------------
    %Control de ANA(1)
    if Ncur<1 
        fprintf(2,'\nError en la definición del número de incrementos de curvatura ')
        fprintf(2,'\nEl valor debe ser un número entero positivo \n\n')
        return
    end
    if mod(Ncur,1)~=0
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
    
    %Control de ANA(3)
    if Ndef<1
        fprintf(2, '\nError en la definición del número de incrementos de deformación axial ')
        fprintf(2,'\nEl valor debe ser un número entero positivo \n\n')
        return
    end
    if mod(Ndef,1)~=0
        fprintf(2,'\nError en la definición del número de incrementos de deformación axial ')
        fprintf(2,'\nEl valor debe ser un número entero positivo \n\n')
        return
    end
    
    %Control de ANA(4)
    if Ndef>1 && dcur==0
        fprintf(2, '\nError en la definición del valor de los intervalos de deformación axial ')
        fprintf(2, '\nEl valor no puede ser 0 \n\n')
        return
    end
    
    %Control de ANA(5)
    if abs(thed)>360
        fprintf(2,'\nError en la definición del ángulo theta \n\n')
        return
    elseif thed<0
        thed=thed+360;
        fprintf('\nPara el cálculo se utiliza el ángulo positivo: %i \n\n',thed)
    end
    
    %Control de ANA(6)
    if Tolt>1
        fprintf('\nAdvertencia: el valor de tolerancia para el ángulo theta puede ser muy grande (mayor a 1º)\n\n')
    elseif Tolt<0.000001
        fprintf('\nAdvertencia: el valor de tolerancia para el ángulo theta puede ser muy pequeño (menor a 1E-6º)\n\n')
    end
        
    %Control de ANA(7)
    if Tolf>1
        fprintf('\nAdvertencia: el valor de tolerancia para la fuerza axial puede ser muy grande (mayor a 1 kN)\n\n')
    elseif Tolf<0.000001
        fprintf('\nAdvertencia: el valor de tolerancia para la fuerza axial puede ser muy pequeño (menor a 1E-6 Kn)\n\n')
    end

    %Determinación de la posición de la resultante de fuerza axial y control del parámetro
    % -------------------------------------------------------------------------------
    switch PosN
        case 1 %En el Centroide
            [POSX,POSY,ECA]=CENT(NNUE,NELE,ELE,XYZ);
            
        case 2 %En el Centro Ponderado por el Módulo de Elasticidad Inicial
            [POSX,POSY,ECA]=CPMEI(MAT,CAT,NNUE,NELE,ELE,XYZ,ANA);
            
        case 3 %En el punto variable donde la carga axial no produce momento
            [POSX0,POSY0,ECA]=CPMEI(MAT,CAT,NNUE,NELE,ELE,XYZ,ANA);
            
        case 4 %En un punto fijo definido por el usuario
            [~,~,ECA]=CENT(NNUE,NELE,ELE,XYZ);
            POSX=PX; POSY=PY;
        otherwise
            fprintf(2,'\nError en la definición del parámetro ANA(8) \n\n')
            return
    end
    
    fprintf('Malla de %g nudos, %g elementos,\n',NNUD,NELE);
    fprintf('%g pasos de curvatura y %g paso(s) de deformación axial',Ncur,Ndef)
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
npf=zeros(1,Ndef);        %Vector de los números de pasos a la primera fluencia
kp=zeros(1,Ndef);         %Vector de curvaturas a la primera fluencia
Mp=zeros(1,Ndef);         %Vector de momentos a la primera fluencia
ncf=zeros(1,Ndef);        %Vector de los números de pasos al criterio de falla
ku=zeros(1,Ndef);         %Vector de curvaturas al criterio de falla
Mu=zeros(1,Ndef);         %Vector de momentos al criterio de falla
ENV=zeros(Ndef,1);        %Vector de deformaciones axiales
NV=zeros(Ncur,1,Ndef);    %Arreglo de fuerzas axiales para cada paso de curvatura
MV=zeros(Ncur,1,Ndef);    %Arreglo de momentos para cada paso de curvatura
KV=zeros(Ncur,1,Ndef);    %Arreglo de curvaturas de cada paso
EAV=zeros(Ncur,1,Ndef);   %Arreglo coef. de rigidez EA de cada paso de curvatura
EIYV=zeros(Ncur,1,Ndef);  %Arreglo coef. de rigidez EI en dirección Y de cada paso de curvatura
EIZV=zeros(Ncur,1,Ndef);  %Arreglo coef. de rigidez EI en dirección Z de cada paso de curvatura
GJV=zeros(Ncur,1,Ndef);   %Arreglo coef. de rigidez GJ de cada paso de curvatura
EPZZ=zeros(NELE,Ncur,Ndef);   %Arreglo de deformaciones en dirección z
STZZ=zeros(NELE,Ncur,Ndef);   %Arreglo de esfuerzos en dirección z
ESTA=zeros(NELE,Ncur,Ndef);   %Arreglo del estado del material
ESEC=zeros(NELE,Ncur,Ndef);   %Arreglo de módulos secantes

%% ----------------------------------------------------------------------------------
% Análisis por incrementos de deformación y curvatura
TINI = IMTIEM('Analisis por incrementos de deformación y curvatura',0);
% -----------------------------------------------------------------------------------
for Idef = 1:Ndef %Ciclo de pasos de deformación axial
    TEXT = strcat('\nPaso de deformación axial:',int2str(Idef-1),'\n'); TINI = IMTIEM(TEXT,0);
    
    MEPZZ=zeros(NELE,Ncur);   %Matriz de deformaciones en dirección z
    MSTZZ=zeros(NELE,Ncur);   %Matriz de esfuerzos en dirección z
    MESTA=zeros(NELE,Ncur);   %Matriz del estado del material
    MESEC=zeros(NELE,Ncur);   %Matriz de módulos secantes
    
    e=ddef*(Idef-1); %Valor de la deformación axial
    
    pf=0;               %Parámetro de control para la primera fluencia
    npf(1,Idef)=Ncur;   %Variable inicial para el paso de primera fluencia
    cf=0;               %Parámetro de control para el criterio de falla
    
    if PosN==3          %Reestablecer los valores de POSX y POSY para cada incremento de deformación 
        POSX=POSX0;
        POSY=POSY0;
    end
    
    for Icur = 1:Ncur %Ciclo de pasos de curvatura
        TEXT = strcat('... paso de curvatura:',int2str(Icur-1)); TINI = IMTIEM(TEXT,0);
        if Icur==1
            k=0;    %Curvatura para el paso 0
            b=thed; %Ángulo beta para el paso 0 (definido por fines computacionales)
            [SFZ,SMX,SMY,EA,EIY,EIZ,GJ,MEPZZ,MSTZZ,MESTA,MESEC]...
                =SUMF0(CAT,MAT,NELE,ECA,ELE,e,MEPZZ,MSTZZ,MESTA,MESEC);
            NZ=SFZ;              %Fuerza equivalente en la sección
            MX=SMX-NZ*POSY;      %Momento equivalente en la sección en dirección x
            MY=SMY+NZ*POSX;      %Momento equivalente en la sección en dirección y
            M=(MX^2+MY^2)^(1/2); %Cálculo de la magnitud del momento resultante
        else
            k=-dcur*(Icur-1); %Valor de la curvatura alrededor del eje neutro oblicuo
            Et=1.1*Tolt;      %Valor inicial del error absoluto para theta
            ni=1;             %Valor inicial del número de iteraciones para theta
            %Definición de los límites del ángulo beta
            b1s=thed+90;      %Valor inicial del límite superior del método de la bisección
            b1i=thed-90;      %Valor inicial del límite inferior del método de la bisección
            
            while Et>Tolt %Proceso iterativo respecto al ángulo theta
                if ni==100 %Control de convergencia
                    fprintf('\nNúmero máximo de iteraciones alcanzado (100 iteraciones)')
                    fprintf('\nNo fue posible determinar la inclinación del eje neutro ')
                    fprintf('para la condición con cargas combinadas\n')
                    return
                end
                b=(b1s+b1i)/2; % Cálculo del ángulo b considerando m. de la bisección
                TR=[cosd(-b) sind(-b);   %Matriz de transformación de coordenadas
                    -sind(-b) cosd(-b)]; 
                CROT=ECA(:,1:2)*TR;      %Coordenadas rotadas de cada fibra
                v1max=max(CROT(:,2));    %Fibra extrema superior respecto al sistema rotado
                v1min=min(CROT(:,2));    %Fibra extrema inferior respecto al sistema rotado 
                vn=(v1max+v1min)/2;      %Distancia inicial al eje neutro en flexión pura
                FZ=1.1*Tolf;             %Valor inicial de la fuerza axial
                nj=1;                    %Valor inicial del número de iteraciones para FZ
                
                while FZ>Tolf %Proceso iterativo respecto a la fuerza FZ
                    if nj==100 %Control de convergencia
                        fprintf('\nNúmero máximo de iteraciones alcanzado (100 iteraciones)')
                        fprintf('\nNo fue posible determinar la posición del eje neutro ')
                        fprintf('para la condición de flexión pura \n')
                        return
                    end
                    [SFZ,~,~,~,~,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,vn,Icur,MEPZZ,MSTZZ,MESTA,MESEC);
                    
                    FZ=abs(SFZ); %Fuerza equivalente en la sección a flexión pura
                    
                    if SFZ>Tolf %Sumatoria de fuerzas mayor a la tolerancia +
                        %Actualización de valores y cálculo del yn con el método de la secante
                        v2max=v1max; %Valor necesario para el punto 2 del método de la secante
                        v1max=vn;    %Valor necesario para el punto 1 del método de la secante
                        SF1=SFZ;     %Valor necesario para el punto 1 del método de la secante
                        %Valor necesario para el punto 2 del método de la secante
                        [SF2,~,~,~,~,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,v2max,Icur,MEPZZ,MSTZZ,MESTA,MESEC);
                        vn=v2max-SF2*((v2max-v1max)/(SF2-SF1)); %Nuevo vn por el m. de la secante
                    elseif SFZ<-Tolf %Sumatoria de fuerzas menor a la tolerancia -
                        %Actualización de valores y cálculo del yn con el método de la secante
                        v2min=v1min; %Valor necesario para el punto 2 del método de la secante
                        v1min=vn;    %Valor necesario para el punto 1 del método de la secante
                        SF1=SFZ;     %Valor necesario para el punto 1 del método de la secante
                        %Valor necesario para el punto 2 del método de la secante
                        [SF2,~,~,~,~,~,~,~,~,~,~,~,~]=SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,v2min,Icur,MEPZZ,MSTZZ,MESTA,MESEC);
                        vn=v2min-SF2*((v2min-v1min)/(SF2-SF1)); %Nuevo vn por el m. de la secante
                    else
                    end
                    nj=nj+1; %Actualizar el número de iteraciones para FZ
                end %endwhile FZ>Tolf
                
                vnc=vn+e/k; %Cálculo del eje neutro para acciones combinadas donde k siempre es negativo
                
                [SFZ,SMX,SMY,EA,EIY,EIZ,GJ,MEPZZ,MSTZZ,MESTA,MESEC,X,Y]...
                    =SUMF(CAT,MAT,NELE,ECA,CROT,ELE,k,vnc,Icur,MEPZZ,MSTZZ,MESTA,MESEC);
                
                if PosN==3  %Actualizar los valores de POSX y POSY
                    POSX=X; %Posición en x de la resultante de fuerza axial
                    POSY=Y; %Posición en y de la resultante de fuerza axial
                end
                
                NZ=SFZ;         %Fuerza equivalente en la sección en dirección z
                MX=SMX-NZ*POSY; %Momento equivalente en la sección en dirección x
                MY=SMY+NZ*POSX; %Momento equivalente en la sección en dirección y
                
                %Condicionales para el cálculo adeacuado del ángulo theta
                thn=0; %Variable que guarda el ángulo negativo (solo para MX>0 y MY<0)
                if MX==0 && MY>0
                    th=90;  %Momento en dirección x
                elseif MX==0 && MY<0
                    th=270; %Momento en dirección -x
                elseif MX==0 && MY==0
                    fprintf('\nError en el paso %i para curvatura de %g \n ',Icur-1,k)
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
                %Condicional específico para la convergencia cuando thed es cercano a 0.
                if thed<90 && thn<0
                    th=th-360;
                %Condicional específico para la convergencia cuando tehd es cercano a 360.
                elseif thed>270 && th<90
                    th=th+360;
                else
                end
                %Condicionales para la actualización de límites
                if th<thed
                    b1i=b; %Actualizar el límite inferior
                else
                    b1s=b; %Actualizar el límite superior
                end
                Et=abs(th-thed); %Calcular el error absoluto para theta
                ni=ni+1;         %Actualizar el número de iteraciones para theta
                
            end %endwhile E>Tolt
            
            M=(MX^2+MY^2)^(1/2); %Cálculo de la magnitud del momento resultante
            
            %Control para determinar la curvatura a primera fluencia
            if pf==0
                if max(MESTA(:,Icur)==3)==1 %Comprobar ablandamiento en el concreto inconfinado
                    pf=1;             %Establecer que ha ocurrido la primera fluencia
                    npf(1,Idef)=Icur; %Guardar el paso donde ocurrió la primera fluencia
                    kp(1,Idef)=-k;    %Guardar la curvatura de primera fluencia
                    Mp(1,Idef)=M;     %Guardar el momento de primera fluencia
                elseif max(MESTA(:,Icur)==7)==1 %Comprobar ablandamiento en el concreto confinado
                    pf=1;             %Establecer que ha ocurrido la primera fluencia
                    npf(1,Idef)=Icur; %Guardar el paso donde ocurrió la primera fluencia
                    kp(1,Idef)=-k;    %Guardar la curvatura de primera fluencia
                    Mp(1,Idef)=M;     %Guardar el momento de primera fluencia
                elseif max(MESTA(:,Icur)==10)==1 %Comprobar fluencia a tensión en el acero
                    pf=1;             %Establecer que ha ocurrido la primera fluencia
                    npf(1,Idef)=Icur; %Guardar el paso donde ocurrió la primera fluencia
                    kp(1,Idef)=-k;    %Guardar la curvatura de primera fluencia
                    Mp(1,Idef)=M;     %Guardar el momento de primera fluencia
                elseif max(MESTA(:,Icur)==14)==1 %Comprobar fluencia a compresión en el acero
                    pf=1;             %Establecer que ha ocurrido la primera fluencia
                    npf(1,Idef)=Icur; %Guardar el paso donde ocurrió la primera fluencia
                    kp(1,Idef)=-k;    %Guardar la curvatura de primera fluencia
                    Mp(1,Idef)=M;     %Guardar el momento de primera fluencia
                end
            end %endif pf
            
            %Control para determinar la curvatura al criterio de falla
            if cf==0
                if max(MESTA(:,Icur)==4)==1
                    cf=1;             %Establecer que se ha alcanzado el criterio de falla
                    ncf(1,Idef)=Icur; %Guardar el paso donde se alcanzó el criterio de falla
                    ku(1,Idef)=-k;    %Guardar la curvatura última de falla
                    Mu(1,Idef)=M;     %Guardar el momento último de falla
                    crit="Se ha alcanzado el criterio de falla en el concreto inconfinado";
                elseif max(MESTA(:,Icur)==8)==1
                    cf=1;             %Establecer que se ha alcanzado el criterio de falla
                    ncf(1,Idef)=Icur; %Guardar el paso donde se alcanzó el criterio de falla
                    ku(1,Idef)=-k;    %Guardar la curvatura última de falla
                    Mu(1,Idef)=M;     %Guardar el momento último de falla
                    crit="Se ha alcanzado el criterio de falla en el concreto confinado";
                elseif max(MESTA(:,Icur)==12)==1
                    cf=1;             %Establecer que se ha alcanzado el criterio de falla
                    ncf(1,Idef)=Icur; %Guardar el paso donde se alcanzó el criterio de falla
                    ku(1,Idef)=-k;    %Guardar la curvatura última de falla
                    Mu(1,Idef)=M;     %Guardar el momento último de falla
                    crit="Se ha alcanzado el criterio de falla en el acero a tensión";
                elseif max(MESTA(:,Icur)==16)==1
                    cf=1;             %Establecer que se ha alcanzado el criterio de falla
                    ncf(1,Idef)=Icur; %Guardar el paso donde se alcanzó el criterio de falla
                    ku(1,Idef)=-k;    %Guardar la curvatura última de falla
                    Mu(1,Idef)=M;     %Guardar el momento último de falla
                    crit="Se ha alcanzado el criterio de falla en el acero a compresión";
                end
            end %endif cf
                       
        end%endif Icur
        
        %Asignar los resultados a los arreglos respectivos
        NV(Icur,1,Idef)=NZ;   %Resultado de fuerza axial
        MV(Icur,1,Idef)=M;    %Resultado de momento en dirección del ángulo theta
        KV(Icur,1,Idef)=-k;   %Resultado de curvatura
        B(Icur,1)=b;          %Resultado de inclinación del eje neutro
        EPZZ(:,:,Idef)=MEPZZ; %Resultado de deformaciones en dirección z
        STZZ(:,:,Idef)=MSTZZ; %Resultado de esfuerzos en dirección z
        ESTA(:,:,Idef)=MESTA; %Resultado del estado del material
        ESEC(:,:,Idef)=MESEC; %Resultado de módulos secantes
        %Resutados de los coeficientes relacionados con al rigidez
        EAV(Icur,1,Idef)=EA;
        EIYV(Icur,1,Idef)=EIY;
        EIZV(Icur,1,Idef)=EIZ;
        GJV(Icur,1,Idef)=GJ;
        
        % tabla de resultados por elemento de un paso
        % ---------------------------------------------------------------------------
        % [ EPZZ STZZ ESTA ]
        
        REL = zeros(NELE,3);
        REL = [EPZZ(:,Icur,Idef),STZZ(:,Icur,Idef),ESTA(:,Icur,Idef)];
        
        % escribir resultados en .pos
        % ---------------------------------------------------------------------------
        STEP = Icur-1; % paso de curvatura (en GMSH empieza en 0)
        TIME = -k;     % el tiempo en GMSH puede representar otra variable
        DEFP = e;      % valor de la deformación axial en el paso
        IMPREL(FIDE,NELE,NNUE,REL,TIME,STEP,DEFP);
        
        TFIN = IMTIEM('',TINI);
    
        if (Icur>=2) && (max(MSTZZ(:,2)~=0)==0) %Control de fallo súbito de la sección
            fprintf('\nSe ha detenido repentinamente el cálculo en el paso: %i, ',Icur-1)
            fprintf('para un valor de curvatura de: %g \n',k)
            fprintf('Todas las fibras tienen un esfuerzo normal igual a 0. \n')
            break
        end
        
        if cf==1 %Mostrar si se ha alcanzado el criterio de falla
            if Icur==Ncur
            fprintf('\n%s', crit)    
            fprintf(' al completar los %i incrementos de curvatura. \n',Ncur-1)
            else
            fprintf(crit) 
            fprintf(' antes de completar los %i incrementos de curvatura. \n',Ncur-1)    
            end
            fprintf('El paso en el que se produce la falla es el %i, para un valor de curvatura de: %g \n',Icur-1,k)
            break
        end
        
    end % endfor Icur
    ENV(Idef,1)=e; %Asiganr el resultado de deformación axial al vector correspondiente
end % endfor Idef

status = fclose(FIDE); % cierre de archivo .pos

%% ----------------------------------------------------------------------------------
% curva de resultados en función del tiempo
% -----------------------------------------------------------------------------------
% Relación M-KAPPA-N
CUR=[KV(:,:,:),MV(:,:,:),NV(:,:,:)];

%% ----------------------------------------------------------------------------------
% abrir archivo .pos.opt y escribir curva M-kappa
% -----------------------------------------------------------------------------------
IMPOPT(ADAD,CUR,ENV);

%% ----------------------------------------------------------------------------------
% Proceso de bilinealización
% -----------------------------------------------------------------------------------
if (cf==1) && (PosN==2 || PosN==3)
    
    A=zeros(1,Ndef);
    ke=zeros(1,Ndef);
    Me=zeros(1,Ndef);
    
    for i=1:Ndef
        Ncf=ncf(1,i);
        for j=2:Ncf
            A(1,i)=A(1,i)+(KV(j,1,i)-KV(j-1,1,i))*(MV(j,1,i)+MV(j-1,1,i))/2;
        end
        m=Mp(1,i)/kp(1,i);
        ke(1,i)=(2*A(1,i)-ku(1,i)*Mu(1,i))/(m*ku(1,i)-Mu(1,i));
        Me(1,i)=m*ke(1,i);
    end
KB=[zeros(1,Ndef); ke; ku];
MB=[zeros(1,Ndef); Me; Mu];
end
%% ----------------------------------------------------------------------------------
% Creación del gráfico Momento-curvatura y Axial-Curvatura
% -----------------------------------------------------------------------------------

L=cell(Ndef,1);         %Arreglo tipo cell para guardar etiquetas.
ca=rand(3,1,Ndef);      %Generador aleatorio de colores
close                   %Borrar figuras anteriores
figure('Name','MKAPPAN')%Nombrar ventana
if Ndef>1
    subplot(2,1,1)      %Crear subplot de MvsKappa
end
hold on
for Idef=1:Ndef %Graficar relaciones momento - curvatura
    e=ENV(Idef);
    L{Idef,1}=['\epsilon_{N}=',num2str(e)];
    c=ca(:,:,Idef);
    if (cf==1)
        plot(KV(1:ncf(1,Idef),:,Idef),MV(1:ncf(1,Idef),:,Idef),'-o','Color',c)
        if (Ndef==1)
            plot(KB(:,1),MB(:,1),'-o','Color',c)    
        end
    else
        plot(KV(:,:,Idef),MV(:,:,Idef),'-o','Color',c)
    end
    title('M vs Kappa')
    grid on
    xlabel('Curvatura, 1/m')
    ylabel('Momento resultante M, kN-m')
end
hold off
legend(L,'Location','east')

if Ndef>1 %Graficar relaciones fuerza axial - curvatura
    set(gca, 'Position', [0.1, 0.58, 0.85, 0.38]); %[m.izq. m.inf. anc. alt.]
    subplot(2,1,2)  %Crear subplot de N-Kappa
    hold on
    for Idef=1:Ndef
        e=ENV(Idef);
        L{Idef,1}=['\epsilon_{N}=',num2str(e)];
        c=ca(:,:,Idef);
        if (cf==1)
            plot(KV(1:ncf(1,Idef),:,Idef),NV(1:ncf(1,Idef),:,Idef),'-*','Color',c)
        else
            plot(KV(:,:,Idef),NV(:,:,Idef),'-*','Color',c)
        end
        title('N vs Kappa')
        grid on
        xlabel('Curvatura, 1/m')
        ylabel('Fuerza axial N, kN')
    end
    hold off
    legend(L,'Location','east')
    set(gca, 'Position', [0.1, 0.08, 0.85, 0.38]);
end

if (cf==1) && (Ndef>1) %Graficar curvas bilineales de forma independiente
    figure('Name','MKAPPAN - Bilinealización')%Nombrar ventana
    hold on
    for Idef=1:Ndef
        e=ENV(Idef);
        L{Idef,1}=['\epsilon_{N}=',num2str(e)];
        c=ca(:,:,Idef);
        plot(KB(:,Idef),MB(:,Idef),'-o','Color',c)
        title('Curvas bilineales de M vs Kappa')
        grid on
        xlabel('Curvatura, 1/m')
        ylabel('Momento resultante M, kN-m')
    end
    legend(L,'Location','east')
    hold off
end

%% ----------------------------------------------------------------------------------
% Exportar resultados de la curva M-kappa en archivo .txt
% -----------------------------------------------------------------------------------
if Ndef==1
RESULM=[KV , MV]; %Relación momento resultante - curvatura
RESULN=[KV , NV]; %Relación fuerza axial - curvatura

NAME=strcat('DATOS/',ADAT,'.txt'); %Nombre y ubicación del archivo a guardar
save(NAME, 'RESULM', '-ascii')     %Guardar relación M-KAPPA en el archivo     

NAME=strcat('DATOS/',ADAT,'-N.txt'); %Nombre y ubicación del archivo a guardar
save(NAME, 'RESULN', '-ascii')       %Guardar relación N-KAPPA en el archivo 
end

%% ----------------------------------------------------------------------------------
% mostrar tiempo final
TFIN = IMTIEM('Tiempo total de ejecucion del programa ',TINT);
end