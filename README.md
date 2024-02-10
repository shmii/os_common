# Ansible Role: `os_common`

---

## The `os_common` Role

Ansible role to configure Linux OS (Security, prerequisite packages and tools, etc ...)

This role :

- Manage Essentiels Extra Repositories (epel, powertools)
- Manage useful Packages and sysadmin tools (through the default `__os_common_tools_packages` dictionary)
- Manage base operating system (OS) configuration (groups, users, directories, LVM, etc ...)
  - Manage operating system groups (through the `os_common.groups` dictionary)
  - Manage operating system users (through the `os_common.users` dictionary)
  - Manage operating system directories (through the `os_common.directories` dictionary)
  - Manage whole operating system LVM (disks, pv, vg, lv, and partitions) (through the `os_common.vgs`, and `os_common.disks` dictionaries)

---

## Requirements

### Requirements on runner

```bash
$ ansible --version
ansible [core 2.16.3]
  ...
  python version = 3.10.12 (main, Nov 20 2023, 15:14:05) [GCC 11.4.0] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = True
```

### Requirements on targets

```bash
 - Python >= Python2.7 or >= Python3.16
 - Python-apt (depended of your python version)
```

### Requirements on Test and run environement

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

---

## The role variables

Role Variables are listed below, along with default values (see `defaults/main.yml`).

### The role dictionary : *`os_common`*

**`os_common`**
*<span style="color: #7F00FF">dictionary</span>*

Most of roles variables are regrouped on the `os_common` dictionary.
*The `os_common` dictionary is not mendatory.*
By default role provide an empty `os_common` dictionary.

#### Manage `groups`

##### Enable the groups management : `os_common.groups_manage`

**`os_common.groups_manage`**
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.groups_manage` variable to chose if you want to manage groups.
**Choices:**
**<span style="color: #FF0000">- true ← (default) </span>**
<span style="color: #0000FF">- false </span>

##### The groups management : `os_common.groups`

`os_common.groups`
*<span style="color: #7F00FF">list of dictionaries</span>*

Use `os_common.groups` list of dictionary to manage groups.
It provide a list of `group` dictionary with it **`name`** and it defined parameters. All `ansible.builtin.group` variables can be used.
:warning: Not all available variables are specified below.  Refer to the `ansible.builtin.group`  [:link:][Ansible-Module-ansible.builtin.group] module documentation page to see all available variables and their uses.

**The Dictionary `group` parameters :**

| Parameters      |    Comments    |
|:----------------|:---------------|
| **manage** (`group`) <br><span style="color: #7F00FF">boolean</span> |  *<span style="color: #008800">Role Specific Variable</span>* <br>Used to manage or ignore this specifique `group`.<br>**Choices:**<br>**<span style="color: #FF0000">- true ← (default) </span>** <br><span style="color: #0000FF">- false </span>|
| **name** <br><span style="color: #7F00FF">boolean</span> / **<span style="color: #FF0000">required</span>**|  Name of the group to manage (create, remove or modify).|
| **force** <br><span style="color: #7F00FF">boolean</span> |  Whether to delete a group even if it is the primary group of a user.<br>Only applicable on platforms which implement a –force flag on the group deletion command.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **gid** <br><span style="color: #7F00FF">integer</span> |  Optional GID to set for the group.|
| **local** <br><span style="color: #7F00FF">boolean</span> |  Forces the use of “local” command alternatives on platforms that implement it.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **non_unique** <br><span style="color: #7F00FF">boolean</span> |  This option allows to change the group ID to a non-unique value. Requires `gid`.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|
| **state** <br><span style="color: #7F00FF">string</span> |  Whether the group should be present or not on the remote host.<br> **Choices:** <br>**<span style="color: #0000FF">- "present" ← (default)</span>**<br><span style="color: #FF0000"> - "absent" </span>|
| **system** <br><span style="color: #7F00FF">boolean</span> |  If `true`, indicates that the group created is a system group.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|


**Example :**

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
      manage: true
    - name: group_six
      manage: false
  ...
```

#### Manage `users`

##### Enable the users management : `os_common.users_manage`

`os_common.users_manage`
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.users_manage` variable to choose if you want to manage all users.
**Choices:**
**<span style="color: #FF0000">- true ← (default) </span>**
<span style="color: #0000FF">- false </span>

##### The users management :  `os_common.users`

`os_common.users`
*<span style="color: #7F00FF">list of `user` dictionaries</span>*

Use `os_common.users` dictionary to manage users.
It provide a list of `user` dictionary with it **`name`** and these defined parameters.

:warning: Not all available variables are specified below. Refer to the `ansible.builtin.user`  [:link:][Ansible-Module-ansible.builtin.user] module documentation page to see all available variables and their uses.

**Mains dictionary `user` parameters :**

| Parameters      |    Comments    |
|:----------------|:---------------|
| **manage** (`user`) <br><span style="color: #7F00FF">boolean</span> |  **<span style="color: #008800">Role Specific Variable</span>** <br>Used to manage or ignore this `user`.<br>**Choices:**<br>**<span style="color: #FF0000">- true ← (default) </span>** <br><span style="color: #0000FF">- false </span>|
| **name** <br><span style="color: #7F00FF">string</span> / **<span style="color: #FF0000">required</span>**|  Name of the user to manage (create, remove or modify). |
| ... | ...|
| **state** <br><span style="color: #7F00FF">string</span> |  Whether the account should exist or not, taking action if the state is different from what is stated. <br> **Choices:** <br>**<span style="color: #0000FF">- "present" ← (default)</span>** <br> <span style="color: #FF0000"> - "absent" </span>|
| ... | ...|
| **authorized_keys** <br> <span style="color: #7F00FF"> list of dictionary (`ssh keys`) </span> | **<span style="color: #008800">Role Specific Variable</span>** <br> Show `authorized_keys` variables information for more usage details|
| **authorized_keys_manage** <br> <span style="color: #7F00FF"> list of dictionary (`ssh keys`) </span> | **<span style="color: #008800">Role Specific Variable</span>** <br> Used to manage or ignore Keys for this `user`|
| ... | ...|
| **system** <br><span style="color: #7F00FF">boolean</span> |  When creating an account `state=present`, setting this to `true` makes the user a system account. <br> This setting cannot be changed on existing users.<br> **Choices:** <br>**<span style="color: #0000FF">- false ← (default)</span>**<br><span style="color: #FF0000">- true </span>|


##### Enable the users ssh keys management : `os_common.users[n].authorized_keys_manage`

`os_common.users[n].authorized_keys_manage`
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.users[n].authorized_keys_manage` variable to choose if you want to manage all users ssh keys.
**Choices:**
**<span style="color: #FF0000">- true ← (default) </span>**
<span style="color: #0000FF">- false </span>

