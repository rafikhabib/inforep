#!/bin/bash

Afficher_menu_graph(){
if [ -f "$1" ]; then
  Afficher_menu_graph_fichier $1
elif [ -d "$1" ]; then
  Afficher_menu_graph_dossier $1
else
  echo "L'argument n'est pas ni fichier ni dossier"
fi
}


Afficher_menu_graph_dossier() {

while true; do
  echo "Menu:"
  echo "1) Afficher nombre de fichiers"
  echo "2) Afficher nombre de dossiers"
  echo "3) Afficher les types de fichiers"
  echo "4) Afficher les droits d'access"
  echo "5) Afficher les proprietaires de fichiers"
  echo "6) Afficher les statistique de dossier"
  echo "Q) Quitter"
  read -p "Entrez votre choix: " choice
  case $choice in
    1) yad --text-info --width=200 --height=100 --title="Message" --center --text="$(AfficheNbF $1)"
	exit 1;;
    2) yad --text-info --width=200 --height=100 --title="Message" --center --text="$(AfficheNbD $1)"
	exit 1;;
    3) yad --text-info --width=200 --height=100 --title="Message" --center --text="$(TypeFiles $1)"
	exit 1;;
    4) yad --text-info --width=200 --height=100 --title="Message" --center --text="$(AccessFiles $1)"
	exit 1;;
    5) yad --text-info --width=200 --height=100 --title="Message" --center --text="$(PropFiles $1)"
	exit 1;;
    6) stat $1;;
    [Qq]*) exit 0 ;;
    *) echo "Choix invalide ,veuillez ressayer";;
  esac
done
}


Afficher_menu_graph_fichier() {
while true; do
  echo "Menu:"
  echo "1) Afficher le type de fichier"
  echo "2) Afficher les droits d'access de fichier"
  echo "3) Afficher le proprietaire et groupe de fichier"
  echo "4) Afficher qui a le droit d'ecriture dans le fichier"
  echo "Q) Quitter"
  read -p "Entrez votre choix: " choice
  case $choice in
    1)yad --text-info --width=200 --height=100 --title="Message" --center --text="$(TypeFile $1)"
	exit 1;;
    2) yad --text-info --width=200 --height=100 --title="Message" --center --text="$(AccessFile $1)"
	exit 1;;
    3) yad --text-info --width=200 --height=100 --title="Message" --center --text="$(PropFile $1)"
	exit 1;;
    4) yad --text-info --width=200 --height=100 --title="Message" --center --text="$(Ecriture $1)"
	exit 1;;
    [Qq]*) exit 0 ;;
    *) echo "Choix invalide ,veuillez ressayer";;
  esac
done
}


Afficher_menu_txt(){
if [ -f "$1" ]; then
  Afficher_menu_txt_fichier $1
elif [ -d "$1" ]; then
  Afficher_menu_txt_dossier $1
else
  echo "L'argument n'est pas ni fichier ni dossier"
fi
}


Afficher_menu_txt_fichier() {
while true; do
  echo "Menu:"
  echo "1) Afficher le type de fichier"
  echo "2) Afficher les droits d'access de fichier"
  echo "3) Afficher le proprietaire et groupe de fichier"
  echo "4) Afficher qui a le droit d'ecriture dans le fichier"
  echo "Q) Quitter"
  read -p "Entrez votre choix: " choice
  case $choice in
    1) TypeFile $1;;
    2) AccessFile $1;;
    3) PropFile $1;;
    4) Ecriture $1;;
    [Qq]*) exit 0 ;;
    *) echo "Choix invalide ,veuillez ressayer";;
  esac
done
}


