% Funci�n que calcula la Deformaci�n Axial Inicial
function [DEFI]=DAI(ANA,MAT,NELE,CAT,ELE,ECA)
    
    %Determinar los m�dulos de elasticidad iniciales de la categor�a material
    if (ANA(4)<0) || (MAT(1,4)~=0)
    EC=5000*(MAT(1,3))^(1/2);
    else
    EC=0;  
    end    
    ES=MAT(3,4);
    EI=[EC;EC;ES];
    
    SUMEA=0;
    for IELE=1:NELE
        SUMEA = SUMEA + EI(CAT(ELE(IELE,1),1)) * ECA(IELE,3);
    end % endfor IELE
    SUMEA=1000*SUMEA; %Pasar de MPa*m^2 a kPa*m^2=kN
    DEFI=ANA(4)/SUMEA;