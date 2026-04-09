#!/bin/bash


grep -oP 'box:\s*\K[^\s]+' ./molecule.yml | sort -u | while read box; do
  echo ">>> Download $box"
  vagrant box add "$box" --provider=libvirt || echo "FAILED: $box"
done
