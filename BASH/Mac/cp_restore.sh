#!/bin/bash
#
# EMR 2013-01-22
# OSX 10.8
#
# Bash script para restauração de backup do HD externo formatado em UDF
#
# Formatar HD, rodando o perl script "formatudf.pl"
# Use: sudo perl formatudf.pl /dev/disk1 HD UDF 1000204886016
#
# Necessário privilégio do root
# Comando: sudo su
#
# Sintaxe: cp_restore.sh d1 d2 [d3]
# d1 (drive1) - Caminho para copiar restore
# d2 (drive2) - Caminho com arquivos a serem copiados
# d3 (drive3) - Caminho com estrutura de pastas
#
# Help: sudo bash cp_restore.sh --help
#
# Exemplo: sudo bash cp_restore.sh /Volumes/UDF/ ~/Desktop/UDF/ ~/Desktop/UDF_ESTRUTURA/
#
Principal()
{
	clear;
	if [ "$DRIVE1" = "" ] || [ "$DRIVE2" = "" ]; then
		echo ""
		echo "Para a ajuda use: bash $0 --help"
		echo ""
		exit 1
	elif [ "$DRIVE1" = "--help" ]; then
		Ajuda ;
	else
		echo ""
		echo "Script para restauração de backup do HD externo formatado em UDF."
		echo "-------------------------------------------------"
		echo "                     INÍCIO"
		echo "-------------------------------------------------"

		Restaurando ;

		echo "-------------------------------------------------"
		echo "                     TÉRMINO"
		echo "-------------------------------------------------"
		echo ""
	fi
}
Ajuda()
{
	echo ""
 	echo "Script para restauração de backup do HD externo formatado em UDF"
	echo "Necessário privilégio do root"
	echo ""
	echo "Sintaxe: scriptRestore.sh d1 d2 [d3]"
	echo "d1 (drive1) - Caminho para copiar restore"
	echo "d2 (drive2) - Caminho com arquivos a serem copiados"
	echo "d3 (drive3) - Caminho com estrutura de pastas"
	echo ""
	echo "Help:"
	echo "    sudo bash $0 --help"
	echo ""
	echo "Exemplo:"
	echo "    sudo bash $0 /Volumes/UDF/ ~/Desktop/UDF/ ~/Desktop/UDF_ESTRUTURA/"
	echo ""
}
Restaurando()
{
	if [ "$DRIVE3" = "" ]; then
		echo "Restaurando estrutura de pastas e arquivos..."
		cp -av $DRIVE2/* $DRIVE1/ 2> outputErro.txt
		sync
	else
		echo "Restaurando estrutura de pastas..."
		cp -av $DRIVE3/* $DRIVE1/ 2> outputErro.txt
		sync
		
		echo "Restaurando arquivos..."
		cp -anv $DRIVE2/* $DRIVE1/ 2>> outputErro.txt
		sync
	fi
	echo "Disabilitando lixeiras..."
	mdutil -i off $DRIVE1/
	cd $DRIVE1/
# 		rm -r $DRIVE1/.Trash*/ 2>> outputErro.txt
# 		touch $DRIVE1/.Trash*/ 2>> outputErro.txt

	rm -rf {\$RECYCLE.BIN,.{,_.}{fseventsd,Spotlight-V*,Trashes}} 2>> outputErro.txt
	mkdir .fseventsd 2>> outputErro.txt
	touch .fseventsd/no_log .metadata_never_index .Trashes \$RECYCLE.BIN 2>> outputErro.txt
# 		chflags hidden \$RECYCLE.BIN
}

# Parâmetros e variáveis globais
DRIVE1=$1
DRIVE2=$2
DRIVE3=$3

# Função principal
Principal
exit 0
