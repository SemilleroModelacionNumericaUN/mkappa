%% Script que permite comparar los resultados guardados en los archivos .txt
%Comente y descomente las línea del script según sus requerimientos
%Para ejecutar oprima F5 y en caso de mostrarse uan ventana emergente seleccione al
%opción Add path

%% Sección SARC (Thai)
% 
% SARC=readmatrix('SARC.txt');
% SARCT=load('MKThai2011.txt','-ASCII');
% 
% figure
% plot(SARC(:,1),SARC(:,2),'-o','DisplayName','MKAPPA')
% hold on
% plot(SARCT(:,1),SARCT(:,2),'-+','DisplayName','Thai 2011')
% hold off
% grid on
% title('Comparación gráfica momento curvatura MKAPPA vs Thai et al.(2011)')
% legend('Location','southeast','NumColumns',2)
% 
%% Sección SR
% 
% SR=readmatrix('SR.txt');
% SR1=readmatrix('SR1.txt');
% SR2=readmatrix('SR2.txt');
% SR3=readmatrix('SR3.txt');
% SR4=readmatrix('SR4.txt');
% SR5=readmatrix('SR5.txt');
% SR6=readmatrix('SR6.txt');
% SRX=readmatrix('SR_XTRACT.txt');
% 
% figure
% plot(SR(:,1),SR(:,2),'-o','DisplayName','SR')
% hold on
% plot(SR1(:,1),SR1(:,2),'-+','DisplayName','SR1')
% plot(SR2(:,1),SR2(:,2),'-x','DisplayName','SR2')
% plot(SR3(:,1),SR3(:,2),'-x','DisplayName','SR3')
% hold off
% grid on
% title('Variación en la lc del c.confinado y del acero')
% legend('Location','southeast','NumColumns',2)
% 
% figure
% plot(SR(:,1),SR(:,2),'-o','DisplayName','SR')
% hold on
% plot(SR4(:,1),SR4(:,2),'-+','DisplayName','SR4')
% plot(SR5(:,1),SR5(:,2),'-x','DisplayName','SR5')
% plot(SR6(:,1),SR6(:,2),'-x','DisplayName','SR6')
% hold off
% grid on
% title('Variación en la lc del acero')
% legend('Location','southeast','NumColumns',2)
%  
% figure
% plot(SR3(:,1),SR3(:,2),'-o','DisplayName','SR3')
% hold on
% %plot(SR(:,1),SR(:,2),'-+','DisplayName','SR')
% plot(SR4(:,1),SR4(:,2),'-x','DisplayName','SR4')
% plot(SRX(:,1),SRX(:,2),'-x','DisplayName','SRX')
% hold off
% grid on
% title('Comparación gráfica momento curvatura Sección Rectangular')
% legend('Location','southeast','NumColumns',2)
% 
% 
%% Sección SC
% 
% SC=readmatrix('SC.txt');
% SC1=readmatrix('SC1.txt');
SC2=readmatrix('SC2.txt');
SCX=readmatrix('SC_XTRACT.txt');
% 
figure
% plot(SC1(:,1),SC1(:,2),'-o','DisplayName','MKAPPA')
hold on
% plot(SC(:,1),SC(:,2),'-+','DisplayName','SC')
plot(SC2(:,1),SC2(:,2),'-+','DisplayName','SC2')
plot(SCX(:,1),SCX(:,2),'-x','DisplayName','XTRACT')
% hold off
% grid on
% title('Comparación gráfica momento curvatura Sección Circular')
% legend('Location','southeast','NumColumns',2)

%% Perfiles W
% 
% W1=readmatrix('W21X44.txt');
% W2=readmatrix('W12X26.txt');
% W3=readmatrix('W12X53.txt');
% W4=readmatrix('W12X87.txt');
% W5=readmatrix('W12X120.txt');
% W6=readmatrix('W10X60.txt');
% 
% figure
% plot(W1(:,1),W1(:,2),'-o','DisplayName','W21X44')
% hold on
% plot(W2(:,1),W2(:,2),'-+','DisplayName','W12X26')
% plot(W3(:,1),W3(:,2),'-+','DisplayName','W12X53')
% plot(W4(:,1),W4(:,2),'-+','DisplayName','W12X87')
% plot(W5(:,1),W5(:,2),'-+','DisplayName','W12X120')
% plot(W6(:,1),W6(:,2),'-x','DisplayName','W10X60')
% hold off
% grid on
% title('Comparación gráfica momento curvatura Perfiles W')
% legend('Location','southeast','NumColumns',2)

%% Perfiles W con XTRACT

% W1=readmatrix('W21X44.txt');
% % W2=readmatrix('W12X87.txt');
% W3=readmatrix('W21X44_XTRACT.txt');
% % W4=readmatrix('W12X87_XTRACT.txt');
% 
% figure
% % plot(W1(:,1),W1(:,2),'-o','DisplayName','W21X44')
% % hold on
% plot(W2(:,1),W2(:,2),'-+','DisplayName','W12X87')
% hold on
% % plot(W3(:,1),W3(:,2),'-x','DisplayName','W21X44 XTRACT')
% plot(W4(:,1),W4(:,2),'-x','DisplayName','W12X87 XTRACT')
% hold off
% grid on
% title('Comparación gráfica momento curvatura Perfiles W')
% legend('Location','southeast','NumColumns',2)

