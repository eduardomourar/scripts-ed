#!/bin/bash
#
# EMR 2012-01-12
# Ubuntu 11.10
#
# Bash script para formatação em UDF de dispositivo USB
# Funciona apenas em pendrives no Mac (10.6), Windows (7) e Linux (Ubuntu 11.10)
#
# Para HD, rodar o perl script "udfhd.pl"
# Use: sudo perl udfhd.pl /dev/disk1 UDF
#
# Necessário pacote udftools 
# Comando: sudo apt-get install udftools
# Necessário privilégio do root
# Comando: sudo su
#
# Sintaxe: formatudf_linux.sh d [n]
# d (drive) - Caminho do dispositivo
# n (name) - Nome do dispositivo, máx 11 caracteres (LinuxUDF)
#
# Help: sudo bash formatudf_linux.sh --help
#
# Exemplo: sudo bash formatudf_linux.sh /dev/sdb LinuxUDF
#
Principal()
{
	if [ "$NAME" = "" ]; then
		NAME="LinuxUDF"
	fi
	if [ "$DRIVE" = "" ]; then
		echo ""
		echo "Para a ajuda use: bash formatudf_linux.sh --help"
		echo ""
		exit 1
	elif [ "$DRIVE" = "--help" ]; then
		Ajuda ;
	else
		echo ""
		echo "Script para formatação em UDF de dispositivo USB."
		echo "-------------------------------------------------"
		echo "                     INÍCIO"
		echo "-------------------------------------------------"

		Formatacao ;

		echo "-------------------------------------------------"
		echo "                     TÉRMINO"
		echo "-------------------------------------------------"
		echo ""
	fi
}
Ajuda()
{
	echo "
Script para formatação em UDF de dispositivo USB
 Necessário pacote udftools 
 Comando: sudo apt-get install udftools
 Necessário privilégio do root
 Comando: sudo su

 Sintaxe: formatudf_linux.sh d [n]
 d (drive) - Caminho do dispositivo
 n (name) - Nome do dispositivo, máx 11 caracteres (LinuxUDF)

 Help:
      sudo bash formatudf_linux.sh --help

 Exemplo:
         sudo bash formatudf_linux.sh /dev/sdb LinuxUDF
"
}
Formatacao()
{
	echo "Formatando dispositivo USB..."

	# Zerando a tabela de partições
	dd if=/dev/zero of=$DRIVE bs=$BS count=1
	sync
	
	# Criando a tabela de partições em MSDOS
	# fdisk commands
	# n - new partition
	# p - primary partition
	# 1 - partition number
	#   - first sector (default value)
	#   - last sector (default value)
	# t - change patition type
	# 60 - raw partition
	# b - W95 FAT32
	# w - write partition table
	#echo "w" | fdisk $DRIVE
	sync

	# Criando a partição UDF
	#mkudffs -b=$BS -r=0x0201 --lvid="$NAME" --vid="$NAME" --vsid="$NAME" --vid="$NAME" --media-type=hd --utf8 ${DRIVE}1
	mkudffs -b=$BS -r=0x0201 --lvid="$NAME" --vid="$NAME" --vsid="$NAME" --vid="$NAME" --media-type=hd --utf8 $DRIVE
	sync
}

# Parâmetros e variáveis globais
DRIVE=$1
NAME=$2
BS=512

# Função principal
Principal
exit 0