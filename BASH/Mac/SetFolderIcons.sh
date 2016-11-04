#!/bin/bash
#
# EMR 2016-11-03
# MacOS 10.12
#
# Bash script to set folders icons in MacOS
#

DRIVE_PATH="/Volumes/EC_1TB"
DRIVE_COLOR="DriveBlue"

cd $DRIVE_PATH

# Take an image and make the image its own icon
sips -i _Arquivos/Sistema/Configura/Icones/$DRIVE_COLOR.icns

# Extract the icon to its own resource file
DeRez -only icns _Arquivos/Sistema/Configura/Icones/$DRIVE_COLOR.icns > tmpicns.rsrc

# Append a resource to the folder you want to icon-ize
Rez -append tmpicns.rsrc -o $DRIVE_PATH$'/Icon\r'

# Use the resource to set the icon
SetFile -a C $DRIVE_PATH

# Hide the Icon\r file from Finder
SetFile -a V $DRIVE_PATH$'/Icon\r'


sips -i _Arquivos/Sistema/Configura/Icones/Arquivos.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Arquivos.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Icon\r'
SetFile -a C _Arquivos/
SetFile -a V $'_Arquivos/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Inbox.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Inbox.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/_Inbox/Icon\r'
SetFile -a C _Arquivos/_Inbox/
SetFile -a V $'_Arquivos/_Inbox/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Pessoal.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Pessoal.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Pessoal/Icon\r'
SetFile -a C _Arquivos/Pessoal/
SetFile -a V $'_Arquivos/Pessoal/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Familia.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Familia.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Pessoal/_Familia/Icon\r'
SetFile -a C _Arquivos/Pessoal/_Familia/
SetFile -a V $'_Arquivos/Pessoal/_Familia/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Docs.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Docs.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Pessoal/Docs/Icon\r'
SetFile -a C _Arquivos/Pessoal/Docs/
SetFile -a V $'_Arquivos/Pessoal/Docs/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Interesse.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Interesse.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Pessoal/Interesse/Icon\r'
SetFile -a C _Arquivos/Pessoal/Interesse/
SetFile -a V $'_Arquivos/Pessoal/Interesse/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Multimidia.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Multimidia.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Pessoal/Multimidia/Icon\r'
SetFile -a C _Arquivos/Pessoal/Multimidia/
SetFile -a V $'_Arquivos/Pessoal/Multimidia/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Profissional.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Profissional.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Profissional/Icon\r'
SetFile -a C _Arquivos/Profissional/
SetFile -a V $'_Arquivos/Profissional/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Academia.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Academia.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Profissional/Academia/Icon\r'
SetFile -a C _Arquivos/Profissional/Academia/
SetFile -a V $'_Arquivos/Profissional/Academia/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Concurso.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Concurso.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Profissional/Concurso/Icon\r'
SetFile -a C _Arquivos/Profissional/Concurso/
SetFile -a V $'_Arquivos/Profissional/Concurso/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Trabalho.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Trabalho.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Profissional/Trabalho/Icon\r'
SetFile -a C _Arquivos/Profissional/Trabalho/
SetFile -a V $'_Arquivos/Profissional/Trabalho/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Sistema.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Sistema.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Sistema/Icon\r'
SetFile -a C _Arquivos/Sistema/
SetFile -a V $'_Arquivos/Sistema/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Configura.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Configura.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Sistema/Configura/Icon\r'
SetFile -a C _Arquivos/Sistema/Configura/
SetFile -a V $'_Arquivos/Sistema/Configura/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Instala.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Instala.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Sistema/Instala/Icon\r'
SetFile -a C _Arquivos/Sistema/Instala/
SetFile -a V $'_Arquivos/Sistema/Instala/Icon\r'

sips -i _Arquivos/Sistema/Configura/Icones/Programa.icns
DeRez -only icns _Arquivos/Sistema/Configura/Icones/Programa.icns > tmpicns.rsrc
Rez -append tmpicns.rsrc -o $'_Arquivos/Sistema/Programa/Icon\r'
SetFile -a C _Arquivos/Sistema/Programa/
SetFile -a V $'_Arquivos/Sistema/Programa/Icon\r'

# clean up
rm tmpicns.rsrc
