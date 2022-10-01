% Funci�n que imprime el archivo de los resultados de la relaci�n momento curvatura
% para el posproceso en Gmsh.
function IMPOPT(ADAD,CUR)
% entrada:  ADAD: nombre del archivo de datos sin extensi�n
%           CUR:  tabla para la curva de resultados
  
  % crear archivo de opciones de presentaci�n de resultados .pos.opt
  % ---------------------------------------------------------------------------------
  GOPT = strcat(ADAD,'.pos.opt'); % nombre archivo GMSH de datos
  FOPT = fopen(GOPT,'w'); % abrir archivo .pos.opt
  
  % mostrar solo la primera vista view[0] deformaci�n EPZZ
  % y establecer intervalos definidos y la malla sobre el resultado
  % n�mero de vistas - 1
  NVIE=3;  NVIE=NVIE-1;
  fprintf(FOPT,'View[0].Visible = 1; \n'); % vista visible
  fprintf(FOPT,'View[0].IntervalsType = 3; \n'); % vista intervalos definidos
  fprintf(FOPT,'View[0].ShowElement = 1; \n'); % mostrar malla sobre resultado
  
  for IVIE=1:NVIE  
    fprintf(FOPT,'View[%d].Visible = 0; \n',IVIE); % vistas no visibles
    fprintf(FOPT,'View[%d].IntervalsType = 3; \n',IVIE); % vistas intervalos definidos
    fprintf(FOPT,'View[%d].ShowElement = 1; \n',IVIE); % mostrar malla sobre resultado
  end % endfor IVIE
  
  fprintf(FOPT,'View[2].NbIso = 16; \n'); % mostrar 16 colores
  fprintf(FOPT,'View[2].RangeType = 2; \n'); % rango de valores personalziado 
  fprintf(FOPT,'View[2].CustomMax = 16; \n'); % valor m�ximo del rango
  fprintf(FOPT,'View[2].CustomMin = 0; \n'); % valor m�nimo del rango
  
  % crear vista con curva kappa vs Momento
  NCUR=size(CUR,1);
  fprintf(FOPT,'View "kappa vs Momento" { \n');
  
  % eje vertical
  fprintf(FOPT,'SP(1,1,0){  \n');
  for ICUR=1:NCUR
    if ICUR==NCUR
      fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,2));
    else
      fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,2));
    end % endif
  end % endfor
  
  % eje horizontal: tiempos
  fprintf(FOPT,'TIME{  \n');
  for ICUR=1:NCUR
    if ICUR==NCUR
      fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,1));
    else
      fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,1));
    end % endif
  end % endfor
  
  NVIE=NVIE+1;
  fprintf(FOPT,'}; \n');
  fprintf(FOPT,'View[%d].Type=3; \n',NVIE);
  fprintf(FOPT,'View[%d].Axes=3; \n',NVIE);
  fprintf(FOPT,'View[%d].AutoPosition=0; \n',NVIE);
  fprintf(FOPT,'View[%d].RangeType =1; \n',NVIE);
  fprintf(FOPT,'View[%d].PositionX =90;  \n',NVIE);
  fprintf(FOPT,'View[%d].PositionY =36;  \n',NVIE);
  fprintf(FOPT,'View[%d].Width =250;  \n',NVIE);
  fprintf(FOPT,'View[%d].Height =162;  \n',NVIE);
  IMPMAP
  
  status = fclose(FOPT); % cierre de archivo .pos.opt
 
end