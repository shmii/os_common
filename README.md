# Ansible Role: `os_common`

## The `os_common` Role

Ansible role to manage Linux OS base configuration (Security, prerequisite packages and tools, etc ...)
This role :

- Manage Extra Packages Repositories (epel, powertools, etc ... )
- Manage useful Packages and sysadmin tools (through the default `__os_common_tools_packages` dictionary)
- Manage base operating system (OS) configuration (groups, users, directories, LVM, etc ...)
  - Manage operating system groups (through the `os_common.groups` dictionary)
  - Manage operating system users (through the `os_common.users` dictionary)
  - Manage operating system directories (through the `os_common.directories` dictionary)
  - Manage whole operating system LVM (disks, pv, vg, lv, and partitions) (through the `os_common.vgs`, and `os_common.disks` dictionaries)

---

- [Ansible Role: `os_common`](#ansible-role-os_common)
  - [The `os_common` Role](#the-os_common-role)
  - [Requirements](#requirements)
    - [Requirements on runner](#requirements-on-runner)
    - [Requirements on targets](#requirements-on-targets)
    - [Requirements on Test and run environement](#requirements-on-test-and-run-environement)
  - [Role variables](#role-variables)
    - [1) The role dictionary : *`os_common`*](#1-the-role-dictionary--os_common)
      - [1.a) Managing Groups](#1a-managing-groups)
        - [1.a.1) Enable groups management : `os_common.groups_manage`](#1a1-enable-groups-management--os_commongroups_manage)
        - [1.a.2) Groups management : `os_common.groups`](#1a2-groups-management--os_commongroups)
        - [1.a.3) The 'group' Dictionary : `os_common.groups[n]`](#1a3-the-group-dictionary--os_commongroupsn)
      - [1.b) Manage `users` Variables](#1b-manage-users-variables)
        - [1.b.1) Enable users management : `os_common.users_manage`](#1b1-enable-users-management--os_commonusers_manage)
        - [1.b.2) Users management :  `os_common.users`](#1b2-users-management---os_commonusers)
        - [1.b.3) The 'User' Dictionary : `os_common.users[n]`](#1b3-the-user-dictionary--os_commonusersn)
        - [1.b.4) Enable user ssh keys management : `os_common.users[n].authorized_keys_manage`](#1b4-enable-user-ssh-keys-management--os_commonusersnauthorized_keys_manage)
        - [1.b.5) User ssh keys management :  `os_common.users[n].authorized_keys`](#1b5-user-ssh-keys-management---os_commonusersnauthorized_keys)
        - [1.b.6) The User 'authorized\_key' Dictionary :  `os_common.users[n].authorized_keys`](#1b6-the-user-authorized_key-dictionary---os_commonusersnauthorized_keys)
      - [1.c) Manage `directories` Variables](#1c-manage-directories-variables)
        - [1.c.1) Enable directories management : `os_common.directories_manage`](#1c1-enable-directories-management--os_commondirectories_manage)
        - [1.c.2) Directories management : `os_common.directories`](#1c2-directories-management--os_commondirectories)
        - [1.c.3) The 'directory' Dictionary : `os_common.directories[n]`](#1c3-the-directory-dictionary--os_commondirectoriesn)
      - [1.d) Logical Volume Management (`vgs`, and `disks`)](#1d-logical-volume-management-vgs-and-disks)
        - [1.d.1) Enable lvm management : `os_common.lvm_manage`](#1d1-enable-lvm-management--os_commonlvm_manage)
        - [1.d.2) Enable pvs management : `os_common.pvs_manage`](#1d2-enable-pvs-management--os_commonpvs_manage)
        - [1.d.3) Enable lvs management : `os_common.lvs_manage`](#1d3-enable-lvs-management--os_commonlvs_manage)
        - [1.d.4) Enable vgs management : `os_common.vgs_manage`](#1d4-enable-vgs-management--os_commonvgs_manage)
        - [1.d.5) Vgs management : `os_common.vgs`](#1d5-vgs-management--os_commonvgs)
        - [1.d.6) The 'vg' Dictionary : `os_common.vgs[n]`](#1d6-the-vg-dictionary--os_commonvgsn)
        - [1.d.7) The 'lv' Dictionary : `os_common.vgs[n].lv[n]`](#1d7-the-lv-dictionary--os_commonvgsnlvn)
  - [Dependencies](#dependencies)
  - [Example Playbook](#example-playbook)
  - [Warning / known bugs](#warning--known-bugs)
  - [Sources and Bibliography](#sources-and-bibliography)
    - [Sources](#sources)
    - [Bibliography \& Documentation](#bibliography--documentation)
      - [Ansible Modules](#ansible-modules)
  - [Ansible-Module-ansible.posix.mount:                    https://docs.ansible.com/ansible/latest/collections/ansible/posix/mount\_module.html](#ansible-module-ansibleposixmount--------------------httpsdocsansiblecomansiblelatestcollectionsansibleposixmount_modulehtml)
  - [License](#license)
  - [Author Information](#author-information)

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

## Role variables

__Role Variables__
Role Variables are listed below, along with default values (see `defaults/main.yml`).
Most of roles variables are regrouped on the `os_common` dictionary.

__Technical Role Variables (Internal)__
Role Technical variables are used for technical usage and shouldn't need to be overwiten in normal time.
Role Technical variables are prefixed by `__os_common_ ...` and can by find on the `vars` directory.
This variables are organized and loaded in this order for each hosts from this vars files :

1. - `vars/main.yml`
2. - `vars/<ansible_os_family>.yml`
3. - `vars/<ansible_distribution>.yml`
4. - `vars/<ansible_distribution>-<ansible_distribution_major_version>.yml`

### 1) The role dictionary : *`os_common`*

__`os_common`__
*<span style="color: #7F00FF">dictionary</span>*

Most of roles variables are regrouped on the `os_common` dictionary.
By default role provide an empty `os_common` dictionary.
*The `os_common` dictionary is not mendatory. (Only role defaults actions are applied)*

#### 1.a) Managing Groups

Groups management is made throw this vars:

- `os_common.groups_manage`  (*<span style="color: #7F00FF">boolean</span>*)
- `os_common.groups`  (*<span style="color: #7F00FF">list of dictionaries</span>*)

##### 1.a.1) Enable groups management : `os_common.groups_manage`

__`os_common.groups_manage`__
*<span style="color: #008800">Role Specific Variable</span>*
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.groups_manage` variable to chose if you want to manage groups.
__Choices:__
__<span style="color: #FF0000">- true ← (default) </span>__
<span style="color: #0000FF">- false </span>

##### 1.a.2) Groups management : `os_common.groups`

`os_common.groups`
*<span style="color: #7F00FF">list of dictionaries</span>*

Use `os_common.groups` list of dictionary to manage groups.
It provide a list of `group` dictionary with it __`name`__ and it defined parameters.
To managed group, this role is based on the `ansible.builtin.group`  [:link:][Ansible-Module-ansible.builtin.group] module.
All module variables are implemented and can be used on the `group` dictionary.
:warning: Not all available variables are specified below. Refer to the `ansible.builtin.group`  [:link:][Ansible-Module-ansible.builtin.group] module documentation page to see all available variables and their uses.

##### 1.a.3) The 'group' Dictionary : `os_common.groups[n]`

__The Dictionary `group` parameters :__

| Parameters      |    Comments    |
|:----------------|:---------------|
| __manage__ (`group`) <br><span style="color: #7F00FF">boolean</span> |  *<span style="color: #008800">Role Specific Variable</span>* <br>Used to manage or ignore this specifique `group`.<br>__Choices:__<br>__<span style="color: #FF0000">- true ← (default) </span>__ <br><span style="color: #0000FF">- false </span>|
| __name__ <br><span style="color: #7F00FF">boolean</span> / __<span style="color: #FF0000">required</span>__|  Name of the group to manage (create, remove or modify).|
| __force__ <br><span style="color: #7F00FF">boolean</span> |  Whether to delete a group even if it is the primary group of a user.<br>Only applicable on platforms which implement a –force flag on the group deletion command.<br> __Choices:__ <br>__<span style="color: #0000FF">- false ← (default)</span>__<br><span style="color: #FF0000">- true </span>|
| __gid__ <br><span style="color: #7F00FF">integer</span> |  Optional GID to set for the group.|
| __local__ <br><span style="color: #7F00FF">boolean</span> |  Forces the use of “local” command alternatives on platforms that implement it.<br> __Choices:__ <br>__<span style="color: #0000FF">- false ← (default)</span>__<br><span style="color: #FF0000">- true </span>|
| __non_unique__ <br><span style="color: #7F00FF">boolean</span> |  This option allows to change the group ID to a non-unique value. Requires `gid`.<br> __Choices:__ <br>__<span style="color: #0000FF">- false ← (default)</span>__<br><span style="color: #FF0000">- true </span>|
| __state__ <br><span style="color: #7F00FF">string</span> |  Whether the group should be present or not on the remote host.<br> __Choices:__ <br>__<span style="color: #0000FF">- "present" ← (default)</span>__<br><span style="color: #FF0000"> - "absent" </span>|
| __system__ <br><span style="color: #7F00FF">boolean</span> |  If `true`, indicates that the group created is a system group.<br> __Choices:__ <br>__<span style="color: #0000FF">- false ← (default)</span>__<br><span style="color: #FF0000">- true </span>|
| __sudoer__ (`group`) <br><span style="color: #7F00FF">boolean</span> |  *<span style="color: #008800">Role Specific Variable</span>* <br>Used to add `sudo` with `NOPASSW` right to this `group`.<br>it's creating a `/etc/sudoers.d/g_{{ group.name }}"` file.<br> With `ALL=(ALL) NOPASSWD:ALL` rights <br>__Choices:__<br>__<span style="color: #0000FF">- false ← (default)</span>__<br><span style="color: #FF0000">- true</span> |

__Example :__

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

#### 1.b) Manage `users` Variables

##### 1.b.1) Enable users management : `os_common.users_manage`

`os_common.users_manage`
*<span style="color: #008800">Role Specific Variable</span>*
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.users_manage` variable to choose if you want to manage all users.
__Choices:__
__<span style="color: #FF0000">- true ← (default) </span>__
<span style="color: #0000FF">- false </span>

##### 1.b.2) Users management :  `os_common.users`

`os_common.users`
*<span style="color: #7F00FF">list of `user` dictionaries</span>*

Use `os_common.users` list of dictionary to manage users.
It provide a list of `user` dictionary with it __`name`__ and it defined parameters.
To managed users, this role is based on the `ansible.builtin.user`[:link:][Ansible-Module-ansible.builtin.user] module.
All module variables are implemented and can be used on the `user` dictionary.
:warning: Not all available variables are specified below.
Refer to the  `ansible.builtin.user`[:link:][Ansible-Module-ansible.builtin.user] module documentation page to see all available variables and their uses.

##### 1.b.3) The 'User' Dictionary : `os_common.users[n]`

__Mains dictionary `user` parameters :__

| Parameters      |    Comments    |
|:----------------|:---------------|
| __manage__ (`user`) <br><span style="color: #7F00FF">boolean</span> |  __<span style="color: #008800">Role Specific Variable</span>__ <br>Used to manage or ignore this `user`.<br>__Choices:__<br>__<span style="color: #FF0000">- true ← (default) </span>__ <br><span style="color: #0000FF">- false </span>|
| __name__ <br><span style="color: #7F00FF">string</span> / __<span style="color: #FF0000">required</span>__|  Name of the user to manage (create, remove or modify). |
| ... | ...|
| __state__ <br><span style="color: #7F00FF">string</span> |  Whether the account should exist or not, taking action if the state is different from what is stated. <br> __Choices:__ <br>__<span style="color: #0000FF">- "present" ← (default)</span>__ <br> <span style="color: #FF0000"> - "absent" </span>|
| ... | ...|
| __authorized_keys__ <br> <span style="color: #7F00FF"> list of dictionary (`ssh keys`) </span> | __<span style="color: #008800">Role Specific Variable</span>__ <br> Show `authorized_keys` variables information for more usage details|
| __authorized_keys_manage__ <br> <span style="color: #7F00FF"> list of dictionary (`ssh keys`) </span> | __<span style="color: #008800">Role Specific Variable</span>__ <br> Used to manage or ignore Keys for this `user`|
| ... | ...|
| __system__ <br><span style="color: #7F00FF">boolean</span> |  When creating an account `state=present`, setting this to `true` makes the user a system account. <br> This setting cannot be changed on existing users.<br> __Choices:__ <br>__<span style="color: #0000FF">- false ← (default)</span>__<br><span style="color: #FF0000">- true </span>|

##### 1.b.4) Enable user ssh keys management : `os_common.users[n].authorized_keys_manage`

`os_common.users[n].authorized_keys_manage`
*<span style="color: #008800">Role Specific Variable</span>*
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.users[n].authorized_keys_manage` variable to choose if you want to manage all users ssh keys.
__Choices:__
__<span style="color: #FF0000">- true ← (default) </span>__
<span style="color: #0000FF">- false </span>

##### 1.b.5) User ssh keys management :  `os_common.users[n].authorized_keys`

`os_common.users[n].authorized_keys`
*<span style="color: #7F00FF">list of `authorized_keys` dictionaries</span>*

Use `os_common.users[n].authorized_keys` list of dictionary to manage users ssh keys.
It provide a list of `authorized_keys` dictionary with the __`key`__ and it defined parameters.
To managed ssh keys, this role is based on the `ansible.posix.authorized_key`[:link:][Ansible-Module-ansible.posix.authorized_key] module.
All module variables are implemented and can be used on the `authorized_keys` dictionary.
:warning: Not all available variables are specified below.
Refer to the `ansible.posix.authorized_key`[:link:][Ansible-Module-ansible.posix.authorized_key] module documentation page to see all available variables and their uses.

##### 1.b.6) The User 'authorized_key' Dictionary :  `os_common.users[n].authorized_keys`

__mains Dictionary `authorized_keys` parameters :__

| Parameters      |    Comments    |
|:----------------|:---------------|
| __key__ <br><span style="color: #7F00FF">string</span> / __<span style="color: #FF0000">required</span>__|  The SSH public key(s), as a string or url (https://github.com/username.keys). |
| ... | ...|
| __state__ <br><span style="color: #7F00FF">string</span> |  Whether the given key (with the given key_options) should or should not be in the file. <br> __Choices:__ <br>__<span style="color: #0000FF">- "present" ← (default)</span>__ <br> <span style="color: #FF0000"> - "absent" </span>|
| ... | ...|
| __manage_dir__ <br><span style="color: #7F00FF">string</span> |  Whether this module should manage the directory of the authorized key file. <br> If set to `true`, the module will create the directory, as well as set the owner and permissions of an existing directory. <br> Be sure to set `manage_dir=false` if you are using an alternate directory for authorized_keys, as set with path, since you could lock yourself out of SSH access. <br> __Choices:__ <br>__<span style="color: #0000FF">- "present" ← (default)</span>__ <br> <span style="color: #FF0000"> - "absent" </span> |

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

#### 1.c) Manage `directories` Variables

##### 1.c.1) Enable directories management : `os_common.directories_manage`

__`os_common.directories_manage`__
*<span style="color: #008800">Role Specific Variable</span>*
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.directories_manage` variable to chose if you want to manage directories.
__Choices:__
__<span style="color: #FF0000">- true ← (default) </span>__
<span style="color: #0000FF">- false </span>

##### 1.c.2) Directories management : `os_common.directories`

`os_common.directories`
*<span style="color: #7F00FF">list of dictionaries</span>*

Use `os_common.directories` list of dictionary to manage groups.
It provide a list of `directory` dictionary with it __`path`__ and it defined parameters.
To managed directories, this role is based on the `ansible.builtin.file`[:link:][Ansible-Module-ansible.builtin.file] module. (The `state` module variable of the module is forced to `directory` and couldn't be changed)
All module variables are implemented and can be used on the `group` dictionary.
:warning: Not all available variables are specified below.
Refer to the `ansible.builtin.file`[:link:][Ansible-Module-ansible.builtin.file] module documentation page to see all available variables and their uses.

##### 1.c.3) The 'directory' Dictionary : `os_common.directories[n]`

__The Dictionary `directory` parameters :__

| Parameters      |    Comments    |
|:----------------|:---------------|
| __manage__ (`group`) <br><span style="color: #7F00FF">boolean</span> |  *<span style="color: #008800">Role Specific Variable</span>* <br>Used to manage or ignore this specifique `group`.<br>__Choices:__<br>__<span style="color: #FF0000">- true ← (default) </span>__ <br><span style="color: #0000FF">- false </span>|
| __path__ <br><span style="color: #7F00FF">boolean</span> / __<span style="color: #FF0000">required</span>__|  Path to the directory being managed.|
| __group__ <br><span style="color: #7F00FF">string</span> |  Name of the group that should own the directory, as would be fed to `chown`. <br> When left unspecified, it uses the current group of the current user unless you are root, in which case it can preserve the previous ownership.|
| __owner__ <br><span style="color: #7F00FF">string</span> |  Name of the user that should own the directory, as would be fed to `chown`. <br> When left unspecified, it uses the current user unless you are `root`, in which case it can preserve the previous ownership.<br> Specifying a numeric username will be assumed to be a user ID and not a username. Avoid numeric usernames to avoid this confusion.|
||
| __mode__ <br><span style="color: #7F00FF">any</span> |  The permissions the resulting filesystem object should have.<br> *Refer to the ansible.builtin.file🔗 module page for more documentation !*|
||
| __selevel__ <br><span style="color: #7F00FF">string</span> | The level part of the SELinux filesystem object context.<br> *Refer to the ansible.builtin.file🔗 module page for more documentation !*|
| __serole__ <br><span style="color: #7F00FF">string</span> | The role part of the SELinux filesystem object context.<br> *Refer to the ansible.builtin.file🔗 module page for more documentation !*|
| __setype__ <br><span style="color: #7F00FF">string</span> | The type part of the SELinux filesystem object context.<br> *Refer to the ansible.builtin.file🔗 module page for more documentation !*|
| __seuser__ <br><span style="color: #7F00FF">string</span> | The user part of the SELinux filesystem object context.<br> *Refer to the ansible.builtin.file🔗 module page for more documentation !*|

__Example :__

```yaml
os_common:
  ...
  directories_manage: true
  directories:
    - path: '/mnt'
    - path: '/mnt/mount_point_one'
      owner: 'user_one'
    - path: '/mnt/mount_point_two'
      owner: 'user_two'
      group: 'group_two'
    - path: '/mnt/mount_point_three'
      owner: 'user_three'
      group: 'group_three'
      mode: '755'
    - path: '/mnt/mount_point_four'
      owner: 'user_three'
      group: 'group_three'
      mode: '755'
      manage: false
  ...
```

#### 1.d) Logical Volume Management (`vgs`, and `disks`)

Logical Volume Management is made throw this vars:

- `os_common.lvm_manage` (*<span style="color: #7F00FF">boolean</span>*): To manage Logical Volume Management (LVM) *(default __true__)*
- `os_common.pvs_manage` (*<span style="color: #7F00FF">boolean</span>*): To manage Physical volumes (PVs) *(default __true__)*
- `os_common.lvs_manage` (*<span style="color: #7F00FF">boolean</span>*): To manage Logical volumes (LVs) *(default __true__)*
- `os_common.vgs_manage` (*<span style="color: #7F00FF">boolean</span>*): To manage Volume group (VGs) *(default __true__)*

- `os_common.vgs`  (*<span style="color: #7F00FF">list of dictionaries</span>*): To Manage Volumes Groups (VGs)
- `vgs[n].lvs`  (*<span style="color: #7F00FF">list of dictionaries</span>*): To Manage Logical volumes (LVs) and Partitions
- `os_common.disks`  (*<span style="color: #7F00FF">list of dictionaries</span>*): To Manage Disks

__Example :__

```yaml
os_common:
  ...
  lvm_manage: true
  pvs_manage: true
  lvs_manage: true
  vgs_manage: true
  vgs:
    - name: "vg_one"
      tag: 'VGONE'
      manage: true
      lvs_manage: true
      lvs:
        - name: "lv_one"
          size: '500m'
          manage: true
          fs:
            fstype: 'ext2'
            resizefs: true
            manage: true
          mount_point:
            path: /mnt/mount_point_one
            mode: '755'
            manage: true
    ...
  disks:
    - path: '/dev/vdb'
      tag: 'VGONE'
    - path: '/dev/vdc'
      tag: 'VGONE'
    - path: '/dev/vdd'
      tag: 'VGTWO'
    - path: '/dev/vde'
      tag: 'VGTWO'
  ...
```

##### 1.d.1) Enable lvm management : `os_common.lvm_manage`

__`os_common.lvm_manage`__
*<span style="color: #008800">Role Specific Variable</span>*
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.lvm_manage` variable to chose if you want to manage Logical Volume Management (LVM) configuration.
__Choices:__
__<span style="color: #FF0000">- true ← (default) </span>__
<span style="color: #0000FF">- false </span>

##### 1.d.2) Enable pvs management : `os_common.pvs_manage`

__`os_common.pvs_manage`__
*<span style="color: #008800">Role Specific Variable</span>*
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.pvs_manage` variable to chose if you want to manage Physical volumes (PVs) configuration.
__Choices:__
__<span style="color: #FF0000">- true ← (default) </span>__
<span style="color: #0000FF">- false </span>

##### 1.d.3) Enable lvs management : `os_common.lvs_manage`

__`os_common.lvs_manage`__
*<span style="color: #008800">Role Specific Variable</span>*
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.lvs_manage` variable to chose if you want to manage Logical volumes (LVs) configuration.
__Choices:__
__<span style="color: #FF0000">- true ← (default) </span>__
<span style="color: #0000FF">- false </span>

##### 1.d.4) Enable vgs management : `os_common.vgs_manage`

__`os_common.vgs_manage`__
*<span style="color: #008800">Role Specific Variable</span>*
*<span style="color: #7F00FF">boolean</span>*

Use the `os_common.vgs_manage` variable to chose if you want to manage Volume group (VGs) configuration.
__Choices:__
__<span style="color: #FF0000">- true ← (default) </span>__
<span style="color: #0000FF">- false </span>
      vgs_manage: true

##### 1.d.5) Vgs management : `os_common.vgs`

`os_common.vgs`
*<span style="color: #7F00FF">list of dictionaries</span>*

Use `os_common.vgs` list of dictionaries to manage Volume group (VGs).

To manage Volume group (VGs) `os_common.vgs`, this role is based on the `community.general.lvg`[:link:][Ansible-Module-community.general.lvg] module.
To manage Logical volumes (LVs) `os_common.vgs[n].lvs`, this role is based on the `community.general.lvol`[:link:][Ansible-Module-community.general.lvol] module.
To manage Files systemes `os_common.vgs[n].lvs[n].fs`, this role is based on on the `community.general.filesystem`[:link:][Ansible-Module-community.community.general.filesystem] module.
To manage Mount Point `os_common.vgs[n].lvs[n].mount_point`, this role is based on on the `ansible.posix.mount`[:link:][Ansible-Module-ansible.posix.mount] module.

All modules variables are implemented and can be used on there respectives dictionaries.

:warning: Not all available variables are specified below.
Refer to the appropriate module documentation page to see all available variables and their usages.

##### 1.d.6) The 'vg' Dictionary : `os_common.vgs[n]`

__The `vg` Dictionary parameters :__

| Parameters      |    Comments    |
|:----------------|:---------------|
| __name__ <br><span style="color: #7F00FF">string</span> / __<span style="color: #FF0000">required</span>__ |  The name of the volume group. `vg`. |
| __manage__ <br><span style="color: #7F00FF">boolean</span> |  *<span style="color: #008800">Role Specific Variable</span>* <br>Used to manage or ignore this specifique `vg`.<br>__Choices:__<br>__<span style="color: #FF0000">- true ← (default) </span>__ <br><span style="color: #0000FF">- false </span>|
| __tag__ <br><span style="color: #7F00FF">String</span> |   *<span style="color: #008800">Role Specific Variable</span>* <br> Tag to link Physical volumes with the appropriate disk. `os_common.disks` |
| __lvs_manage__ <br><span style="color: #7F00FF">boolean</span> </span>  |  *<span style="color: #008800">Role Specific Variable</span>* <br>Used to manage or ignore Logical volumes (LVs) `lvs` for this `vg`.<br>__Choices:__<br>__<span style="color: #FF0000">- true ← (default) </span>__ <br><span style="color: #0000FF">- false </span>|
| __lvs__ <br> <span style="color: #7F00FF"> list of dictionary (`lvs`) </span> |  *<span style="color: #008800">Role Specific Variable</span>* <br> list of Logical volumes (LVs) informations for this `vg` <br> Show `os_common.vgs[n].lvms` variables information for more usage details |

__Example :__

```yaml
os_common:
  ...
  vgs:
    - name: "vg_one"
      tag: 'VGONE'
      manage: true
      lvs_manage: true
      lvs:
        - name: "lv_one"
          size: '500m'
          manage: true
          fs:
            fstype: 'ext2'
            resizefs: true
            manage: true
          mount_point:
            path: /mnt/mount_point_one
            mode: '755'
            manage: true
        - name: "lv_two"
          size: '500m'
          fs:
            fstype: 'ext3'
            resizefs: true
          mount_point:
            path: /mnt/mount_point_two
            mode: '755'
    - name: "vg_two"
      tag: 'VGTWO'
      manage: true
      lvs_manage: true
      lvs:
        - name: "lv_four"
          size: '500m'
          fs:
            fstype: 'xfs'
          mount_point:
            path: /mnt/mount_point_four
            mode: '755'
            manage: true
  ...
```

##### 1.d.7) The 'lv' Dictionary : `os_common.vgs[n].lv[n]`

__The `lv` Dictionary parameters :__

To manage Logical volumes (LVs), this role is based on the `community.general.lvol`[:link:][Ansible-Module-community.general.lvol] module.
You can used all of this modules variables on this dictonary.
All modules variables are implemented and can be used on the dictionaries.

| Parameters      |    Comments    |
|:----------------|:---------------|
| __name__ <br><span style="color: #7F00FF">string</span> / __<span style="color: #FF0000">required</span>__ |  The name of the logical volume. `lv`. |
| __manage__ <br><span style="color: #7F00FF">boolean</span> |  *<span style="color: #008800">Role Specific Variable</span>* <br>Used to manage or ignore this specifique `lv`.<br>__Choices:__<br>__<span style="color: #FF0000">- true ← (default) </span>__ <br><span style="color: #0000FF">- false </span>|
| __fs__ <br> <span style="color: #7F00FF"> dictionary (`fs`) </span> |  *<span style="color: #008800">Role Specific Variable</span>* <br> File Systeme (FS) information for this `lv` <br> Show `os_common.vgs[n].lvms[].fs` variables information for more usage details |
| __mount_point__ <br> <span style="color: #7F00FF"> dictionary (`mount_point`) </span> |  *<span style="color: #008800">Role Specific Variable</span>* <br> Mountpoint information for this `file systeme` <br> Show `os_common.vgs[n].lvms[].mount_point` variables information for more usage details |
| __active__ <br><span style="color: #7F00FF">String</span> | Whether the volume is active and visible to the host.<br>__Choices:__<br>__<span style="color: #FF0000">- true ← (default) </span>__ <br><span style="color: #0000FF">- false </span>|
| __force__ <br><span style="color: #7F00FF">String</span> | Shrink or remove operations of volumes requires this switch. Ensures that that filesystems get never corrupted/destroyed by mistake.<br>__Choices:__<br>__<span style="color: #FF0000">- false ← (default) </span>__ <br><span style="color: #0000FF">- true </span>|
|  ...  | ... |
| __shrink__ <br><span style="color: #7F00FF">string</span>  | Shrink if current size is higher than size requested.<br>__Choices:__<br><span style="color: #FF0000">- false</span><br>__<span style="color: #0000FF">- true  ← (default)</span>__|
| __size__ <br><span style="color: #7F00FF">string</span>  | Used to manage or ignore Logical volumes (LVs) `lvs` for this `vg`.<br>__Choices:__<br>__<span style="color: #FF0000">- true ← (default) </span>__ <br><span style="color: #0000FF">- false </span>|
|  ...  | ... |
| __state__ <br><span style="color: #7F00FF">string</span>  | Control if the logical volume exists. If `present` and the volume does not already exist then the `size` option is required.<br>__Choices:__<br><span style="color: #0000FF">- "absent" </span><br>__<span style="color: #FF0000">- "present" ← (default) </span>__ |
|  ...  | ... |

__Example :__

```yaml
os_common:
  ...
  vgs:
    - name: "vg_one"
      ...
      lvs:
        - name: "lv_one"
          size: '500m'
          manage: true
          fs:
            fstype: 'ext2'
            resizefs: true
            manage: true
          mount_point:
            path: /mnt/mount_point_one
            mode: '755'
            manage: true
        - name: "lv_two"
          size: '500m'
          fs:
            fstype: 'ext3'
            resizefs: true
          mount_point:
            path: /mnt/mount_point_two
            mode: '755'
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

### Sources

Redde Caesari quae sunt Caesaris, et quae sunt Dei Deo !

- Jeff GEERLING ( <https://www.linkedin.com/in/jeff-geerling>  --- <https://github.com/geerlingguy>)
- Stephane ROBERT ( <https://www.linkedin.com/in/stephanerobert1>  ---  <https://blog.stephane-robert.info>)
- Robert de BOCK ( <https://github.com/robertdebock>)

### Bibliography & Documentation

#### Ansible Modules

| Sources                                           | Tutorials                                                        |
| ------------------------------------------------- |:---------------------------------------------------------------- |
| Ansible - Module : `ansible.builtin.group`        | [:link:][Ansible-Module-ansible.builtin.group]                   |
| Ansible - Module : `ansible.builtin.user`         | [:link:][Ansible-Module-ansible.builtin.user]                    |
| Ansible - Module : `ansible.posix.authorized_key` | [:link:][Ansible-Module-ansible.posix.authorized_key]            |
| Ansible - Module : `ansible.builtin.file`         | [:link:][Ansible-Module-ansible.builtin.file]                    |
| Ansible - Module : `community.general.lvg`        | [:link:][Ansible-Module-community.general.lvg]                   |
| Ansible - Module : `community.general.lvol`       | [:link:][Ansible-Module-community.general.lvol]                  |
| Ansible - Module : `community.general.filesystem` | [:link:][Ansible-Module-community.community.general.filesystem]  |
| Ansible - Module : `ansible.posix.mount`          | [:link:][Ansible-Module-ansible.posix.mount]                     |

[Ansible-Module-ansible.builtin.group]:                  https://docs.ansible.com/ansible/9/collections/ansible/builtin/group_module.html
[Ansible-Module-ansible.builtin.user]:                   https://docs.ansible.com/ansible/9/collections/ansible/builtin/user_module.html
[Ansible-Module-ansible.posix.authorized_key]:           https://docs.ansible.com/ansible/9/collections/ansible/posix/authorized_key_module.html
[Ansible-Module-ansible.builtin.file]:                   https://docs.ansible.com/ansible/9/collections/ansible/builtin/file_module.html
[Ansible-Module-community.general.lvg]:                  https://docs.ansible.com/ansible/latest/collections/community/general/lvg_module.html
[Ansible-Module-community.general.lvol]:                 https://docs.ansible.com/ansible/latest/collections/community/general/lvol_module.html
[Ansible-Module-community.community.general.filesystem]: https://docs.ansible.com/ansible/latest/collections/community/general/filesystem_module.html
[Ansible-Module-ansible.posix.mount]:                    https://docs.ansible.com/ansible/latest/collections/ansible/posix/mount_module.html
---

## License

MIT - Copyright 2024 - Thomas CHALMEL (Shmii)

---

## Author Information

This role was created in 2022 by __Thomas CHALMEL__ ([My GitHub](https://github.com/shmii) / [My e-mail](thomas@chalmel.org))
