***********
XCI BUILDER (v0.7)
***********
Elaborado por JulesOnTheRoad para elotrolado.net
https://github.com/julesontheroad/XCI_Builder
---------------
0. Changelog
---------------
v0.7   - Limpiados echos, dando al usuario un mejor entendimiento del proceso
         Añadida compatibilidad con XCI_BatchBuilder.
         Eliminado auto-exit al final del programa para que pueda ser usado por línea de comandos.
	 Realizados un par de arreglos en el código.

v0.6.5.2- Reformada carpeta ztools para eliminar sfk.exe ya que no era necesario. Añadida la build de Bigjokker de hacbuild para eliminar la advertencia de falta de 
REV2     header_key.txt en hacbuild, ya que esta clave no es realmente necesaria. 
         Se ha vuelto a la anterior build de hactool en lugar de la prebuild publicada por SciresM ya que parecía dar problemas a usuarios de sistemas 32bits.
	 En caso de necesitar la build de SciresM https://github.com/SciresM/hactool/releases/tag/1.2.0

v0.6.5.2 - Pequeño arreglo. Línea añadida para prevenir la generación de [lc].nsp en archivos sin ticket (archivos custom nsp).
v0.6.5 - Realizados bastantes cambios desde la versión inicial. Los cuáles se detallan a continuación:
  I - Añadida compatibilidad con juegos con más de 5 nca. (Juegos con manual en html) En estos se ha decidido eliminar 
      el manual del juego, lo cuál no impide su ejecución. 
	  El intento de acceder al manual desde los juegos que lo incluyen resulta en una acción que no da lugar a ningún 
	  resultado. Los juegos probados pueden jugarse perfectamente sin manual.
   II - La ruta de salida se ha movido ha la carpeta "output_xcib" para tenerlo todo más organizado y de cara a que se pueda tener NX-Trimmer
	en la misma carpeta que XCI_Builder, el cuál usa "output_nxt" como salida.
   III - Reformado de carpeta ztools, eliminando aplicaciones. 
   IV - Actualización de hacbuild.exe para corregir el warning por falta de "xci_header_key", la cuál no es necesaria para completar el
	proceso pero ahora se puede incorporar rellenando el archivo "header_key.txt" en ztools.
   V  - Añadida plantilla para keys.txt en la carpeta ztools
   VI - Añadido sistema de códigos para la salida de los ficheros. Este consiste en lo siguiente:
	a) Se eliminan las tags [] de los ficheros. Para eliminar cosas como trimmed.
        b) Se eliminan los caracteres _ (más que nada porque no me gusta como quedan)
	c) Se añade las siguientes tags a la salida.
	   [xcib] xci convertido con XCI_Builder
	   [nm] "no manual", es decir se ha eliminado el manual para hacer funcionar el xci.
	   [lc] En nsp de salida: nsp de pequeño tamaño necesario para hacer funcionar el xci.

NOTA: Si se viene de una versión anterior sustituir las aplicaciones de ztools. Se ha actualizado hactool y se ha realizado una pequeña 
      modificación en hacbuild.

v0.5.1 - v0.5.5.1 - Pequeñas correcciones
v0.5.0 - Lanzamiento inicial

---------------
1. Descripción
---------------
Esta herramienta está pensada para facilitar la conversión de archivos nsp a archivos xci.
Esta herramienta está diseñada en código batch sirviendo de interfaz de intercambio entre los siguientes programas:
a.) hacbuild: Programa para creación de archivos xci mediante archivos nca. Diseñado por LucaFraga
https://github.com/LucaFraga/hacbuild
b.) hactool: Programa cuya función es mostrar la información, desencriptar y extraer diversos tipos de archivos de datos de Nintendo Switch.
Hactool ha sido diseñado por SciresM
https://github.com/SciresM/hactool
c.) nspBuild: Programa destinado a la creación de archivos nsp a partir de archivos nca. 
nspBuild ha sido diseñado por CVFireDragon
https://github.com/CVFireDragon/nspBuild

