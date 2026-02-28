#!/bin/bash
# scripts/setup_lxd.sh

echo "Configurando entorno LXD..."

# 1. Crear usuario admin_lxd (requerimiento de la guía)
if ! id "admin_lxd" &>/dev/null; then
    sudo useradd -m -s /bin/bash admin_lxd
    echo "admin_lxd:password123" | sudo chpasswd
    # Dar permisos de sudo y agregar al grupo lxd
    sudo usermod -aG sudo,lxd admin_lxd
fi

# 2. Asegurar que LXD esté instalado
sudo snap install lxd --channel=latest/stable

# 3. Inicializar LXD de forma no interactiva con storage 'dir'
# (Esto ahorra tiempo para que no tengas que hacerlo a mano)
cat <<EOF | sudo lxd init --preseed
config: {}
networks:
- config:
    ipv4.address: auto
    ipv6.address: none
  description: ""
  name: lxdbr0
  type: ""
storage_pools:
- config: {}
  description: ""
  name: default
  driver: dir
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
cluster: null
EOF

echo "LXD configurado correctamente para el usuario admin_lxd."