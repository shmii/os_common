# Ansible Role: os-common

Ansible role to configure Linux OS (Security, prerequisite packages and tools, etc ...)

This role :

- Install and configures Essentiels Extra Repositories (epel, powertools)
- Install useful packages or sysadmin tools
- Create base environement for systeme and infra administrators (users, directories, etc ...)
- Create base environement for applications and servicies

## Test and run environement

```bash
$ molecule --version
molecule 6.0.3 using python 3.10 
    ansible:2.16.2
    azure:23.5.0 from molecule_plugins
    containers:23.5.0 from molecule_plugins requiring collections: ansible.posix>=1.3.0 community.docker>=1.9.1 containers.podman>=1.8.1
    default:6.0.3 from molecule
    docker:23.5.0 from molecule_plugins requiring collections: community.docker>=3.0.2 ansible.posix>=1.4.0
    ec2:23.5.0 from molecule_plugins
    gce:23.5.0 from molecule_plugins requiring collections: google.cloud>=1.0.2 community.crypto>=1.8.0
    libvirt:0.0.6 from molecule_libvirt
    podman:2.0.3 from molecule_podman requiring collections: containers.podman>=1.7.0 ansible.posix>=1.3.0
    vagrant:23.5.0 from molecule_plugins
```

## Requirements

### Requirements on runner

- ansible >= 2.16
- python >= 3.10

### Requirements on targets

- Python >= Python2.7 or >= Python3.16
- Python-apt (depended of your python version)

## Role Variables

Role Variables are listed below, along with default values (see `defaults/main.yml`):

### os_common

All roles variables are regrouped on the `os_common` dictionary.
By default role provide an empty `os_common` dictionary.

### os_app_directories

Use `os_common.directories` dictionary to define applications direcories.

```yaml
os_common:

  ...

  directories:
    - path: /app
      owner: "root"
      group: "root"
      mode: 755
    - path: /app/infra
      owner: "root"
      group: "root"
      mode: 755
    - path: /app/test
      owner: "root"
      group: "root"
      mode: 755

  ...

```

## Dependencies

None.

## Example Playbook

```yaml
    - hosts: server
      roles:
        - { role: shmii.os-common }
```

## Warning / known bugs

/!\ To validate this role with "molecule" from Ubuntu @ WSL/WSL2 it is necessary to create the folder  `/sys/fs/cgroup/systemd` on the host linux subsystem.

`sudo mkdir /sys/fs/cgroup/systemd`

This directory is necessary for some os (RHEL9, Rocky9, etc...) and not existing on local Ubuntu WSL sub Systeme.

## Sources and Bibliography

Redde Caesari quae sunt Caesaris, et quae sunt Dei Deo !

- Jeff GEERLING ( <https://www.linkedin.com/in/jeff-geerling>  --- <https://github.com/geerlingguy>)
- Stephane ROBERT ( <https://www.linkedin.com/in/stephanerobert1>  ---  <https://blog.stephane-robert.info>)
- Robert de BOCK ( <https://github.com/robertdebock>  --- <https://github.com/geerlingguy>)

## License

GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

## Author Information

This role was created in 2022 by [Thomas CHALMEL] (<https://www.thomas.chalmel.org/>).