Aplicación inspirada en "A Simple XCI, NCA, NSP Extracting Batch file (Just Drag and Drop) with Titlekey decrypt"
creada por Bigjokker y publicada en gbatemp:
https://gbatemp.net/threads/a-simple-xci-nca-nsp-extracting-batch-file-just-drag-and-drop-with-titlekey-decrypt.513300/
---------------
2. Requisitos
---------------
- Es necesario emplear un ordenador con sistema operativo windows.
- Es necesario disponer de un archivo keys.txt con las claves necesarias para el funcionamiento de hactool.
- Es necesario tener Python instalado para el funcionamiento de nspbuild
- Es necesario tener instalado al menos net frameworks 4.5.2 para el funcionamiento de hactool.
---------------
3. Funciones
---------------
- Conversión de archivos nsp a xci
- Obtención de archivo nsp de pequeño tamaño (normalmente menos de 1mb) para la instalación de la licencia del juego
- Obtención de archivos game_info.ini a partir de archivos xci
- Los archivos obtenidos no incorporan partición update ni normal siendo más ligeros que un xci normal.
---------------
4. Limitaciones
---------------
- Actualmente los archivos xci solo funcionan en SX OS
- Para la carga de los archivos construídos hace falta tener instalada la licencia del juego (titlekey).
  Esto puede conseguirse de varias formas:
a.) Habiendo sido descargado el juego previamente vía eshop
b.) Habiendo sido instalado previamente el nsp usado para la conversión en la consola. 
    (Solo hace falta que haya sido instalado previamente, no hace falta que esté instalado en la actualidad)
c.) Instalando el archivo de licencia obtenido "título_lc.nsp"
    Este nsp debe de ser instalado mediante el instalador de SX OS    
d.) Para los archivos con 5nca es necesario eliminar el manual
e.) El tiempo de procesado de los juegos de más de 4gb es en proporción más lento debido al fix empleado en hacbuild para darles compatibilidad.
    (Podría ser interesante investigar si existe una forma mejor de procesarlos)
f.) El símbolo "!" da fallo al ser pasado a hacbuild. Evitad usarlo de momento en el nombre de los ficheros.

-----------------------
5. Uso de la aplicación
-----------------------
I.-   Para el correcto funcionamiento de la aplicación introducir archivo "keys.txt" en la carpeta ztools.
      Más información: https://github.com/SciresM/hactool
      Para ello se puede cubrir el archivo "keys_plantilla.txt", renombrar a "keys.txt" e introducir en la carpeta ztools.
II.-  La aplicación crea cartuchos con los datos almacenados en game_info_preset.ini
III.- Para convertir un nsp a xci arrastrar el archivo nsp sobre "XCI_Builder_v0.6.x.bat" y esperar a que se cierre
      la consola de sistema.
IV.-  Se obtendrá una carpeta con el "nombre del archivo original". Dentro habrá dos archivos:
      - "nombre del archivo original"[xcib].xci -> Resultado de la conversión.
      - "nombre del archivo original"[lc].nsp -> Archivo de licencia.
V.-   Los datos del archivo game_info.ini pueden cambiarse manualmente o ser obtenidos de algún xci dumpeado previamente.
      > Para la obtención del archivo "game_info.ini" desde un xci arrastrar el xci sobre "XCI_Builder_v0.6.x.bat".
      > Se obtendrá un archivo .ini con el nombre del juego en la carpeta game_info
      > Sustituir los datos de game_info.ini en la raíz 
VI.-  Instalar archivo [lc].nsp con el instalador de SX OS o versiones antiguas de tinfoil para poder usar el juego xci
      obtenido en SX OS.
------------------
6. Compatibilidad
------------------
Con los cambios añadidos y aceptando las limitaciones descritas este método debería de ser compatible con todos los nsp actuales.
Al menos yo no he encontrado incompatibilidades.
--------------------
7. Agradecimentos a: 
--------------------
LucaFraga, SciresM y CVFireDragon 
Bigjokker de gbatemp por los consejos sobre como limpiar echos en archivos batch.
A todos los miembros de gbatemp, elotrolado.net y a mis amigos de discord ;)
