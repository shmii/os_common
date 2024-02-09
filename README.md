# Ansible Role: os-common

Ansible role to configure Linux OS (Security, prerequisite packages and tools, etc ...)

This role :

- Manage Essentiels Extra Repositories (epel, powertools)
- Manage useful Packages and sysadmin tools (through the default `__os_common_tools_packages` dictionary)
- Manage base operating system (OS) configuration (groups, users, directories, LVM, etc ...)
  - Manage operating system groups (through the `os_common.groups` dictionary)
  - Manage operating system users (through the `os_common.users` dictionary)
  - Manage operating system directories (through the `os_common.directories` dictionary)
  - Manage whole operating system LVM (disks, pv, vg, lv, and partitions) (through the `os_common.vgs`, and `os_common.disks` dictionaries)

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

## The role variables

Role Variables are listed below, along with default values (see `defaults/main.yml`).

### `os_common`
*<span style="color: #7f00ff">dictionary</span>*
Most of roles variables are regrouped on the `os_common` dictionary.
*The `os_common` dictionary is not mendatory.*
By default role provide an empty `os_common` dictionary.

#### `os_common.groups_create`
*<span style="color: #7f00ff">boolean</span>*
Use the `os_common.groups_create` variable to choose if you want to manage all groups.
**Choices:**
**<span style="color: #FF0000">- true ← (default) </span>**
<span style="color: #0000FF">- false </span>

#### `os_common.groups`
*<span style="color: #7f00ff">list of `group` dictionaries</span>*
Use `os_common.groups` dictionary to manage groups.
It provide a list of `group` dictionary with it **`name`** and these defined parameters.
(With usage defined on the `ansible.builtin.group` module documentation page)

**Dictionary `group` Parameters :**
| Parameters      |    Comments    |
|:----------------|:---------------|
| **name** <br><span style="color: #7f00ff">boolean</span> / **<span style="color: #FF0000">required</span>**|  Name of the group to manage.|
| **force** <br><span style="color: #7f00ff">boolean</span> |  Whether to delete a group even if it is the primary group of a user.<br>Only applicable on platforms which implement a –force flag on the group deletion command.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **gid** <br><span style="color: #7f00ff">integer</span> |  Optional GID to set for the group.|
| **local** <br><span style="color: #7f00ff">boolean</span> |  Forces the use of “local” command alternatives on platforms that implement it.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **non_unique** <br><span style="color: #7f00ff">boolean</span> |  This option allows to change the group ID to a non-unique value. Requires `gid`.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **state** <br><span style="color: #7f00ff">string</span> |  Whether the group should be present or not on the remote host.<br> **Choices:** <br>**<span style="color: #0000FF">- "present" ← (default)</span>**<br><span style="color: #FF0000"> - "absent" </span>|
| **system** <br><span style="color: #7f00ff">boolean</span> |  If `true`, indicates that the group created is a system group.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **create** <br><span style="color: #7f00ff">boolean</span> |  Used to manage or ignore this specifique group.<br>**Choices:**<br>**<span style="color: #FF0000">- true ← (default) </span>** <br><span style="color: #0000FF">- false </span>|

Example :

```yaml
os_common:
  ...
  groups:
    - name: group_one
      gid: '1042'
    - name: group_two
    - name: 'group_three'
      system: true
    - name: group_four
      state: absent
      force: true
    - name: group_five
      create: true
    - name: group_six
      create: false
  ...
```

#### `os_common.users_create`
*<span style="color: #7f00ff">boolean</span>*
Use the `os_common.users_create` variable to choose if you want to manage all users.
**Choices:**
**<span style="color: #FF0000">- true ← (default) </span>**
<span style="color: #0000FF">- false </span>

#### `os_common.groups`
*<span style="color: #7f00ff">list of `group` dictionaries</span>*
Use `os_common.groups` dictionary to manage groups.
It provide a list of `group` dictionary with it **`name`** and these defined parameters.
(With usage defined on the `ansible.builtin.group` module documentation page)

**Dictionary `group` Parameters :**
| Parameters      |    Comments    |
|:----------------|:---------------|
| **name** <br><span style="color: #7f00ff">boolean</span> / **<span style="color: #FF0000">required</span>**|  Name of the group to manage.|
| **force** <br><span style="color: #7f00ff">boolean</span> |  Whether to delete a group even if it is the primary group of a user.<br>Only applicable on platforms which implement a –force flag on the group deletion command.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **gid** <br><span style="color: #7f00ff">integer</span> |  Optional GID to set for the group.|
| **local** <br><span style="color: #7f00ff">boolean</span> |  Forces the use of “local” command alternatives on platforms that implement it.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **non_unique** <br><span style="color: #7f00ff">boolean</span> |  This option allows to change the group ID to a non-unique value. Requires `gid`.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **state** <br><span style="color: #7f00ff">string</span> |  Whether the group should be present or not on the remote host.<br> **Choices:** <br>**<span style="color: #0000FF">- "present" ← (default)</span>**<br><span style="color: #FF0000"> - "absent" </span>|
| **system** <br><span style="color: #7f00ff">boolean</span> |  If `true`, indicates that the group created is a system group.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **create** <br><span style="color: #7f00ff">boolean</span> |  Used to manage or ignore this specifique group.<br>**Choices:**<br>**<span style="color: #FF0000">- true ← (default) </span>** <br><span style="color: #0000FF">- false </span>|

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
