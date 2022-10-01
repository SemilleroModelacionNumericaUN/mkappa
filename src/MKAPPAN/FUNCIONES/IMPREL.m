% Función que escribe los resultados de los elementos en un archivo de extensión
% .pos para Gmsh
function IMPREL(FIDE,NELE,NNUE,REL,TIME,STEP,DEFP)
% entrada:  FIDE: puntero del archivo .pos
%           NELE: número de elementos
%           NNUE: número máximo de nudos por elemento
%           REL:  tabla de resultados por elemento
%           TIME: variable tipo tiempo, correspondiente a la curvatura
%           STEP: paso, indicado como un entero que comienza en 0.
%           DEFP: valor de la deformación axial en el paso

  % id del tipo de elemento en GMSH
  if NNUE==3 % triangular de 3 nudos
    TELE = 2;
    FORE = '%6i %6i %+15.6e %+15.6e %+15.6e \n';  
  end 
  if NNUE==4 % cuadrilateral de 4 nudos
    TELE = 3;
    FORE='%6i %6i %+15.6e %+15.6e %+15.6e %+15.6e \n';
  end
  % formato de resultados presentados
    d = '%.2E';    
    ETI=['EPZZ',' en=',num2str(DEFP,d),' ';'STZZ',' en=',num2str(DEFP,d),' ';...
        'ESTA',' en=',num2str(DEFP,d),' ']; NREL=3;

  for IREL=1:NREL
    
    fprintf(FIDE,'$ElementNodeData \n 1 \n "%s" \n 1 \n',...
            ETI(IREL,1:17));
    fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 1 \n %6i \n',TIME,STEP,NELE);
    
    for IELE=1:NELE
      RESU = REL(IELE,IREL);
      if NNUE==3 % triangular
        fprintf(FIDE,FORE,IELE,NNUE,RESU,RESU,RESU);
      elseif NNUE==4 % cuadrilateral
        fprintf(FIDE,FORE,IELE, NNUE,RESU,RESU,RESU,RESU);
      end % endif
    end %endfor IELE
    fprintf(FIDE,'$EndElementNodeData \n');
    
  end %endfor IREL

end