#!/bin/bash

set -euo pipefail
[ "$EUID" -ne 0 ] && exec sudo "$0" "$@"

detect_ansible_facts() {
  [[ -r /etc/os-release ]] || { echo "/etc/os-release introuvable"; exit 1; }
  . /etc/os-release

  ansible_distribution="$(tr '[:lower:]' '[:upper:]' <<< "${ID:0:1}")${ID:1}"
  ansible_distribution_version="${VERSION_ID:-unknown}"
  ansible_distribution_major_version="${ansible_distribution_version%%.*}"

  if [[ "$ansible_distribution_version" == *.* ]]; then
    ansible_distribution_minor_version="${ansible_distribution_version#*.}"
  else
    ansible_distribution_minor_version="0"
  fi

  ansible_distribution_release="${VERSION_CODENAME:-}"

  # os_family
  if [[ -n "${ID_LIKE:-}" ]]; then
    if grep -qi debian <<< "$ID_LIKE"; then
      ansible_os_family="Debian"
    elif grep -qi rhel <<< "$ID_LIKE"; then
      ansible_os_family="RedHat"
    elif grep -qi suse <<< "$ID_LIKE"; then
      ansible_os_family="Suse"
    elif grep -qi alpine <<< "$ID_LIKE"; then
      ansible_os_family="Alpine"
    elif grep -qi freebsd <<< "$ID_LIKE"; then
      ansible_os_family="FreeBSD"
    elif grep -qi openbsd <<< "$ID_LIKE"; then
      ansible_os_family="OpenBSD"
    elif grep -qi netbsd <<< "$ID_LIKE"; then
      ansible_os_family="NetBSD"
    else
      ansible_os_family="$ansible_distribution"
    fi
  else
    case "${ID,,}" in
      debian|ubuntu|linuxmint) ansible_os_family="Debian" ;;
      rhel|centos|almalinux|rocky|fedora|oracle|amazon) ansible_os_family="RedHat" ;;
      suse|opensuse|sles) ansible_os_family="Suse" ;;
      alpine) ansible_os_family="Alpine" ;;
      freebsd) ansible_os_family="FreeBSD" ;;
      openbsd) ansible_os_family="OpenBSD" ;;
      netbsd) ansible_os_family="NetBSD" ;;
      *) ansible_os_family="$ansible_distribution" ;;
    esac
  fi

  # distribution_file_variety
  if [[ -f /etc/debian_version ]]; then
    ansible_distribution_file_variety="Debian"
  elif [[ -f /etc/redhat-release || -f /etc/centos-release || -f /etc/almalinux-release || -f /etc/fedora-release ]]; then
    ansible_distribution_file_variety="RedHat"
  elif [[ -f /etc/SuSE-release || -f /etc/SUSE-release ]]; then
    ansible_distribution_file_variety="Suse"
  elif [[ -f /etc/alpine-release ]]; then
    ansible_distribution_file_variety="Alpine"
  elif [[ -f /etc/freebsd-update.conf ]]; then
    ansible_distribution_file_variety="FreeBSD"
  elif [[ -f /etc/openbsd_version ]]; then
    ansible_distribution_file_variety="OpenBSD"
  elif [[ -f /etc/netbsd-release ]]; then
    ansible_distribution_file_variety="NetBSD"
  else
    ansible_distribution_file_variety="unknown"
  fi
}

write_facts_to_file() {
  local file="/home/facts"
  cat > "$file" <<EOF
  ✅ OS Facts :
  ansible_distribution                = $ansible_distribution
  ansible_distribution_version        = $ansible_distribution_version
  ansible_distribution_major_version  = $ansible_distribution_major_version
  ansible_distribution_minor_version  = $ansible_distribution_minor_version
  ansible_distribution_release        = ${ansible_distribution_release:-n/a}
  ansible_os_family                   = $ansible_os_family
  ansible_distribution_file_variety   = $ansible_distribution_file_variety
EOF
}

main() {
  detect_ansible_facts
  write_facts_to_file
  cat <<EOF
  ✅ OS Facts :
  ansible_distribution                = $ansible_distribution
  ansible_distribution_version        = $ansible_distribution_version
  ansible_distribution_major_version  = $ansible_distribution_major_version
  ansible_distribution_minor_version  = $ansible_distribution_minor_version
  ansible_distribution_release        = ${ansible_distribution_release:-n/a}
  ansible_os_family                   = $ansible_os_family
  ansible_distribution_file_variety   = $ansible_distribution_file_variety
EOF

}

main "$@"
