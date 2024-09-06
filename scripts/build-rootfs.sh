#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

if [ "$(id -u)" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

cd "$(dirname -- "$(readlink -f -- "$0")")" && cd ..
mkdir -p build && cd build

if [[ ${DESKTOP_ONLY} == "Y" ]]; then
    if [[ -f ubuntu-22.04.4-desktop-arm64.rootfs.tar.xz ]]; then
        exit 0
    fi
elif [[ ${SERVER_ONLY} == "Y" ]]; then
    if [[ -f ubuntu-22.04.4-server-arm64.rootfs.tar.xz ]]; then
        exit 0
    fi
else
    if [[ -f ubuntu-22.04.4-server-arm64.rootfs.tar.xz && -f ubuntu-22.04.4-desktop-arm64.rootfs.tar.xz ]]; then
        exit 0
    fi
fi

# These env vars can cause issues with chroot
unset TMP
unset TEMP
unset TMPDIR

# Prevent dpkg interactive dialogues
export DEBIAN_FRONTEND=noninteractive

# Debootstrap options
arch=arm64
release=jammy
mirror=https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/
chroot_dir=rootfs
overlay_dir=../overlay

# Clean chroot dir and make sure folder is not mounted
umount -lf ${chroot_dir}/dev/pts 2> /dev/null || true
umount -lf ${chroot_dir}/* 2> /dev/null || true
rm -rf ${chroot_dir}
mkdir -p ${chroot_dir}

# Install the base system into a directory 
debootstrap --arch ${arch} ${release} ${chroot_dir} ${mirror}

# Use a more complete sources.list file 
cat > ${chroot_dir}/etc/apt/sources.list << EOF
# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb ${mirror} ${release} main restricted
# deb-src ${mirror} ${release} main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb ${mirror} ${release}-updates main restricted
# deb-src ${mirror} ${release}-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb ${mirror} ${release} universe
# deb-src ${mirror} ${release} universe
deb ${mirror} ${release}-updates universe
# deb-src ${mirror} ${release}-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb ${mirror} ${release} multiverse
# deb-src ${mirror} ${release} multiverse
deb ${mirror} ${release}-updates multiverse
# deb-src ${mirror} ${release}-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb ${mirror} ${release}-backports main restricted universe multiverse
# deb-src ${mirror} ${release}-backports main restricted universe multiverse

deb ${mirror} ${release}-security main restricted
# deb-src ${mirror} ${release}-security main restricted
deb ${mirror} ${release}-security universe
# deb-src ${mirror} ${release}-security universe
deb ${mirror} ${release}-security multiverse
# deb-src ${mirror} ${release}-security multiverse
EOF

# Mount the temporary API filesystems
mkdir -p ${chroot_dir}/{proc,sys,run,dev,dev/pts}
mount -t proc /proc ${chroot_dir}/proc
mount -t sysfs /sys ${chroot_dir}/sys
mount -o bind /dev ${chroot_dir}/dev
mount -o bind /dev/pts ${chroot_dir}/dev/pts

# Package priority for ppa
cp ${overlay_dir}/etc/apt/preferences.d/rockchip-ppa ${chroot_dir}/etc/apt/preferences.d/rockchip-ppa
cp ${overlay_dir}/etc/apt/preferences.d/panfork-mesa-ppa ${chroot_dir}/etc/apt/preferences.d/panfork-mesa-ppa
cp ${overlay_dir}/etc/apt/preferences.d/rockchip-multimedia-ppa ${chroot_dir}/etc/apt/preferences.d/rockchip-multimedia-ppa

# Download and update packages
cat << EOF | chroot ${chroot_dir} /bin/bash
set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

# Update localisation files
locale-gen en_US.UTF-8
update-locale LANG="en_US.UTF-8"

HOST=lubancat

# Create User
useradd -G sudo -m -s /bin/bash cat
passwd cat <<IEOF
temppwd
temppwd
IEOF
gpasswd -a cat video
gpasswd -a cat audio
passwd root <<IEOF
root
root
IEOF

# allow root login
sed -i '/pam_securetty.so/s/^/# /g' /etc/pam.d/login

# hostname
echo lubancat > /etc/hostname

# set localtime
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Add mesa and rockchip multimedia ppa
if [[ ${MAINLINE} != "Y" ]]; then
    apt-get -y update && apt-get -y install software-properties-common
    add-apt-repository -y ppa:liujianfeng1994/panfork-mesa
    add-apt-repository -y ppa:liujianfeng1994/rockchip-multimedia
fi

# Download and update installed packages
apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade

# Download and install generic packages
apt-get -y install dmidecode mtd-tools i2c-tools u-boot-tools linux-firmware \
bash-completion man-db manpages nano gnupg initramfs-tools rockchip-mpp-demos \
ubuntu-drivers-common ubuntu-server dosfstools mtools parted ntfs-3g zip atop \
p7zip-full htop iotop pciutils lshw lsof landscape-common exfat-fuse hwinfo \
net-tools wireless-tools openssh-client openssh-server wpasupplicant ifupdown \
pigz wget curl lm-sensors bluez gdisk usb-modeswitch usb-modeswitch-data make \
gcc libc6-dev bison libssl-dev flex fake-hwclock rfkill wireless-regdb ffmpeg \
mmc-utils network-manager librockchip-mpp1 librockchip-mpp-dev librockchip-vpu0 \
devio libavcodec-dev python3-opencv python3-pip python3-numpy python3-venv \
python3-dev cloud-initramfs-growroot tree

# Add embedfire kernel gpg
#mkdir -p /etc/apt/keyrings
#curl -fsSL https://Embedfire.github.io/keyfile | gpg --dearmor -o /etc/apt/keyrings/embedfire.gpg
#chmod a+r /etc/apt/keyrings/embedfire.gpg
#echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/embedfire.gpg] https://cloud.embedfire.com/mirrors/ebf-debian carp-rk3588 main" | tee /etc/apt/sources.list.d/embedfire-carp-rk3588.list > /dev/null

# Remove cryptsetup and needrestart
apt-get -y remove cryptsetup needrestart

# Clean package cache
apt-get -y autoremove && apt-get -y clean && apt-get -y autoclean
EOF

# Swapfile
cat << EOF | chroot ${chroot_dir} /bin/bash
set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

dd if=/dev/zero of=/tmp/swapfile bs=1024 count=2097152
chmod 600 /tmp/swapfile
mkswap /tmp/swapfile
mv /tmp/swapfile /swapfile
EOF

# Install arm64 deb package
cp -r ../packages/arm64/*.deb ${chroot_dir}/tmp
chroot ${chroot_dir} /bin/bash -c "dpkg -i /tmp/*.deb"
rm -f ${chroot_dir}/tmp/*.deb

# Customize header content
cp ${overlay_dir}/etc/update-motd.d/{00-header,30-sysinfo} ${chroot_dir}/etc/update-motd.d

# DNS
cp ${overlay_dir}/etc/resolv.conf ${chroot_dir}/etc/resolv.conf

# Hosts file
cp ${overlay_dir}/etc/hosts ${chroot_dir}/etc/hosts

# Serial console resize script
cp ${overlay_dir}/etc/profile.d/resize.sh ${chroot_dir}/etc/profile.d/resize.sh

# Enable rc-local
cp ${overlay_dir}/etc/rc.local ${chroot_dir}/etc/rc.local

# Default adduser config
cp ${overlay_dir}/etc/adduser.conf ${chroot_dir}/etc/adduser.conf

mkdir -p ${chroot_dir}/etc/initramfs/post-update.d/
cp ${overlay_dir}/etc/initramfs/post-update.d/zz-update-firmware ${chroot_dir}/etc/initramfs/post-update.d/zz-update-firmware

# Realtek 8811CU/8821CU usb modeswitch support
cp ${chroot_dir}/lib/udev/rules.d/40-usb_modeswitch.rules ${chroot_dir}/etc/udev/rules.d/40-usb_modeswitch.rules
sed '/LABEL="modeswitch_rules_end"/d' -i ${chroot_dir}/etc/udev/rules.d/40-usb_modeswitch.rules
cat >> ${chroot_dir}/etc/udev/rules.d/40-usb_modeswitch.rules <<EOF
# Realtek 8811CU/8821CU Wifi AC USB
ATTR{idVendor}=="0bda", ATTR{idProduct}=="1a2b", RUN+="/usr/sbin/usb_modeswitch -K -v 0bda -p 1a2b"

LABEL="modeswitch_rules_end"
EOF

# Add usb modeswitch to initrd this fixes a boot hang with 8811CU/8821CU
cp ${overlay_dir}/usr/share/initramfs-tools/hooks/usb_modeswitch ${chroot_dir}/usr/share/initramfs-tools/hooks/usb_modeswitch

# Set cpu governor to performance
cp ${overlay_dir}/usr/lib/systemd/system/cpu-governor-performance.service ${chroot_dir}/usr/lib/systemd/system/cpu-governor-performance.service
chroot ${chroot_dir} /bin/bash -c "systemctl enable cpu-governor-performance"

# Set gpu governor to performance
cp ${overlay_dir}/usr/lib/systemd/system/gpu-governor-performance.service ${chroot_dir}/usr/lib/systemd/system/gpu-governor-performance.service
chroot ${chroot_dir} /bin/bash -c "systemctl enable gpu-governor-performance"

# Add realtek bluetooth firmware to initrd 
cp ${overlay_dir}/usr/share/initramfs-tools/hooks/rtl-bt ${chroot_dir}/usr/share/initramfs-tools/hooks/rtl-bt

# Service to synchronise system clock to hardware RTC
cp ${overlay_dir}/usr/lib/systemd/system/rtc-hym8563.service ${chroot_dir}/usr/lib/systemd/system/rtc-hym8563.service

# Modify service timeout
cp ${overlay_dir}/usr/lib/systemd/system/NetworkManager-wait-online.service ${chroot_dir}/usr/lib/systemd/system/NetworkManager-wait-online.service

# Set term for serial tty
mkdir -p ${chroot_dir}/lib/systemd/system/serial-getty@.service.d/
cp ${overlay_dir}/usr/lib/systemd/system/serial-getty@.service.d/10-term.conf ${chroot_dir}/usr/lib/systemd/system/serial-getty@.service.d/10-term.conf

# Fix 120 second timeout bug
mkdir -p ${chroot_dir}/etc/systemd/system/systemd-networkd-wait-online.service.d/
cp ${overlay_dir}/etc/systemd/system/systemd-networkd-wait-online.service.d/override.conf ${chroot_dir}/etc/systemd/system/systemd-networkd-wait-online.service.d/override.conf

# Fix network management not being taken over
cp ${overlay_dir}/etc/netplan/01-network-manager-all.yaml ${chroot_dir}/etc/netplan/01-network-manager-all.yaml

# Fix the problem of network interface order change
cp ${overlay_dir}/etc/udev/rules.d/80-net-setup-link.rules ${chroot_dir}/etc/udev/rules.d/80-net-setup-link.rules

# Use gzip compression for the initrd
cp ${overlay_dir}/etc/initramfs-tools/conf.d/compression.conf ${chroot_dir}/etc/initramfs-tools/conf.d/compression.conf

# Disable terminal ads
sed -i 's/ENABLED=1/ENABLED=0/g' ${chroot_dir}/etc/default/motd-news
chroot ${chroot_dir} /bin/bash -c "pro config set apt_news=false"

# Remove release upgrade motd
rm -f ${chroot_dir}/var/lib/ubuntu-release-upgrader/release-upgrade-available
cp ${overlay_dir}/etc/update-manager/release-upgrades ${chroot_dir}/etc/update-manager/release-upgrades

# Copy over the ubuntu rockchip install util
cp ${overlay_dir}/usr/bin/ubuntu-rockchip-install ${chroot_dir}/usr/bin/ubuntu-rockchip-install

# Let systemd create machine id on first boot
rm -f ${chroot_dir}/var/lib/dbus/machine-id
true > ${chroot_dir}/etc/machine-id

# Umount temporary API filesystems
umount -lf ${chroot_dir}/dev/pts 2> /dev/null || true
umount -lf ${chroot_dir}/* 2> /dev/null || true

# Tar the entire rootfs
[[ ${DESKTOP_ONLY} != "Y" ]] && cd ${chroot_dir} && XZ_OPT="-3 -T0" tar -cpJf ../ubuntu-22.04.4-server-arm64.rootfs.tar.xz . && cd ..
[[ ${SERVER_ONLY} == "Y" ]] && exit 0

# Mount the temporary API filesystems
mkdir -p ${chroot_dir}/{proc,sys,run,dev,dev/pts}
mount -t proc /proc ${chroot_dir}/proc
mount -t sysfs /sys ${chroot_dir}/sys
mount -o bind /dev ${chroot_dir}/dev
mount -o bind /dev/pts ${chroot_dir}/dev/pts

# Download and update packages
cat << EOF | chroot ${chroot_dir} /bin/bash
set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

# Desktop packages
apt-get -y install ubuntu-desktop dbus-x11 xterm pulseaudio pavucontrol qtwayland5 \
gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good mpv \
gstreamer1.0-tools gstreamer1.0-rockchip1 chromium-browser mali-g610-firmware malirun \
rockchip-multimedia-config librist4 librist-dev rist-tools dvb-tools ir-keytable \
libdvbv5-0 libdvbv5-dev libdvbv5-doc libv4l-0 libv4l2rds0 libv4lconvert0 libv4l-dev \
libv4l-rkmpp qv4l2 v4l-utils librockchip-mpp1 librockchip-mpp-dev librockchip-vpu0 \
rockchip-mpp-demos librga2 librga-dev libegl-mesa0 libegl1-mesa-dev libgbm-dev guvcview \
libgl1-mesa-dev libgles2-mesa-dev libglx-mesa0 mesa-common-dev mesa-vulkan-drivers \
mesa-utils libwidevinecdm libcanberra-pulse gnome-software language-pack-zh-han*

# Remove cloud-init and landscape-common
apt-get -y purge cloud-init landscape-common cryptsetup-initramfs

# Chromium uses fixed paths for libv4l2.so
ln -rsf /usr/lib/*/libv4l2.so /usr/lib/
[ -e /usr/lib/aarch64-linux-gnu/ ] && ln -Tsf lib /usr/lib64

# Clean package cache
apt-get -y autoremove && apt-get -y clean && apt-get -y autoclean

EOF

# Hack for GDM to restart on first HDMI hotplug
mkdir -p ${chroot_dir}/usr/lib/scripts
cp ${overlay_dir}/usr/lib/scripts/gdm-hack.sh ${chroot_dir}/usr/lib/scripts/gdm-hack.sh
cp ${overlay_dir}/etc/udev/rules.d/99-gdm-hack.rules ${chroot_dir}/etc/udev/rules.d/99-gdm-hack.rules

# Config file for mpv
cp ${overlay_dir}/etc/mpv/mpv.conf ${chroot_dir}/etc/mpv/mpv.conf

# Use mpv as the default video player
sed -i 's/org\.gnome\.Totem\.desktop/mpv\.desktop/g' ${chroot_dir}/usr/share/applications/gnome-mimeapps.list

# Adjust hosts file for desktop
sed -i 's/127.0.0.1 localhost/127.0.0.1\tlocalhost.localdomain\tlocalhost\n::1\t\tlocalhost6.localdomain6\tlocalhost6/g' ${chroot_dir}/etc/hosts
sed -i 's/::1 ip6-localhost ip6-loopback/::1     localhost ip6-localhost ip6-loopback/g' ${chroot_dir}/etc/hosts
sed -i "/ff00::0 ip6-mcastprefix\b/d" ${chroot_dir}/etc/hosts

# Config file for xorg
mkdir -p ${chroot_dir}/etc/X11/xorg.conf.d
cp ${overlay_dir}/etc/X11/xorg.conf.d/20-modesetting.conf ${chroot_dir}/etc/X11/xorg.conf.d/20-modesetting.conf

# Networking interfaces
cp ${overlay_dir}/etc/NetworkManager/NetworkManager.conf ${chroot_dir}/etc/NetworkManager/NetworkManager.conf
cp ${overlay_dir}/usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf ${chroot_dir}/usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf
cp ${overlay_dir}/usr/lib/NetworkManager/conf.d/10-override-wifi-random-mac-disable.conf ${chroot_dir}/usr/lib/NetworkManager/conf.d/10-override-wifi-random-mac-disable.conf
cp ${overlay_dir}/usr/lib/NetworkManager/conf.d/20-override-wifi-powersave-disable.conf ${chroot_dir}/usr/lib/NetworkManager/conf.d/20-override-wifi-powersave-disable.conf

# Ubuntu desktop uses a diffrent network manager, so remove this systemd override
rm -rf ${chroot_dir}/etc/systemd/system/systemd-networkd-wait-online.service.d/override.conf

# Enable wayland session
cp ${overlay_dir}/etc/gdm3/custom.conf ${chroot_dir}/etc/gdm3/custom.conf

# default image background
mkdir -p ${chroot_dir}/usr/share/backgrounds
cp ${overlay_dir}/warty-final-ubuntu.png ${chroot_dir}/usr/share/backgrounds/warty-final-ubuntu.png

# Change startup logo
mkdir -p  ${chroot_dir}/usr/share/plymouth/themes/spinner
cp ${overlay_dir}/bgrt-fallback.png ${chroot_dir}/usr/share/plymouth/themes/spinner/bgrt-fallback.png
cp ${overlay_dir}/ubuntu-logo.png ${chroot_dir}/usr/share/plymouth/ubuntu-logo.png
cp ${overlay_dir}/ubuntu-logo-icon.png ${chroot_dir}/usr/share/pixmaps/ubuntu-logo-icon.png

# Set chromium inital prefrences
mkdir -p ${chroot_dir}/usr/lib/chromium-browser
cp ${overlay_dir}/usr/lib/chromium-browser/initial_preferences ${chroot_dir}/usr/lib/chromium-browser/initial_preferences

# Set chromium default launch args
mkdir -p ${chroot_dir}/usr/lib/chromium-browser
cp ${overlay_dir}/etc/chromium-browser/default ${chroot_dir}/etc/chromium-browser/default

# Set chromium as default browser
chroot ${chroot_dir} /bin/bash -c "update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/chromium-browser 500"
chroot ${chroot_dir} /bin/bash -c "update-alternatives --set x-www-browser /usr/bin/chromium-browser"
sed -i 's/firefox-esr\.desktop/chromium-browser\.desktop/g;s/firefox\.desktop;//g' ${chroot_dir}/usr/share/applications/gnome-mimeapps.list 

# Add chromium to favorites bar
mkdir -p ${chroot_dir}/etc/dconf/db/local.d
cp ${overlay_dir}/etc/dconf/db/local.d/00-favorite-apps ${chroot_dir}/etc/dconf/db/local.d/00-favorite-apps
cp ${overlay_dir}/etc/dconf/profile/user ${chroot_dir}/etc/dconf/profile/user
chroot ${chroot_dir} /bin/bash -c "dconf update"

# Have plymouth use the framebuffer
mkdir -p ${chroot_dir}/etc/initramfs-tools/conf-hooks.d
cp ${overlay_dir}/etc/initramfs-tools/conf-hooks.d/plymouth ${chroot_dir}/etc/initramfs-tools/conf-hooks.d/plymouth

# fuck tracker3
cat << EOF | chroot ${chroot_dir} /bin/bash
rm /usr/lib/systemd/user/tracker-*
chmod -x /usr/libexec/tracker-* /usr/libexec/tracker3/* /usr/bin/tracker3
rm -rf ~/.cache/tracker3
EOF

# Mouse lag/stutter (missed frames) in Wayland sessions
# https://bugs.launchpad.net/ubuntu/+source/mutter/+bug/1982560
echo "MUTTER_DEBUG_ENABLE_ATOMIC_KMS=0" >> ${chroot_dir}/etc/environment
echo "MUTTER_DEBUG_FORCE_KMS_MODE=simple" >> ${chroot_dir}/etc/environment
echo "CLUTTER_PAINT=disable-dynamic-max-render-time" >> ${chroot_dir}/etc/environment

# Update initramfs
chroot ${chroot_dir} /bin/bash -c "update-initramfs -u"

# Umount the temporary API filesystems
umount -lf ${chroot_dir}/dev/pts 2> /dev/null || true
umount -lf ${chroot_dir}/* 2> /dev/null || true

# Tar the entire rootfs
cd ${chroot_dir} && XZ_OPT="-3 -T0" tar -cpJf ../ubuntu-22.04.4-desktop-arm64.rootfs.tar.xz . && cd ..
