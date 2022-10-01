% Funci�n que calcula el �rea y el centroide de un elemento triangular
function [ARCE] = PBARCE(XYE)
%
% Par�metro de entrada:
%  XYE:   Tabla de las coordenadas de los nudos del elemento de la forma [XNUD, YNUD]
%         siendo XNUD y YNUD las coordendas x y y del nudo.
% Par�metro de salida
% ARCE:   Tabla de las coordenadas del centroide y el �rea de cada elemento de la
%         forma [XCEN, YCEN, AREA] siendo XCEN y YCEN las coordenadas x y y del
%         centroide y AREA el �rea del elemento triangular.

% Centroide
ARCE(1,1) = (XYE(1,1) + XYE(2,1) + XYE(3,1))/3; % x_c
ARCE(1,2) = (XYE(1,2) + XYE(2,2) + XYE(3,2))/3; % y_c

% �rea
ARCE(1,3) =  XYE(1,1) * XYE(2,2) + XYE(2,1) * XYE(3,2) + XYE(3,1) * XYE(1,2) ...
    - XYE(1,2) * XYE(2,1) - XYE(2,2) * XYE(3,1) - XYE(3,2) * XYE(1,1) ;
ARCE(1,3) = ARCE(1,3)/2;

end