#!/bin/bash

# On source un fichier de variables avec les secrets.
# Ce fichier est créé par molécule via la configuration de la box vagrant


source /tmp/ansible_molecule.env
sudo subscription-manager register --username="$RHEL_ACCOUNT_USER" --password="$RHEL_ACCOUNT_PASSWORD"

# Une fois utilisé on détruit le fichier et on unset les variables

sudo rm -rf /tmp/ansible_molecule.env
unset RHEL_ACCOUNT_USER
unset RHEL_ACCOUNT_PASSWORD

sudo dnf module enable -y python39
sudo dnf install -y python39 
sudo dnf install -y python3-dnf

#dnf install -y insights-client 
#insights-client --register
