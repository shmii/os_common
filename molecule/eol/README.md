# Molecule usage for my role

## Usage

to-do

## Examples

to-do

...

### Run for Ansible latest version

```shell
# I'm using latest stable version of Python from my system environement (From distribution repositories) 
pyenv rehash
pyenv shell system
pyenv rehash

# Check which python binary is used
python3 -c "import sys; print(sys.executable)"

# Create VENV if not already created
python3 -m venv ~/.venv/ansible_latest_env

# Source the VENV
source ~/.venv/ansible_latest_env/bin/activate

# Install vagrant (need to upgrade or downgrate depend of the molecule version)
sudo apt-mark unhold vagrant
sudo apt install vagrant
apt show vagrant  # Package: vagrant
                  # Version: 2.4.9-1

vagrant --version # Vagrant 2.4.9

# Reinstall plugins for this version of vagrant
vagrant plugin expunge --reinstall

export $(cat ~/.credentials/ansible_molecule.env | xargs) && molecule create | tee /tmp/create.out
```
