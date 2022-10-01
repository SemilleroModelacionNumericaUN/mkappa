% Funci�n que calcula el Centro Ponderado por el M�dulo de Elasticidad Inicial
function [POSX,POSY,ECA]=CPMEI(MAT,CAT,NNUE,NELE,ELE,XYZ,ANA)
    
    %Determinar los m�dulos de elasticidad iniciales de la categor�a material
    if (ANA(4)<0) || (MAT(1,4)~=0)
    EC=5000*(MAT(1,3))^(1/2);
    else
    EC=0;  
    end    
    ES=MAT(3,4);
    EI=[EC;EC;ES];
    
    % Construcci�n de tabla de centroides y �reas de los elementos
    % ECA=[XCEN,YCEN,AREA] en cada fila IELE.
    % C�lculo de la posici�n del Centro Ponderado por el M�dulo de  
    % Elasticidad Inicial de la secci�nn POSX,POSY como la sumatoria
    % de (Ei Ai xi) o (Ei Ai yi) dividido entre la sumatoria de (Ai Ei), 
    % siendo Ai el �rea del elemento, xi la posici�n en direcci�n x de su 
    % centroide, yi la posici�n en direcci�n y de su centroide y Ei el
    % m�dulo de elasticidad inicial del material.
    % -------------------------------------------------------------------------
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
        SUMX = SUMX + EI(CAT(ELE(IELE,1),1)) * ECA(IELE,3) * ECA(IELE,1) ;
        SUMY = SUMY + EI(CAT(ELE(IELE,1),1)) * ECA(IELE,3) * ECA(IELE,2) ;
        SUMA = SUMA + EI(CAT(ELE(IELE,1),1)) * ECA(IELE,3);
    end % endfor IELE
    POSX = round( SUMX / SUMA , 4 ); %Posici�n en x del CPMEI
    POSY = round( SUMY / SUMA , 4 ); %Posici�n en Y del CPMEI
    %Para Octave comente las l�enas anteriores y descomente las dos siguientes:
%     POSX = round( SUMX / SUMA ); %Posici�n en x del centroide
%     POSY = round( SUMY / SUMA ); %Posici�n en y del centroide
    