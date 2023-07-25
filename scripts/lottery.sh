#!/bin/bash

#####################################################################
# Script lottery.sh pour filtrer des noms à partir d'un JSON        #
#                                                                   #
# Description :                                                     #
# Ce script récupère un JSON à partir de l'URL                       #
# "https://api.multiversx.com/collections/DUSTYBONES-c1fc90/nfts?size=666".     #
# Ensuite, il filtre les objets dont le champ "timestamp" est        #
# supérieur à une date donnée. Le nom des objets filtrés est         #
# extrait et affiché sous forme de liste JSON. Si aucune date        #
# n'est spécifiée en argument, le script utilisera la date et        #
# l'heure actuelles pour filtrer les noms.                           #
#                                                                   #
# Utilisation :                                                     #
# ./lottery.sh [date_reference]                                     #
#                                                                   #
# Arguments :                                                       #
#  date_reference (optionnel) : Date de référence au format         #
#                               "YYYY-MM-DDTHH:MM:SSZ" en UTC.      #
#                               Si omis, la date et l'heure actuelles#
#                               seront utilisées comme référence.   #
#                                                                   #
# Exemples :                                                        #
# ./lottery.sh 2023-03-03T23:00:00Z                                 #
# ./lottery.sh                                                      #
#####################################################################


# Récupération de la date depuis le premier argument ou utilisation de "now" par défaut
ref_date=${1:-"now"}

# Vérification si l'argument est "now", auquel cas on met à jour la variable avec la date actuelle
if [ "$ref_date" = "now" ]; then
  ref_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
fi

# Utilisation de curl pour récupérer le contenu JSON
# jq pour filtrer les éléments avec un timestamp supérieur à la date de référence
# jq pour ajouter manuellement les OGs
# shuf pour mélanger les noms et afficher un nom aléatoire, le gagnant
curl -s -X 'GET' 'https://api.multiversx.com/collections/DUSTYBONES-c1fc90/nfts?size=666' -H 'accept: application/json' \
  | jq --arg ref_date "$ref_date" 'map(select(.timestamp > ($ref_date | strptime("%Y-%m-%dT%H:%M:%SZ") | mktime))) | .[].name' \
  | jq --slurp '. + ["OG #1", "OG #2", "OG #3", "OG #4", "OG #5", "OG #6", "OG #7", "OG #8", "OG #9", "OG #10"]' \
  | jq .[] \
  | shuf -n 1
