#!/bin/bash

# On source un fichier de variables avec les secrets.
# Ce fichier est créé par molécule via la configuration de la box vagrant
source /tmp/ansible_molecule.env

# On utilise les variables et secret si besoin
#

# Une fois utilisé on détruit le fichier et on unset les variables
sudo rm -rf /tmp/ansible_molecule.env


sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y python2.7
