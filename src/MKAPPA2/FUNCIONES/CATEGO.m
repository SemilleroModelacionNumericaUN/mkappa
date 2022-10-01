% Funci�n que construye la tabla completa de categor�as presentes en la secci�n
function [CAE] = CATEGO(CAT,MAT)
% Entrada:
% CAT():  tabla del identificador IDCA de la categor�a en el archivo.msh de Gmsh.
% MAT():  tabla de par�metros de la categor�a en el archivo .m
%
% Salida:
% CAE():  tabla completa de categor�as presentes en la secci�n. El n�mero de la
%         fila indica el n�mero de la categor�a dado en la primera columna de la
%         tabla de conectividades ELE.

NMAT = size(MAT,1);
NCAT = size(CAT,1);
SICA=0;
for ICAT=1:NCAT
    for IMAT=1:NMAT
        if CAT(ICAT)==MAT(IMAT,1)
            CAE(ICAT,:)=MAT(IMAT,:);
            SICA=1;
        end % endif
    end % endfor ICAM
    if SICA==0
        error('MKAPPA. La tabla MAT no contiene una categoría IDCA definida en GMSH');
    end % endif
end % endfor ICAT

end
