# RECUPERAR SISTEMA

# -------------------- 

# ver particiones y tamaño
fdisk -l 
# también se puede usar este
lsblk 
lsblk -o NAME,TYPE,FSTYPE,SIZE,MOUNTPOINT

# mirar tabla /etc/fstab para ver donde se montan las particiones

# hacer particiones
fdisk /dev/device
# seguir pasos
    # n para nueva particion

# crear sistema de ficheros
mkfs -t ext4 /dev/device

# montar sistema de ficheros
mkdir mountpoint
mount /dev/device mountpoint

# modificar /etc/fstab
# swap
device none swap defaults 0 0
# root /
device /    ext4 defaults 0 1
# lo demás
device *    type defaults 0 2

# -------------------- 

# arreglar grub

# buscar que particion utilizar
# montar particiones y hacer chroot
chroot /linux

# mirar cual es la particion de arranque y reinstalar el grub
grub-install --target=x86_64-efi /dev/device
update-grub

# -------------------- 

# cambiar password

passwd 
passwd aso

# -------------------- 

# mensaje de bienvenida

/etc/issue
/etc/motd

# -------------------- 

# configurar red --mirar hialvaro--

# manual
ip link show
ip link set dev [if] down

ip address @ip [if]
ip route add default via [gateway] dev [if]

ifconfig [if] @ip netmask [netmask]
route add default gw @ip

# ir a /etc/resolv.conf y poner el servidor DNS

# dhcp
auto [if]
iface [if] inet dhcp

# -------------------- 

sftp server
get file
exit

# -------------------- 

# Instalacion de aplicaciones

# -------------------- 

# Gestió d'usuaris

useradd -d [home] -c [userinfo] -e [expire] -g [GID] -p [password] -s [shell] -u [UID] username

groupadd -g [UID] groupname

# tambien se puede cambiar en /etc/group
usermod -a -G groupname username

# cambiar permisos home
chown user:user /home/ayrn

# -------------------- 

# Backups
tar --compare -f backup.tar -C /path/to/disc

# -------------------- 

# CRON

# <minute> <hour> <day-of-month> <month> <day-of-week> <command>
/etc/crontab


