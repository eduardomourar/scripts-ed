#!/bin/bash
#
# EMR 2012-01-16
# Mac OS X 10.6.8
#
# Bash script para formatação em UDF de dispositivo USB
# Funciona apenas em pendrives no Mac (10.6), Windows (7) e Linux (Ubuntu 11.10)
#
# Para HD, rodar o perl script "udfhd.pl"
# Use: sudo perl udfhd.pl /dev/disk1 UDF
#
# Necessário privilégio do root
# Comando: sudo su
#
# Sintaxe: formatudf_mac.sh d [n]
# d (DRIVE) - Caminho do dispositivo
# n (NAME) - Nome do dispositivo, máx 11 caracteres (MacUDF)
#
# Help: sudo bash formatudf_mac.sh --help
#
# Exemplo: sudo bash formatudf_mac.sh /dev/disk1 MacUDF
#
Principal()
{
	if [ "$NAME" = "" ]; then
		NAME="MacUDF"
	fi
	if [ "$TYPE" = "" ]; then
		TYPE="h"
	fi
	if [ "$DRIVE" = "" ]; then
		echo ""
		echo "Para a ajuda use: bash formatudf_mac.sh --help"
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
 Necessário privilégio do root

 Sintaxe: formatudf_mac.sh d [n]
 d (drive) - Caminho do dispositivo
 n (name) - Nome do dispositivo, máx 11 caracteres (MacUDF)
 
 Help:
      sudo bash formatudf_mac.sh --help

 Exemplo:
         sudo bash formatudf_mac.sh /dev/disk1 MacUDF
"
}
Formatacao()
{
	echo "Formatando dispositivo USB..."

	# Zerando a tabela de partições
	diskutil unmountDisk $DRIVE
	dd if=/dev/zero of=$DRIVE bs=$BS count=1
	#diskutil unmountDisk /dev/disk2
	#dd if=/dev/zero of=/dev/disk2 bs=512 count=1
	#diskutil eraseDisk MS-DOS "MacUDF" MBRFormat /dev/disk2
	sync
	
	# Criando a tabela de partições em MSDOS
	#diskutil eraseDisk "MS-DOS" "$NAME" MBRFormat $DRIVE
	#diskutil partitionDisk $DRIVE 1 MBRFormat
	#echo "y" | fdisk -i $DRIVE
	sync
	diskutil unmountDisk $DRIVE
	
	# Criando a partição UDF
	#newfs_udf -b $BS -v "$NAME" -m blk -r 2.01 ${DRIVE}s1
	newfs_udf -b $BS -v "$NAME" -m blk -r 2.01 ${DRIVE}
	sync
}

# Parâmetros e variáveis globais
DRIVE=$1
NAME=$2
BS=512

# Função principal
Principal
exit 0