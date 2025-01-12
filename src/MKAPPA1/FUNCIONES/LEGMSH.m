% Funci�n que lee el archivo de datos .msh creado en Gmsh
function [NNUD,NELE,NCAT,NNUE,XYZ,ELE,CAT,SUP] = LEGMSH(ADAD)
%               
% entrada ADAD: nombre del archivo de datos sin extensi�n
%
% salida   NNUD: n�mero de nudos
%          NELE: n�mero de elementos
%          NCAT: n�mero de categor�as de los elementos
%          NNUE: n�mero m�ximo de nudos por elemento
%
%          XYZ: tabla de coordenadas de los nudos
%               [ XNUD YNUD ]
%          ELE: tabla de categor�a y conectividades de los elementos
%               [ ICAT NUDI NUDJ NUDK ]
%          CAT: tabla de categor�as de los elementos
%               [ IDCAT ]
%          SUP: tabla identificadora de la superficie asociada al elemento 
  
  % valores por defecto de los par�metros generales para GMSH
  NDIM = 2;    % dimensiones del problema
  
  % lectura del archivo .msh
  GMSH = strcat(ADAD,'.msh'); % nombre archivo GMSH de datos
  FLID = fopen(GMSH); % abrir archivo .msh
  
  if FLID==-1
    fprintf('\n');
    error('MKAPPA. El archivo %s.msh no existe',ADAD);
  end
  
  % leer l�nea de datos en el archivo
  TLINE = fgetl(FLID);
  % -----------------------------------------------------------------
  while ischar(TLINE)
    
    % bloque de formato
    if (strcmp(TLINE,'$MeshFormat')==1)
      TLINE = fgetl(FLID);
      VERSI=str2num(TLINE);
      if (VERSI(1,1)>2.2)
        fprintf('\n');
        error('Version mayor a 2.2 del archivo .msh de GMHS');
      end
    end % endif
    
    % bloque de entidades f�sicas
    if (strcmp(TLINE,'$PhysicalNames')==1)
      TLINE = fgetl(FLID); % leer siguiente l�nea
      NFIS=str2num(TLINE);
      NFIS=int16(NFIS);   % n�mero de entidades f�sicas
      % inicializaci�n
      ICATE=0;
      FCATE=zeros(1,2);
      for IFIS=1:NFIS
        TLINE = fgetl(FLID); % leer siguiente l�nea
        TFIS=strsplit(TLINE); % divide l�nea en palabras
        NCOM=size(TFIS,2); % retorna n�mero de palabras
        NCOM=NCOM-3; % n�mero de componentes en la l�nea
        TEMP=char(TFIS{3}); % palabra clave etiqueta ent f�sica
        
       % entidad f�sica tipo categor�a
        if (strcmp(TEMP(1:5),'"CATE')==1)
          ICATE=ICATE+1; % contador de entidades f�sicas de tipos de categorias
          FCATE(ICATE,1)=str2num(TFIS{2}); % id entidad f�sica
          TEMR=strsplit(TFIS{3+1},{'=','"'});
          % identificador de la categor�a, entre 01 y 99.
          if (strcmp(TEMR{1},'IDCA')==1)
            FCATE(ICATE,2)=str2num(TEMR{2}); % valor
          end % endif
          % control de errores
          if ( FCATE(ICATE,2)<=0 || FCATE(ICATE,2)>99 )
            fprintf('\n');
            error('Identificador de la categoria incorrecto. 01<=IDCA<=99.');
          end %endif
        end %endif 
        
      end % endfor IFIS
      
      NCAT=ICATE; % n�mero de entidades f�sicas de tipos de categor�a
      
    end % endif fin de bloque de entidades f�sicas
    
    % bloque de nudos
    if (strcmp(TLINE,'$Nodes')==1)
      TLINE = fgetl(FLID); % leer siguiente l�nea
      NNUD=int64(str2num(TLINE)); % n�mero de nudos
      XYZ=zeros(NNUD,NDIM,'single');
      for INUD=1:NNUD
        TLINE = fgetl(FLID); % leer siguiente l�nea
        TEMP=str2num(TLINE); % dividir por variables
        XYZ(INUD,1)=TEMP(2); % coordenada x
        XYZ(INUD,2)=TEMP(3); % coordenada y
      end %endfor INUD
    end % endif fin de bloque de nudos
    
    % bloque de elementos y 
    % condiciones de borde en puntos y l�neas
    if (strcmp(TLINE,'$Elements')==1)
      
      % inicializar
      ICOPL=0; IELTR=0; IELCU=0; CORL=0; ISUP=0;
      COPL=zeros(1,3); % condiciones de borde en puntos y lineas
      ELTR=zeros(1,4); % elementos en superficie tipo triangulo 
      ELCU=zeros(1,5); % elementos en superficie tipo cuadrilateral
  
      TLINE = fgetl(FLID); % leer siguiente l�nea
      NELT=int64(str2num(TLINE));% n�m elem + cond borde
      
      for IELT=1:NELT
        TLINE = fgetl(FLID); % leer siguiente l�nea
        TEMP=str2num(TLINE); % dividir por variables
        
        % condici�n de borde en puntos
        if TEMP(2)==15
          ICOPL=ICOPL+1; % contador de cond de borde en puntos y l�neas
          COPL(ICOPL,:)=[TEMP(4),TEMP(6), 0];
        end %endif
        
        % condici�n de borde en l�neas
        if TEMP(2)==1
          ICOPL=ICOPL+1; % contador de cond de borde en puntos y l�neas
          % [id entidad fisica, id nudo i, id nudo j]
          COPL(ICOPL,:)=[TEMP(4),TEMP(6:7)];
        end %endif
        
        % entidad f�sica en superficies con
        % elementos triangulares lineales
        if TEMP(2)==2
          IELTR=IELTR+1; % contador de elementos triangulares
          
          % escribir en la tabla de categor�as
          % tipo de elemento: TIPE, nudos por elem: NUEL, p.Gauss: PGAU
          for ICATE=1:NCAT
            if FCATE(ICATE,1)==TEMP(4)
              FCATE(ICATE,6:8)=[201,3,1];
              RCATE=ICATE; % indice de la categoria asociado a la ent f�sica
            end %endif
          end % endfor ICATE
        
          % escribir en la tabla de conectividades
          % revisi�n y correcci�n de conectividades en sentido horario
          for INUE=1:3
            XYE(INUE,1:2)=XYZ(TEMP(INUE+5),1:2);
          end % endfor INUE
          
          [ARCE] = PBARCE(XYE);
          AREA = ARCE(1,3);
          if AREA > 0.0
            % nudos en sentido antihorario (correcto)
            % [id categor�a ; id nudos i,j,k]
            ELTR(IELTR,:)=[RCATE,TEMP(6:8)];
          else
            % nudos en sentido horario (incorrecto)
            % [id categor�a ; id nudos i,j,k]
            ELTR(IELTR,:)=[RCATE,TEMP(6),TEMP(8),TEMP(7)];
            CORL=CORL+1; % indicador de la correcci�n
          end %endif

        end %endif
 
        % entidad f�sica en superficies con
        % elementos cuadrilaterales bilineales
        if TEMP(2)==3
          IELCU=IELCU+1; % contador de elementos cuadrilaterales
          
          % escribir en la tabla de categor�as
          % tipo de elemento: TIPE, nudos por elem: NUEL, p.Gauss: PGAU
          for ICATE=1:NCAT
            if FCATE(ICATE,1)==TEMP(4)
              FCATE(ICATE,6:8)=[202,4,4];
              RCATE=ICATE; % indice de la categoria asociado a la ent f�sica 
            end %endif
          end % endfor ICATE
          
          % escribir en la tabla de conectividades
          % revisi�n y correcci�n de conectividades en sentido horario
          for INUE=1:4
            XYE(INUE,1:2)=XYZ(TEMP(INUE+5),1:2);
          end % endfor INUE
          ARVO = PBAVEL(XYE,202,1);
          if ARVO > 0.0
            % nudos en sentido antihorario (correcto)
            % [id entidad f�sica ; id nudos i,j,k,l]
            ELCU(IELCU,:)=[RCATE,TEMP(6:9)];
          else
            % nudos en sentido horario (incorrecto)
            % [id entidad f�sica ; id nudos i,j,k,l]
            ELCU(IELCU,:)=[RCATE,TEMP(6),TEMP(9),TEMP(8),TEMP(7)];
            CORL=CORL+1; % indicador de la correcci�n
          end %endif
          
        end %endif
        
        % tabla auxilar de identificador de la superficie asociada
        % al elemento finito (triangular o cuadrilateral)
        if TEMP(2)==2 || TEMP(2)==3
          ISUP=ISUP+1;
          SUP(ISUP)=TEMP(5);
        end %endif

      end %endfor IELT
      
      if CORL>0
        DUMI = IMTIEM('',0);
        fprintf('\n');
        warning(['LEGMSH: corrección de conectividades, ordenando ' ...
                 'los nudos en sentido antihorario.']);
      end % endif
      
      NCOPL=ICOPL; % n�mero de condiciones de borde
      NELE=IELTR+IELCU; % n�mero de elementos finitos
      
    end % endif bloque de elem y nudos y lados con cond borde  

    TLINE = fgetl(FLID);% leer siguiente l�nea
  end % endwhile fin de lectura
  % -----------------------------------------------------------------
  
  fclose(FLID); % cierre de archivo
  
  % preparar tabla de categorias de los elementos
  % [ IDCAT ]
  CAT=zeros(NCAT,1);
  CAT(:,1)=FCATE(:,2);
  
  % preparar tabla de conectividades de los elementos ELE
  if IELCU==0
    % malla de solo elementos triangulares
    NNUE=3; NGAU=1;
    ELE=ELTR;
  else
    NNUE=4; NGAU=4;
    if IELTR==0
      % malla de solo elementos cuadrilaterales
      ELE=ELCU;
    else
      % malla de elementos triangulares y cuadrilaterales
      if ELTR(1,1)==ELCU(1,1)
        % si triangulares y cuadrilaterales pertenecen a la misma categor�a
        % se crea una nueva categor�a para los elementos triangulares
        NCAT=NCAT+1;
        CAT(NCAT,1:4)=FCATE(NCAT-1,2:5);
        CAT(NCAT,5:7)=[ 201 3 1 ];
        MONE=ones(IELTR,1)*NCAT;
        MZER=zeros(IELTR,1);
        ELTR=[MONE,ELTR(:,2:4),MZER];
        ELE=[ELTR;ELCU];
      else
        % triangulares y cuadrilaterales son de categor�as diferentes
        MZER=zeros(IELTR,1);
        ELTR=[ELTR,MZER];
        ELE=[ELTR;ELCU];
      end % endif
    end % endif
  end %endif
  
  ELE = int64(ELE); % cambio de tipo de datos para las matrices enteras
end % fin de la funci�n
