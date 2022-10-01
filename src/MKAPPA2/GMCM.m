% Funci�n independiente que grafica la relaci�n del esfuerzo contra la deformaci�n 
% longitudinal empleando los modelos constitutivos unidimensionales no lineales.
function GMCM(ADAT,CAT,N)
%
% Par�metros de entrada:
% ADAT: Nombre del archivo que contiene las propieades de los materiales
%  CAT: Identificador IDCA del material a representar
%       01 Concreto inconfinado
%       02 Concreto confinado
%       03 Acero estructural
%       00 Todos los anteriores
%    N: N�mero de puntos para representar cada curva
%
% Introducir de la forma: GMCM('Nombre.m',#,#)

%Adicionar carpetas
addpath('./FUNCIONES');
addpath('./DATOS');

run(ADAT); % crea las tablas MAT

%Inicializaci�n de variables
fci=zeros(1,N); %Vector de esfuerzos del concreto inconfinado
eci=zeros(1,N); %Vector de deformaciones del concreto inconfinado
fcc=zeros(1,N); %Vector de esfuerzos del concreto confinado 
ecc=zeros(1,N); %Vector de deformaciones del concreto confinado
fs=zeros(1,N);  %Vector de esfuerzos del acero
es=zeros(1,N);  %Vector de deformaciones del acero
esp=MAT(1,6);  %Deformaci�n al esfuerzo de aplastamiento del c. inconfinado
ecu=0.035;     %Deformaci�n m�xima estimada para el c. confinado 
esu=MAT(3,6);  %Deformaci�n m�xima del acero

if CAT==01
    for i=0:1:N
        e=-i*esp/N;
        [STZZ]=MCM(e,CAT,MAT);
        eci(1,i+1)=e;
        fci(1,i+1)=STZZ;
    end
    figure('Name','Modelo constitutivo unidimensional del concreto inconfinado');
    plot(-eci,-fci)
    title('Modelo constitutivo del c. inconfinado')
    xlabel('Deformaci�n longitudinal')
    ylabel('Esfuerzo normal (MPa)')
    
elseif CAT==02
    for i=0:1:N
        e=-i*ecu/N;
        [STZZ]=MCM(e,CAT,MAT);
        ecc(1,i+1)=e;
        fcc(1,i+1)=STZZ;  
    end
    figure('Name','Modelo constitutivo unidimensional del concreto confinado');
    plot(-ecc,-fcc)
    title('Modelo constitutivo del c. confinado')
    xlabel('Deformaci�n longitudinal')
    ylabel('Esfuerzo normal (MPa)')
    
elseif CAT==03
    for i=0:1:N
        e=i*esu/N;
        [STZZ]=MCM(e,CAT,MAT);
        es(1,i+1)=e;
        fs(1,i+1)=STZZ;
    end
    figure('Name','Modelo constitutivo unidimensional del acero');
    plot(es,fs)
    title('Modelo constitutivo del acero')
    xlabel('Deformaci�n longitudinal')
    ylabel('Esfuerzo normal (MPa)')
    
elseif CAT==00
    for i=0:1:N
        CAT=01;
        e=-i*esp/N;
        [STZZ]=MCM(e,CAT,MAT);
        eci(1,i+1)=e;
        fci(1,i+1)=STZZ;
        CAT=02;
        e=-i*ecu/N;
        [STZZ]=MCM(e,CAT,MAT);
        ecc(1,i+1)=e;
        fcc(1,i+1)=STZZ;
        CAT=03;
        e=i*esu/N;
        [STZZ]=MCM(e,CAT,MAT);
        es(1,i+1)=e;
        fs(1,i+1)=STZZ;
    end
    
    figure('Name','Modelo constitutivo unidimensional del concreto confinado e inconfinado');
    hold on
    plot(-eci,-fci)
    plot(-ecc,-fcc)
    title('Modelo constitutivo del concreto confinado e inconfinado')
    xlabel('Deformaci�n longitudinal')
    ylabel('Esfuerzo normal (MPa)')
    hold off
    
    figure('Name','Modelo constitutivo unidimensional del acero');
    plot(es,fs)
    title('Modelo constitutivo del acero')
    xlabel('Deformaci�n longitudinal')
    ylabel('Esfuerzo normal (MPa)')
else
    fprintf('El identificador no est� definido \n')
end
end