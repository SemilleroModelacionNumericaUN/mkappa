# mkappa

Programa didáctico de análisis no lineal de secciones transversales en elementos estructurales sometidos a flexión y fuerza axial

## Autores

Hernán Sebastián Buitrago Ecobar
Dorian Luis Linero Segrera

Universidad Nacional de Colombia - sede Bogotá
Facultad de Ingeniería

## Uso del programa

```
octave

>> MKAPPA [ADAT] [TLEC]
```

[ADAT] : nombre del archivo de entrada sin extensión

[TLEC] : identificador de la opción de lectura de datos


### Generalidades

A continuación se muestran los aspectos generales y las instrucciones básicas para utilizar el programa MKAPPA

La carpeta del programa MKAPPA contiene tres carpetas y en cada una se encuentra uno de los subprogramas de MKAPPA. Los tres subprograma son: 

- MKAPPA1, para el análisis de secciones simétricas a flexión uniaxial.
- MKAPPA2, para el análisis de secciones asimétricas a flexión y simétricas a flexión biaxial.
- MKAPPAN, para el análisis de secciones considerando flexión y fuerza axial.
Cada una de las tres carpetas contiene lo siguiente:
- Carpeta "DATOS" con los archivos .geo, .msh, .m, .pos, .pos.opt y .txt de cada una de las secciones analizadas.
- Carpeta "FUNCIONES" con las funciones utilizadas por cada uno de los subprogramas.
- Archivo de texto con los identificadores de los estados del material de las fibras, necesario para interpretar la gráfica de estado en Gmsh.
- Archivo "GMCM.m" que corresponde a una función independiente que gráfica los modelos constitutivos de los materiales a partir de las 
 propiedades definidas en el archivo de parámetros de entrada .m que le corresponde a la sección. 
- Archivo "MKAPPA1.m", "MKAPPA2.m" o "MKAPPAN.m" que corresponde a la función principal de cada subprograma.


### Subprogramas

Para utilizar cualquiera de los subprogramas de MKAPPA realice lo siguiente:

1. Instale el programa MATLAB u Octave según prefiera. Cabe mencionar que, aunque Octave es un software libre, se ha observado que los tiempos 
de ejecución son sustancialmente mayores que MATLAB, siendo dichos tiempos hasta 100 veces mayores o más.
2. Abra la función principal que desee ejecutar. Para esto usted puede dar doble clic izquierdo y, en caso de que el sistema pregunte, abrir el 
archivo de extensión .m con MATLAB u Octave. También puede abrir MATLAB u Octave, y dentro del programa abrir el archivo .m de la función 
principal deseada. Asegúrese de que la dirección del archivo dentro del programa finalice de la forma ".../MKAPPA/MKAPPA1", ".../MKAPPA/MKAPPA2" 
o ".../MKAPPA/MKAPPAN", según corresponda.
3. Si desea analizar una sección con archivo .msh ya existente, modifique unicamente los parámetros del archivo .m con el nombre de la sección,
por ejemplo SRT2, cuya dirección es MKAPPA/MKAPPAN/DATOS/SRT2.m. Este tipo de archivos pueden abrirse fácilmente desde el Workspace del programa.
Luego, en la ventana de comandos ejecute la instrucción de la forma " >> MKAPPAX Archivo ", donde MKAPPAX es el nombre del subprograma utilizado
y Archivo es el nombre del archivo de la sección sin extensión. Al finalizar la ejecución obtendrá la relación momento - curvatura y se crearan 
los archivos de posproceso para Gmsh. Al utilizar MKAPPAN también podrán mostrar en pantalla resultados adicionales como la relación entre la 
fuerza axial y la curvatura.
4. Si desea analizar una sección con archivo .msh aún no existente, cree los archivos con la geometría (.geo) y con la malla (.msh) mediante el 
programa Gmsh. Luego, realice el procedimiento descrito en el numeral anterior.
Para visualizar los resultados contenidos en los archivos .pos y .pos.opt realice lo siguiente:
5. Instale el software libre Gmsh. Podrá descargar este program desde la siguiente página:  https://gmsh.info/#Download
6. Abra Gmsh y luego haga clic en File -> Open. Busque el archivo con el nombre de la sección analizada y de extensión .pos y haga doble clic.
7. Por defecto, podrá observar la gráfica de distribución de deformaciones longitudinales y la relación momento - curvatura. Desde la pestaña 
"Post-processing" podrá desactivar estas gráficas y activar la distrubición de esfuerzos normales y la distribución de estado del material. 
Entre los resultados obtenidos por MKAPPAN también encontrará la relación fuerza axial - curvatura, y además, para varios pasos de deformación
axial, se podrán visualizar cada una de las gráficas ya mencionadas.

Para más información sobre el uso del programa MKAPPA consulte el Manual del Usuario o la documentación contenida en la tesis titulada "Programa didáctico de análisis no lineal de secciones transversales en elementos estructurales a flexión y fuerza axial".

## Licencia

MIT