##### The users ssh keys management :  `os_common.users[n].authorized_keys`

`os_common.users[n].authorized_keys`
*<span style="color: #7F00FF">list of `authorized_keys` dictionaries</span>*

Use `os_common.users[n].authorized_keys` dictionary to manage users ssh keys.
It provide a list of `authorized_keys` dictionaries with the `key` and these defined parameters.

:warning: Not all available variables are specified below.  Refer to the `ansible.posix.authorized_key`  [:link:][Ansible-Module-ansible.posix.authorized_key] module documentation page to see all available variables and their uses.

**mains Dictionary `authorized_keys` parameters :**

| Parameters      |    Comments    |
|:----------------|:---------------|
| **key** <br><span style="color: #7F00FF">string</span> / **<span style="color: #FF0000">required</span>**|  The SSH public key(s), as a string or url (https://github.com/username.keys). |
| ... | ...|
| **state** <br><span style="color: #7F00FF">string</span> |  Whether the given key (with the given key_options) should or should not be in the file. <br> **Choices:** <br>**<span style="color: #0000FF">- "present" ← (default)</span>** <br> <span style="color: #FF0000"> - "absent" </span>|
| ... | ...|
| **manage_dir** <br><span style="color: #7F00FF">string</span> |  Whether this module should manage the directory of the authorized key file. <br> If set to `true`, the module will create the directory, as well as set the owner and permissions of an existing directory. <br> Be sure to set `manage_dir=false` if you are using an alternate directory for authorized_keys, as set with path, since you could lock yourself out of SSH access. <br> **Choices:** <br>**<span style="color: #0000FF">- "present" ← (default)</span>** <br> <span style="color: #FF0000"> - "absent" </span> |

Example :

```yaml
os_common:
  ...
  users:
    - name: 'tchalmel'
     comment: 'Thomas CHALMEL'
      authorized_keys_manage: true
      authorized_keys:
        - authorized_key: 'https://raw.githubusercontent.com/shmii/public_key/main/id_ecdsa.pub'
          manage_dir: true
          state: present
        - authorized_key: 'https://raw.githubusercontent.com/shmii/public_key/main/id_rsa.pub'
          manage_dir: true
          state: present
    - name: 'user_one'
    - name: 'user_two'
      state: present
      group: 'group_two'
    - name: 'user_three'
      append: true
      groups: 'group_one, group_two'
    - name: 'user_four'
      append: true
      groups:
        - group_one
        - group_two
    - name: 'user_five'
      state: absent
      remove: true
  ...
```

---

## Dependencies

None.

---

## Example Playbook

```yaml
    - hosts: server
      roles:
        - { role: shmii.os-common }
```

---

## Warning / known bugs

/!\ To validate this role with "molecule" from Ubuntu @ WSL/WSL2 it is necessary to create the folder  `/sys/fs/cgroup/systemd` on the host linux subsystem.

`sudo mkdir /sys/fs/cgroup/systemd`

This directory is necessary for some os (RHEL9, Rocky9, etc...) and not existing on local Ubuntu WSL sub Systeme.

---

## Sources and Bibliography

Redde Caesari quae sunt Caesaris, et quae sunt Dei Deo !

- Jeff GEERLING ( <https://www.linkedin.com/in/jeff-geerling>  --- <https://github.com/geerlingguy>)
- Stephane ROBERT ( <https://www.linkedin.com/in/stephanerobert1>  ---  <https://blog.stephane-robert.info>)
- Robert de BOCK ( <https://github.com/robertdebock>)

### Bibliography


| Sources                                         | Tutorials                                          |
| ----------------------------------------------- |:-------------------------------------------------- |
| Ansible - Module : `ansible.builtin.group`        | [:link:][Ansible-Module-ansible.builtin.group]   |
| Browser Extension                     | [:link:][HackMD-it]     |
| Book Mode                             | [:link:][Book-mode]     |
| Slide Mode                            | [:link:][Slide-mode]    | 
| Share & Publish                       | [:link:][Share-Publish] |

[Ansible-Module-ansible.builtin.group]: https://docs.ansible.com/ansible/9/collections/ansible/builtin/group_module.html
[Ansible-Module-ansible.builtin.user]: https://docs.ansible.com/ansible/9/collections/ansible/builtin/user_module.html
[Ansible-Module-ansible.posix.authorized_key]: https://docs.ansible.com/ansible/9/collections/ansible/posix/authorized_key_module.html

---

## License

GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

---

## Author Information

This role was created in 2022 by [Thomas CHALMEL] (<https://www.thomas.chalmel.org/>).
