% Función que calcula el centroide de la sección
function [POSX,POSY,ECA]=CENT(NNUE,NELE,ELE,XYZ)

    % Construcción de tabla de centroides y áreas de los elementos
    % ECA=[XCEN,YCEN,AREA] en cada fila IELE.
    % Cálculo del centroide de la secciónn CENX,CENY como la sumatoria
    % de (Ai xi) o (Ai yi) dividido entre la sumatoria de (Ai), siendo 
    % Ai el área del elemento, xi la posición en dirección x de su 
    % centroide y yi la posición en dirección y de su centroide.
    % -------------------------------------------------------------------------
    SUMX = 0; SUMY= 0; SUMA=0; 
    ECA = zeros(NELE,3); XYE = zeros(NNUE,2);
    for IELE=1:NELE
        % tabla de coordenadas de los nudos del elemento IELE
        for INUE=1:NNUE
            XYE(INUE,1) = XYZ(ELE(IELE,INUE+1),1);
            XYE(INUE,2) = XYZ(ELE(IELE,INUE+1),2);
        end % endfor INUE
        % tabla de centroide y Ã¡rea del elemento IELE
        ECA(IELE,1:3) = PBARCE(XYE);
        SUMX = SUMX + ECA(IELE,3) * ECA(IELE,1) ;
        SUMY = SUMY + ECA(IELE,3) * ECA(IELE,2) ;
        SUMA = SUMA + ECA(IELE,3);
    end % endfor IELE
    POSX = round( SUMX / SUMA , 4 ); %Posición en x del centroide
    POSY = round( SUMY / SUMA , 4 ); %Posición en y del centroide
    %Para Octave comente las líenas anteriores y descomente las dos siguientes:
    %POSX = round( SUMX / SUMA ); %Posición en x del centroide
    %POSY = round( SUMY / SUMA ); %Posición en y del centroide