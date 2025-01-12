% Funci�n que escribe geometr�a de la malla de elementos en un archivo de extensi�n 
% .pos para Gmsh
function IMPGEO(FIDE,NNUD,NELE,NNUE,NCAT,XYZ,ELE,SUP)
% entrada:  FIDE: puntero del archivo .pos
%           NNUD: n�mero de nudos
%           NELE: n�mero de elementos
%           NNUE: n�mero m�ximo de nudos por elemento
%           NCAT: n�mero de categor�as (materiales y espesores)
%           XYZ:  tabla de coordenadas de los nudos
%           ELE:  tabla de conectividades de los elementos
%           SUP:  tabla de id de superficie asociada al elemento

  % versi�n del GMSH y tama�o de variables reales
  fprintf(FIDE,'$MeshFormat \n');
  fprintf(FIDE,'2.0 0 8 \n');
  fprintf(FIDE,'$EndMeshFormat\n');
  
  % coordenadas de los nudos
  fprintf(FIDE,'$Nodes \n %6i \n',NNUD);
  ZER = zeros(1,NNUD);
  TEM = [double(1:NNUD);XYZ';ZER];
  fprintf(FIDE,'%6i %+10.4e %+10.4e %+10.4e \n',TEM);
  fprintf(FIDE,'$EndNodes \n');
  
  % id del tipo de elemento en GMSH
  if NNUE==3; TELE = 2; end; % triangular de 3 nudos
  if NNUE==4; TELE = 3; end; % cuadrilateral de 4 nudos
  
  % conectividades de los elementos
  fprintf(FIDE,'$Elements \n %6i \n',NELE);
  for IELE=1:NELE
    % imprimir IELE,TELE,ICAT
    fprintf(FIDE,'%6i %2i 2 %2i %2i',IELE,TELE,ELE(IELE,1),SUP(1,IELE));
    for INUE=1:NNUE
      % establecer cuarto nudo de tri�ngulo repitiendo el �ltimo nudo
      if ELE(IELE,INUE+1)==0; ELE(IELE,INUE+1)=ELE(IELE,INUE); end;
      % imprimir en archivo en el orden NUDI NUDJ NUDK NUDL
      fprintf(FIDE,'%6i ',ELE(IELE,INUE+1));
    end % endfor INUE
    fprintf(FIDE,'\n');
  end % endfor IELE
  fprintf(FIDE,'$EndElements \n');
  
end