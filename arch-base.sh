#!/bin/bash
# script to automate the install of the base arch system
# script assumes efi partition mounted at /boot/efi

# timezone
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

# clock
hwclock --systoch

# locale
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# hostname
echo "archbtw" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 archbtw.localdomain archbtw" >> /etc/hosts

# root password
echo root:password | chpasswd

# install base system
pacman -S grub efibootmgr networkmanager network-manager-applet dialog  mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font

# laptop optional
# pacman -S wpa_supplicant bluez bluez-utilsc

# gpu options
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# grup config 
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# system services
systemctl enable NetworkManager
# systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
# systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

# add user 
useradd -m gavin
echo gavin:password | chpasswd
usermod -aG libvirt gavin
echo "gavin ALL=(ALL) ALL" >> /etc/sudoers.d/gavin

# end
printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"