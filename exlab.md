**Llistar particions:**
 ```sudo fdisk -l```
 
 
```
Disk /dev/sdb: 465.76 GiB, 500107862016 bytes, 976773168 sectors
Disk model: External USB 3.0
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: AE5AE377-9D82-44AB-BA3B-644F1AF4C869

Device         Start       End   Sectors  Size Type
/dev/sdb1       2048   1050623   1048576  512M EFI System
/dev/sdb2    1050624 210765823 209715200  100G Linux root (x86-64)
/dev/sdb3  210765824 221251583  10485760    5G Linux filesystem
/dev/sdb4  221251584 745539583 524288000  250G Linux home
/dev/sdb5  745539584 779094015  33554432   16G Linux swap
/dev/sdb6  779094016 821037055  41943040   20G Linux filesystem
```


**Saber el mountpoint:**
Hem de muntar el root filesystem i obrir /etc/fstab
```
# UNCONFIGURED FSTAB FOR BASE SYSTEM
/dev/sdb5 none swap defaults 0 0
/dev/sdb2 / ext4 defaults 0 1
/dev/sdb1 /boot/efi vfat defaults 0 2
/dev/sdb3 /usr/local ext4 defaults 0 2
/dev/sdb4 /home ext4 defaults 0 2
```
root (/) ha de tenir l'ultima opció sempre a 1 per que sigui comprovada primer, swap a 0 ja que no cal i qualsevol altra a 2.


**Crear una nova partició:**
``` 
sudo gdisk [device]
n (add a new partition)
default (7) (partiton number) -> Enter
default first sector -> Enter
default last sector -> Enter
Hex code 8300 -> Enter
w (write partiton table)
```


**Crear sistema de fitxers: (normalment filesystem type = ext4)**
` mkfs -t [filesystem type] [device]`
- Per swap:
` mkswap [device]`


Muntar nova partició (a `/temp_part`)
- Primer muntem root a /linux i després creem la carpeta del mountpoint i editem el fstab
- Farem servir /linux com a root del disc
```
mkdir /linux
mount [root device partition] [/linux]

cd /linux

mkdir [/linux/temp_part]
mount [new device partition] [/linux/temp_part]
```

- Editem fstab amb la línia al final:
```
[new device partition], [new partiton mountpoint] ext4 defaults 0 2
```

**Per arreglar GRUB:**
- Muntem totes les particions
```
mkdir /linux/home
mount [home device partiton] [/linux/home]
mkdir [/linux/boot/efi] -p
mount [boot device partition] [/linux/boot/efi]
mkdir [/linux/usr/local]
mount [user local partition] [/linux/user/local]
```

- Fem bind mount i chroot
```
for i in /dev /dev/pts /proc /sys /run; do mount -B bind $i /[/linux]/$i; done
sudo chroot [/linux]
```

- Instal·lem GRUB
``` 
grub-install --target=x86_64-efi /dev/[external usb device] 
update-grub
```

**Canviar password**

```
passwd root
```

```
passwd aso
```


**Llistar interfaces**

`ip a`

**Configurar DHCP**
Afegir a /etc/network/interfaces
```
auto <eth interface> 
#allow-hotplug <eth interface> // en principi no cal
iface <eth interface> dhcp
```
I reiniciar l'interface amb
```
ifdown <eth interface> 
ifup <eth interface> 
```


**Volem jerarquitzar el home del sistema, de manera que les particions quedin de la següent forma:**
/dev/sdaX → /home/admins  
/dev/sdaY → /home/new_user  
Tingues en compte que /dev/sdaX és la partició que està actualment muntada a /home i /dev/sdaY és la partició que ara tens muntada a /temp_part com se’t demanava a l’apartat anterior.  Per poder fer-ho segueix les següents instruccions i respon les preguntes adequadament.  
**1. Indica les comandes necessàries per tal de canviar tots els punts de muntatge amb la  
configuració indicada a la capçalera d’aquesta pregunta (tots els mount i umount que has hagut de fer):**

```
umount /dev/sdaX
umount /dev/sdaY
mkdir /home/admins
mount /dev/sdaX /home/admins
mkdir /home/new_user
mount /dev/sdaY /home/admins
```

**2. Ara indica quin fitxer i amb quins canvis hauries de modificar per fer això persistent als reboot.  Com el home d’aso també ha canviat indica quin canvi és necessari per tal que el sistema tingui el home correctament indicat:**

editem /etc/fstab

```
# UNCONFIGURED FSTAB FOR BASE SYSTEM
/dev/sdb5 none swap defaults 0 0
/dev/sdb2 / ext4 defaults 0 1
/dev/sdb1 /boot/efi vfat defaults 0 2
/dev/sdb3 /usr/local ext4 defaults 0 2
/dev/sdb4 /home/admins ext4 defaults 0 2
/dev/sdb6 /home/new_user ext4 defaults 0 2
```

Per canviar el home:
```
usermod -m -d /home/admins/aso aso
```

**3. Ara, descarrega del repositori d’ASO els dos backups que trobaràs al directori /examen-211220 TOTS els backups del directori /backups directe a la / del sistema. Indica les comandes necessàries. Has d’indicar si et toca instal·lar software addicional o canviar alguna cosa al sistema per poder instal·lar el software i extreure els backup:**

Movem `file.tar` a /
```
tar -xvf file.tar
rsync -avz /root -e ssh root@localhost:/backup/backup-rsync/
```

**4. Crear nou usuari**
```
useradd [-d <Home_Dir> -c <UserInfo> -e <ExpireDate> -g <GID> -p <password> -s <Shell> -u <UID>] <uname>
```
Per crear grup: `groupadd` 

**5. Canvia els permisos del home d’aryn i tots els fitxers que conté per a que coincideixi amb els del  seu propietari i com a grup directors. Si us plau executa la comanda des de l'arrel del sistema:**

`chmod -R <perms> <dir>`

**7. Volem usar la comanda tar per comparar si el contingut del backup és diferent del contingut del  disc. Quina comanda podem utilitzar per fer-ho?:**

`tar --compare backup.tar`
