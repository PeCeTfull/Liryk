# Liryk #

Liryk is a program designed for vintage PCs in mind for displaying a list of tracks from Polish radio stations broadcast recently or earlier. For this purpose, the application connects to ods.lynx.re API that retrieves all music tracks according to the selected period that were then registered by the Odsluchane.eu service. Liryk was written in Delphi.

### Getting to work in Windows NT 3.51 ###

In order to make the software work properly on your Windows NT 3.51 computer, you must have Service Pack 5 installed and WININET.DLL. The library can be added to the system by e.g. installing Office 97.

### Handling the program ###

Before the first search, you must download a list of radio stations currently available at Odsluchane.eu. You can do this by going to the Region menu and clicking "Aktualizuj liste stacji radiowych" (Update radio station list) or pressing the Alt+U key combination. If the update was successful, you should be able to select any station from the list.

After choosing your radio station, you can also change your desired date and time range. After making all the decisions, you can perform a search – it can be done by selecting "Szukaj" (Search) from the Plik (File) menu, pressing F3 or just by clicking the binoculars button on the bar below the main menu of the application. After successful operation, the program will display all the tracks played by the selected radio station for the given period. After selecting one of them, you can copy it to the Clipboard using Ctrl+C or the "Kopiuj" (Copy) command from the Edycja (Edit) menu.

If there is a new station added to Odsluchane.eu, you have to update the list again to be able to select it on Liryk.

### Recommended programming setup ###

Source and target OS: Windows

IDE: Delphi 6 (initially created this project using Delphi 6 Personal)

Additional components required: 

* HTTPGet component for Delphi 32 v1.94: http://delphi.icm.edu.pl/ftp/d20free/HTTPGet.zip
* LkJSON v0.99: https://sourceforge.net/projects/lkjson/files/lkJSON/version%200.99/lkJSON-0.99.zip/download

### Program licence ###

Liryk is published under MIT+CC, i.e. the MIT License with the Commons Clause. According to these terms, this software can be freely used, copied, modified, merged, published, distributed and sublicensed provided that the already existing copyrights are kept whereas charging any fees for the rights given by the licence is forbidden. Please refer to the LICENSE.txt file of this repository for more information regarding it.