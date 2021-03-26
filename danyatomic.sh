#!/bin/bash

# TITRE: DanyAtomic
#================================================================#
# DESCRIPTION:
# Ce script va nous permettre de formater des périphériques en
# Fat32, NTFS et Ext4.
#----------------------------------------------------------------#
# AUTEURS:
#  Daniel DOS SANTOS < danielitto91@gmail.com >
#----------------------------------------------------------------#
# DATE DE CRÉATION: 14/07/2018
#----------------------------------------------------------------#
# USAGE: ./danyatomic.sh
#----------------------------------------------------------------#
# NOTES:
# Les différends tests intégrés au programme :
#  * Teste si un champ saisi par l'utilisateur est vide.
#  * Teste si l'utilisateur a saisi un champ valide.
#----------------------------------------------------------------#
# BASH VERSION: GNU bash 4.4.12
#================================================================#
zenity --info --title="Mises à jour" --text="Mise à jour en cous !!"

#apt-get install zenity* -y 
#aptitude install zenity* -y

ban=$(echo "DanyAtomic est un programme vous permettant de formater des périphériques\n\n")
disk=$(echo "Liste des disques\n\n")
#sdx="$(lsblk | grep sd)"
a=$(echo "\n\nDéfinir la clef USB a formater, exemple\: sda")
#choix=$(zenity --forms \
#--title="DanyAtomic" \
#--text="<big>$ban</big> <u><b>$disk</b></u> $sdx <u><b>$a</b></u>" \
#--add-entry="La clef :" \
#)
lsblk | grep ^sd[a-z] > fic

i=1

while read ligne
do
{
ta[$i]=$ligne
i=$(expr $i + 1)
}
done < fic

choix=$(zenity --list --title="Les différents périphériques de stockage" \
--column="Disques" \
Disque_1 "${ta[1]}" \
Disque_2 "${ta[2]}" \
Disque_3 "${ta[3]}" \
Disque_4 "${ta[4]}" \
Disque_5 "${ta[5]}" \
Disque_6 "${ta[6]}")

if [ $? == 0 ]
then
	choix="$(echo $choix | cut -c1-3)"
	echo $choix
	echo $choix
	if [[ $choix =~ ^sd[a-z] ]]
	then
		fic=$(zenity --entry --title="Systèmes de fichiers" --text="Veuillez indiquer le système de fichier" ext4 fat32 ntfs)
		if [ $? == 0 ]
		then
			case $fic in
				ext4)
				umount /dev/$choix
				mke2fs -qF -t $fic /dev/$choix
				;;
				fat32)
				umount /dev/$choix
				mkfs.fat -I -F 32 /dev/$choix
				;;
				ntfs)
				umount /dev/$choix
				mke2fs -qF -t $fic /dev/$choix
				;;
				*) $erreur=$(zenity --error \
				           --text "Attention erreur de syntax\nIndiquez une entrée valide ext4,ntfs,fat32....!")
				           exit 0 ;;
			esac
	sleep 2
	zenity --info --text "Formatage terminé!\n\n Veuillez enlever la clef et la remetre pour le montage!"
		else
			$non=$(zenity --error \
			     --text "Fin du programme !"
			     exit 0)
		fi
	else
		$erreur=$(zenity --error \
	        	   --text "Attention erreur de syntaxe\nIndiquez une entrée valide sda,sdb,sdc....!"
	        	   exit 0)
	fi
else
	$non=$(zenity --error \
	       --text "Fin du programme !"
	       exit 0)
fi
