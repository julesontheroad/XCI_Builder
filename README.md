# XCI_Builder
Made by JulesOnTheRoad and first released in elotrolado.net
https://github.com/julesontheroad/XCI_Builder
First official git release
---------------
0. Changelog
---------------
v0.5.0 - First launch in elotrolado.net
v0.5.1 - v0.5.5.1 - Little fixes
v0.6.5 - Lot of changes made to previous version:
  I - Added compatibility with games with more than 5 nca. (Games that include an html manual) 
	The manual was stripped from the game, this doesn't impede game execution. And game is fully functional.
	If you try to access the manual in these kind of games this action won't get any result and you will be able to keep playing.
	Games are fully funtional without manual nca and there are few games that includes it to begin with.
   II - Output route was moved to "output_xcib" so everything is better organiced XCI_Builder can be in the same folder as NX-Trimmer, 
	which now uses el usará "output_nxt" as output folder.
  III - Reformed ztools folder, erasing not needed files. 
   IV - Little mod to hacbuild.exe so it takes "xci_header_key" from ztools. "xci_header_key" it's actually not needed everything works without it 
	but hacbuild gives a warning wich was ugly for the batch output
   V  - Added template for keys.txt and header_key.txt in ztools
   VI - Added tag system for the files output. It goes as follows:
	a) Se eliminan las tags [] de los ficheros. Para eliminar cosas como trimmed.
        b) Se eliminan los caracteres _ (más que nada porque no me gusta como quedan)
	c) Se añade las siguientes tags a la salida.
	   [xcib] xci converted with XCI_Builder
	   [nm] "no manual", manual was erased to get the resulting xci to work
	   [lc] In output nsp refers to the small nsp needed to get the xci to work.
  VII - Added options in batch header. Edit with notepad++ to select them
   a)  "preservemanual" By default 0. Set at 1 if you want the manual nca to not be deleted. If set at 1 the manual will be sent to output folder.
	NOTE1: Is advised to ¡¡NOT INSTALLED the manual .nca!! as the game will give error if you try to access the game manual.
	NOTE2: The xci without manual is completely functional and if manual is selected it won't happened anything. 
	NOTE3: This option is thought for a future xci to nsp converter that will revert the process.
   b)  "delete_brack_tags" Erase [] tags like [trimmed]- By default at 1
   c)  "delete_pa_tags" Erase tags () like (USA) - By default at 0. If activated it could also erase [] tags

NOTE: If upgrading from previous version replace ztools folder hactool version was upgraded and an small modification was made in hacbuild code.

---------------
1. Description
---------------
This tool is thought to clean the update partition from xci files and to reduce the padding used between partitions.
This is a batch application which serves to automate the workflow between the following programs:
a.) hacbuild: Program meant to create xci files from nca files, made by LucaFraga.
https://github.com/LucaFraga/hacbuild
b.) hactool: Program which function is give information, decrypt and extract a lot of different kind of files us by the NX System.
Hactool was made by SciresM
https://github.com/SciresM/hactool
c.) nspBuild: Program meant to create nsp files from nca files. 
nspBuild was made by CVFireDragon
https://github.com/CVFireDragon/nspBuild
NX-Trimmer was also inspired by "A Simple XCI, NCA, NSP Extracting Batch file (Just Drag and Drop) with Titlekey decrypt"
by Bigjokker and published in gbatemp:
https://gbatemp.net/threads/a-simple-xci-nca-nsp-extracting-batch-file-just-drag-and-drop-with-titlekey-decrypt.513300/
---------------
2. Requirements
---------------
- A computer with a Window's OS is needed
- You'll need to complete keys.txt in ztools with the keys needed by hactool.
- Optionally complete header_key.txt with xci_header_key
- You'll need to have Python installed for nspbuild to work correctly
- You'll need to have at least .net frameworks 4.5.2 installed so hacbuild can work correctly.
---------------
3. Funciones
---------------
- Conversion from nsp files to xci files
- Creation of small nsp files (normally less than 1mb) to install game titlekey in the console.
- "game_info" files extraction from xci files
- The xci files created incorporate a blank update and normal partition which makes them smaller than
  tipicall xci files.
---------------
4. Limitations
---------------
- xci files only work with SX OS
- To load the xci files you'll need to get the titlekey which I call license in your NX console. It can be
  achieved in various ways.
a.) Installing the original game previously via eshop
b.) Installing the original nsp previously via devmenu/SX OS/Tinfoil...
    (It doesn't need to be installed in the current moment)
c.) Installing the license file obtained with the programo "game_name[lc].nsp"
    This file needs to be installed with SX OS installer.
d.) For nsp files with more than 5nca is needed to delete the nca manual
e.) Processing times for more than 4gb games is longer than it shoul be proporcionallu. Probably linked to hacbuild fix number 5 regarding the overflow
    error in this kind of files. (Could be interesting to investigate if a fastest processing approach is possible)
f.) The symbol "!" gives error when passed to hacbuild. So rename snipperclips file

-----------------------
5. Use of the application
-----------------------
I.-   First fill "keys.txt" in ztools folder so hactool can work properly.
      More info: https://github.com/SciresM/hactool
II.-  Optionally fill the file header_key.txt in ztools with xci_header_key value
III.- To convert a nsp to xci dragg the nsp file over "XCI_Builder_v0.6.x.bat" and wait for the system window to close
IV.-  You'll get a folder with the name of the game in the output folder. Inside you'll find two files.
      - "game"[xcib].xci -> Converted nsp
      - "game"[lc].nsp -> License file to ge titlekey in the system.
V.-  For game_info.ini you can edit the preset or give it as it is. I'm getting 100% compatibility as it is.
VI.- Install file [lc].nsp with SX OS custom installer or older tinfoil versions
VII. - Load the xci file and enjoy
------------------
6. Compatibility
------------------
With current changes and accepting the described limitations this method should be compatible with all current xci files.
At least I didn't find any issues.
------------------------
7. Thanks and credits to 
------------------------
LucaFraga, SciresM and CVFireDragon 
Also thanks to all members from gbatemp and elotrolado.net