Afficher_menu_txt_dossier() {
while true; do
  echo "Menu:"
  echo "1) Afficher nombre de fichiers"
  echo "2) Afficher nombre de dossiers"
  echo "3) Afficher les types de fichiers"
  echo "4) Afficher les droits d'access"
  echo "5) Afficher les proprietaires de fichiers"
  echo "6) Afficher les statistique de dossier"
  echo "Q) Quitter"
  read -p "Entrez votre choix: " choice
  case $choice in
    1) AfficheNbF $1;;
    2) AfficheNbD $1;;
    3) TypeFiles $1;;
    4) AccessFiles $1;;
    5) PropFiles $1;;
    6) stat $1;;
    [Qq]*) exit 0 ;;
    *) echo "Choix invalide ,veuillez ressayer";;
  esac
done
}


help(){
echo "Pour afficher le help détaillé à partir d’un fichier texte: ./inforep.sh -h
Pour afficher un menu textuel et gérer les fonctionnalité de façon graphique: 
./inforep.sh -g [dossier ou fichier]
Pour afficher le nom des auteurs et version du code: ./inforep.sh -v                     
Pour afficher un menu textuel: ./inforep.sh -m [dossier ou fichier]
">helpInforep.txt
cat helpInforep.txt

}
show_usage(){
echo "inforep.sh: [-h][-g][-v][-m] fichier/dossier"
}

#fonstions dossiers
AfficheNbF(){
echo "Nombre de fichers dans $1"
ls -l $1|grep -vE "^d"|wc -l
}

AfficheNbD(){
echo "Nombre de dossiers dans $1"
ls -l $1|grep -E "^d"|wc -l
}

TypeFiles(){
echo "Types de fichiers dans $1"
echo `ls -1 $1|while read fichier; do file "$1/$fichier"; done|grep -vE "directory"`
}

AccessFiles(){
echo "Les access pour les fichiers dans $1"
ls -l $1|grep -vE "^d"|while read line; do echo "$(echo $line|rev|cut -d ' ' -f1|rev) $( echo $line|cut -d ' ' -f1)";done
}

PropFiles(){
echo "Les proprietaires des fichier dans $1"
ls -l $1|grep -vE "^d"|while read line; do echo "$(echo $line|rev|cut -d ' ' -f1|rev) $( echo $line|cut -d ' ' -f3)";done
}

stat(){
nbf=`ls -l $1|grep -vE "^d"|wc -l`
nbd=`ls -l $1|grep -E "^d"|wc -l`
echo "0 NombreDossiers $nbd">data.dat
echo "1 NombreFichiers $nbf">>data.dat
echo "2 other 0">>data.dat
echo "set term png">commands.txt
echo 'set output "graph.png"'>>commands.txt
echo "set boxwidth 0.5">>commands.txt
echo "set style fill solid">>commands.txt
echo 'plot "data.dat" using 1:3:xtic(2) with boxes'>>commands.txt
gnuplot "commands.txt"
shotwell graph.png
}

#fonctions fichiers

TypeFile(){
echo "type de fichier"
file $1
}

AccessFile(){
echo "access du fichier $1"
ls -l $1|cut -d' ' -f1
}

PropFile(){
echo "proprietaire et group  de fichier"
ls -l $1|cut -d' ' -f3,4
}

Ecriture(){
acc=`ls -l $1|cut -d' ' -f1`
if [ "${acc:2:1}" == "w" ]; then
	echo "Utilisateur proprietaire a le droit d'ecriture"
else
	echo "Utilisateur proprietaire n'a pas le droit d'ecriture"
fi

if [ "${acc:5:1}" == "w" ]; then
        echo "Le groupe a le droit d'ecriture"
else
        echo "Le groupe n'a pas le droit d'ecriture"
fi

if [ "${acc:8:1}" == "w" ]; then
        echo "Les autres ont le droit d'ecriture"
else
        echo "Les autres n'ont pas le droit d'ecriture"
fi


}
if [[ $# -eq 0 ]]; then
show_usage 2>&1
exit 0
fi

while getopts "hgvm" option
do

case $option in
	h)
	help;;
	v)
	echo "Auteurs: Rafik Lahbib et Achref Hamzaoui"
	echo "Version: 1.0";;
	m)
	Afficher_menu_txt $2;;
	g)
	Afficher_menu_graph $2;;
esac
done