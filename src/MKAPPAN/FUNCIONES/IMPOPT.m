% Función que imprime el archivo de los resultados de las relación momento curvatura
% y fuerza axial curvatura para el posproceso en Gmsh.
function IMPOPT(ADAD,CUR,ENV)
% entrada:  ADAD: nombre del archivo de datos sin extensión
%           CUR:  tabla para la curva de resultados 
%           ENV:  tabla de valores de deformación axial
  
  % crear archivo de opciones de presentación de resultados .pos.opt
  % ---------------------------------------------------------------------------------
  GOPT = strcat(ADAD,'.pos.opt'); % nombre archivo GMSH de datos
  FOPT = fopen(GOPT,'w'); % abrir archivo .pos.opt
  
  % mostrar solo la primera vista view[0] deformación EPZZ
  % y establecer intervalos definidos y la malla sobre el resultado
  % nÃºmero de vistas - 1
  NDEF=size(ENV,1);
  NVIE=3*NDEF;  NVIE=NVIE-1;
  fprintf(FOPT,'View[0].Visible = 1; \n'); % vista visible
  fprintf(FOPT,'View[0].IntervalsType = 3; \n'); % vista intervalos definidos
  fprintf(FOPT,'View[0].ShowElement = 1; \n'); % mostrar malla sobre resultado
  
  for IVIE=1:NVIE
      fprintf(FOPT,'View[%d].Visible = 0; \n',IVIE); % vistas no visibles
      fprintf(FOPT,'View[%d].IntervalsType = 3; \n',IVIE); % vistas intervalos definidos
      fprintf(FOPT,'View[%d].ShowElement = 1; \n',IVIE); % mostrar malla sobre resultado
      
      if (mod(IVIE+1,3))==0 %Aplicar solo a las vistas de estados del material
         fprintf(FOPT,'View[%d].NbIso = 16; \n',IVIE); % mostrar 16 colores
         fprintf(FOPT,'View[%d].RangeType = 2; \n',IVIE); % rango de valores personalziado 
         fprintf(FOPT,'View[%d].CustomMax = 16; \n',IVIE); % valor máximo del rango
         fprintf(FOPT,'View[%d].CustomMin = 0; \n',IVIE); % valor mínimo del rango
      end   
      
  end % endfor IVIE
  
  % crear vista con curva kappa vs Momento
  NCUR=size(CUR,1);
  fprintf(FOPT,'View "k vs M en=%.2E" { \n',ENV(1));
  
  % eje vertical
  fprintf(FOPT,'SP(1,1,0){  \n');
  for ICUR=1:NCUR
      if ICUR==NCUR
          fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,2,1));
      else
          fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,2,1));
      end % endif
  end % endfor
  
  % eje horizontal: tiempos
  fprintf(FOPT,'TIME{  \n');
  for ICUR=1:NCUR
      if ICUR==NCUR
          fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,1,1));
      else
          fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,1,1));
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
  
  % crear vista con curva kappa vs Fuerza axial
  NCUR=size(CUR,1);
  fprintf(FOPT,'View "k vs N en=%.2E" { \n',ENV(1));
  
  % eje vertical
  fprintf(FOPT,'SP(1,1,0){  \n');
  for ICUR=1:NCUR
      if ICUR==NCUR
          fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,3,1));
      else
          fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,3,1));
      end % endif
  end % endfor
  
  % eje horizontal: tiempos
  fprintf(FOPT,'TIME{  \n');
  for ICUR=1:NCUR
      if ICUR==NCUR
          fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,1,1));
      else
          fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,1,1));
      end % endif
  end % endfor
  
  NVIE=NVIE+1;
  fprintf(FOPT,'}; \n');
  fprintf(FOPT,'View[%d].Type=3; \n',NVIE);
  fprintf(FOPT,'View[%d].Axes=3; \n',NVIE);
  fprintf(FOPT,'View[%d].AutoPosition=0; \n',NVIE);
  fprintf(FOPT,'View[%d].RangeType =1; \n',NVIE);
  fprintf(FOPT,'View[%d].PositionX =90;  \n',NVIE);
  fprintf(FOPT,'View[%d].PositionY =280;  \n',NVIE);
  fprintf(FOPT,'View[%d].Width =250;  \n',NVIE);
  fprintf(FOPT,'View[%d].Height =162;  \n',NVIE);
  
  for IDEF=2:NDEF %Crear curvas para las deformaciones axiales diferentes de 0
      
      % crear vista con curva kappa vs Momento
      NCUR=size(CUR,1);
      fprintf(FOPT,'View "k vs M en=%.2E" { \n',ENV(IDEF));
      
      % eje vertical
      fprintf(FOPT,'SP(1,1,0){  \n');
      for ICUR=1:NCUR
          if ICUR==NCUR
              fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,2,IDEF));
          else
              fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,2,IDEF));
          end % endif
      end % endfor
      
      % eje horizontal: tiempos
      fprintf(FOPT,'TIME{  \n');
      for ICUR=1:NCUR
          if ICUR==NCUR
              fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,1,IDEF));
          else
              fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,1,IDEF));
          end % endif
      end % endfor
      
      NVIE=NVIE+1;
      fprintf(FOPT,'}; \n');
      fprintf(FOPT,'View[%d].Visible = 0; \n',NVIE);
      fprintf(FOPT,'View[%d].Type=3; \n',NVIE);
      fprintf(FOPT,'View[%d].Axes=3; \n',NVIE);
      fprintf(FOPT,'View[%d].AutoPosition=0; \n',NVIE);
      fprintf(FOPT,'View[%d].RangeType =1; \n',NVIE);
      fprintf(FOPT,'View[%d].PositionX =90;  \n',NVIE);
      fprintf(FOPT,'View[%d].PositionY =36;  \n',NVIE);
      fprintf(FOPT,'View[%d].Width =250;  \n',NVIE);
      fprintf(FOPT,'View[%d].Height =162;  \n',NVIE);
      
      % crear vista con curva kappa vs Fuerza axial
      NCUR=size(CUR,1);
      fprintf(FOPT,'View "k vs N en=%.2E" { \n',ENV(IDEF));
      
      % eje vertical
      fprintf(FOPT,'SP(1,1,0){  \n');
      for ICUR=1:NCUR
          if ICUR==NCUR
              fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,3,IDEF));
          else
              fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,3,IDEF));
          end % endif
      end % endfor
      
      % eje horizontal: tiempos
      fprintf(FOPT,'TIME{  \n');
      for ICUR=1:NCUR
          if ICUR==NCUR
              fprintf(FOPT,'%+10.4e};  \n',CUR(ICUR,1,IDEF));
          else
              fprintf(FOPT,'%+10.4e,  \n',CUR(ICUR,1,IDEF));
          end % endif
      end % endfor
      
      NVIE=NVIE+1;
      fprintf(FOPT,'}; \n');
      fprintf(FOPT,'View[%d].Visible = 0; \n',NVIE);
      fprintf(FOPT,'View[%d].Type=3; \n',NVIE);
      fprintf(FOPT,'View[%d].Axes=3; \n',NVIE);
      fprintf(FOPT,'View[%d].AutoPosition=0; \n',NVIE);
      fprintf(FOPT,'View[%d].RangeType =1; \n',NVIE);
      fprintf(FOPT,'View[%d].PositionX =90;  \n',NVIE);
      fprintf(FOPT,'View[%d].PositionY =280;  \n',NVIE);
      fprintf(FOPT,'View[%d].Width =250;  \n',NVIE);
      fprintf(FOPT,'View[%d].Height =162;  \n',NVIE);
      
  end
  
  status = fclose(FOPT); % cierre de archivo .pos.opt
 
end