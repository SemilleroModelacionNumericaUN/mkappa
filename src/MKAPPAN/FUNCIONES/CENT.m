% Funci�n que calcula el centroide de la secci�n
function [POSX,POSY,ECA]=CENT(NNUE,NELE,ELE,XYZ)

    % Construcci�n de tabla de centroides y �reas de los elementos
    % ECA=[XCEN,YCEN,AREA] en cada fila IELE.
    % C�lculo del centroide de la secci�nn CENX,CENY como la sumatoria
    % de (Ai xi) o (Ai yi) dividido entre la sumatoria de (Ai), siendo 
    % Ai el �rea del elemento, xi la posici�n en direcci�n x de su 
    % centroide y yi la posici�n en direcci�n y de su centroide.
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
        SUMX = SUMX + ECA(IELE,3) * ECA(IELE,1) ;
        SUMY = SUMY + ECA(IELE,3) * ECA(IELE,2) ;
        SUMA = SUMA + ECA(IELE,3);
    end % endfor IELE
    POSX = round( SUMX / SUMA , 4 ); %Posici�n en x del centroide
    POSY = round( SUMY / SUMA , 4 ); %Posici�n en y del centroide
    %Para Octave comente las l�enas anteriores y descomente las dos siguientes:
    %POSX = round( SUMX / SUMA ); %Posici�n en x del centroide
    %POSY = round( SUMY / SUMA ); %Posici�n en y del centroide