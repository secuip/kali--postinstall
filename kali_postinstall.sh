#!/bin/bash

#########################################
# System Configuration
## Disable visual mode in Vim
echo "set mouse-=a " > ~/.vimrc
## Set keyboard layout
L='fr' && sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'$L'\"/g' /etc/default/keyboard
L='pc105' && sudo sed -i 's/XKBMODEL=\"\w*"/XKBMODEL=\"'$L'\"/g' /etc/default/keyboard
L='mac' && sudo sed -i 's/XKBVARIANT=\"\w*"/XKBVARIANT=\"'$L'\"/g' /etc/default/keyboard
L='lv3:switch,compose:lwin' && sudo sed -i 's/XKBOPTIONS=\"\w*"/XKBOPTIONS=\"'$L'\ "/g' /etc/default/keyboard
## Grub
sed -i -e "s,^GRUB_TIMEOUT=.*,GRUB_TIMEOUT=0," /etc/default/grub
echo "GRUB_HIDDEN_TIMEOUT=0" >> /etc/default/grub
echo "GRUB_HIDDEN_TIMEOUT_QUIET=true" >> /etc/default/grub
update-grub
## Enable auto (gui) login
file=/etc/gdm3/daemon.conf; [ -e "${file}" ] && cp -n $file{,.bkup}
sed -i 's/^.*AutomaticLoginEnable = .*/AutomaticLoginEnable = true/' "${file}"
sed -i 's/^.*AutomaticLogin = .*/AutomaticLogin = root/' "${file}"
## Disable screensaver
xset s 0 0
xset s off
gsettings set org.gnome.desktop.session idle-delay 0
## Set wallpaper
gsettings set org.gnome.desktop.background picture-uri "file:///root/Pictures/sans_wallpaper_v5.png"

wget -O /root/Pictures/sift.jpg https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/images/forensics_blue.jpg
wget -O /root/Pictures/sans_wallpaper_v5.png https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/images/forensics_blue.jpg


#########################################
# Regolith
## Installation
## source : https://medium.com/@remco_verhoef/installing-regolith-for-kali-e4152c446cdf
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 76458020C35556DC
echo "deb http://ppa.launchpad.net/kgilmer/regolith-stable/ubuntu disco main" >>
/etc/apt/sources.list
apt update
wget http://archive.ubuntu.com/ubuntu/pool/main/x/xcb-util/libxcb-util1_0.4.0-0ubu
ntu3_amd64.deb
dpkg -i libxcb-util1_0.4.0-0ubuntu3_amd64.deb
apt install -y regolith-desktop
## Configuration
## Copy default regolith configuration in HomeDirectory
mkdir -p ~/.config/regolith/i3
cp /etc/regolith/i3/config ~/.config/regolith/i3/config
## Add keybind to launch filemanager with super+e
apt install -y nemo
echo "
# Launch FileManager
bindsym \$mod+e exec /usr/bin/nemo" >>  ~/.config/regolith/i3/config


#########################################
# Packages installation
mkdir -p /opt/tools/linux
mkdir -p /opt/tools/windows
mkdir -p /opt/tools/web
#########################################
## Common tools
apt install -y htop iftop iotop screen tree sshuttle clamav
## Development tools
apt install -y golang
## Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' > /etc/apt/sources.list.d/docker.list
apt update
apt-get remove docker docker-engine docker.io
apt install -y docker-ce docker-compose
## TheHive Incident Response tool
#mkdir -p /opt/tools/theHive
#cd /opt/tools/theHive
#wget -O /opt/tools/theHive/docker-compose.yml https://raw.githubusercontent.com/TheHive-Project/TheHive/master/docker/thehive/docker-compose.yml
#docker-compose up
#########################################
## Forensic
apt install -y forensics-full

### Documentation
mkdir -p /opt/ebook/forensic/
wget -O /opt/ebook/forensic/Evidence-of-Poster.pdf https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/resources/Evidence-of-Poster.pdf
wget -O /opt/ebook/forensic/Find-Evil-Poster.pdf https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/resources/Find-Evil-Poster.pdf
wget -O /opt/ebook/forensic/SANS-DFIR.pdf https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/resources/SANS-DFIR.pdf
wget -O /opt/ebook/forensic/Smartphone-Forensics-Poster.pdf https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/resources/Smartphone-Forensics-Poster.pdf
wget -O /opt/ebook/forensic/memory-forensics-cheatsheet.pdf https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/resources/memory-forensics-cheatsheet.pdf
wget -O /opt/ebook/forensic/network-forensics-cheatsheet.pdf https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/resources/network-forensics-cheatsheet.pdf
wget -O /opt/ebook/forensic/sift-cheatsheet.pdf https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/resources/sift-cheatsheet.pdf
wget -O /opt/ebook/forensic/windows-to-unix-cheatsheet.pdf https://github.com/teamdfir/sift-saltstack/raw/master/sift/files/sift/resources/windows-to-unix-cheatsheet.pdf

### Forensic Volatility
mkdir -p /opt/tools/forensic/volatiliy
git clone --recursive -q -b master https://github.com/volatilityfoundation/profiles.git /opt/tools/forensic/volatiliy/profiles
mkdir -p /opt/tools/forensic/volatility/plugins
### SIFT SCRIPTS : https://github.com/teamdfir/sift-saltstack/tree/master/sift/scripts
#### Forensic 4n6
git clone https://github.com/cheeky4n6monkey/4n6-scripts /opt/tools/forensic/4n6-scripts
chmod +x /opt/tools/forensic/4n6-scripts/*.p*
ln -s /opt/tools/forensic/4n6-scripts/*.p* /usr/local/bin/
#### kevthehermit (imageMounter, quarantine)
git clone https://github.com/kevthehermit/Scripts.git /opt/tools/forensic/kevthehermit
chmod +x /opt/tools/forensic/kevthehermit/*.p*
ln -s /opt/tools/forensic/kevthehermit/*.p* /usr/local/bin/
### Binary Analyse
git clone https://github.com/hiddenillusion/AnalyzePE.git /opt/tools/binary/AnalyzePE
file=/usr/local/bin/peutils.py
cat <<EOF > "${file}" 
#!/bin/bash
cd /opt/tools/binary/AnalyzePE && python2 ./peutils.py "\$@"
EOF
chmod +x "${file}"
file=/usr/local/bin/pescanner.py
cat <<EOF > "${file}" 
#!/bin/bash
cd /opt/tools/binary/AnalyzePE/ && python2 ./pescanner.py "\$@"
EOF
chmod +x "${file}"
### Forensic MACOS
apt install -y libfvde-utils hfsplus
cd /opt/tools/forensic/volatility/plugins
wget https://raw.githubusercontent.com/tribalchicken/volatility-filevault2/master/plugins/mac/filevault2.py
#### Chainbreaker
git clone --recursive -q -b master https://github.com/n0fate/chainbreaker.git /opt/tools/macos/forensic/chainbreaker
pip2 install hexdump
file=/usr/local/bin/chainbreaker
cat <<EOF > "${file}" 
#!/bin/bash
cd /opt/tools/macos/forensic/chainbreaker && python2 ./chainbreaker.py "\$@"
EOF
chmod +x "${file}"
sed -i 's/^.*# hexdump(dbkey)/    hexdump(dbkey)/' "/opt/tools/macos/forensic/chainbreaker/chainbreaker.py"
sed -i 's/^.*# hexdump(passwd)/            hexdump(passwd)/' "/opt/tools/macos/forensic/chainbreaker/chainbreaker.py"
#### Mac_apt
git clone --recursive -q -b master https://github.com/ydkhatri/mac_apt.git /opt/tools/macos/forensic/mac_apt/
file=/usr/local/bin/mac_apt
cat <<EOF > "${file}" 
#!/bin/bash
cd /opt/tools/macos/forensic/mac_apt/ && python3 ./mac_apt.py "\$@"
EOF
chmod +x "${file}"
cd /tmp/
wget https://github.com/libyal/libewf-legacy/releases/download/20140807/libewf-20140807.tar.gz
tar xvzf libewf-20140807.tar.gz
cd libewf-20140807
python3 setup.py build
python3 setup.py install
cd /tmp
git clone --recursive https://github.com/ydkhatri/pylzfse
cd pylzfse
python3 setup.py build
python3 setup.py install
pip3 install biplist tzlocal construct==2.8.10 xlsxwriter plistutils kaitaistruct lz4 pytsk3==20170802 libvmdk-python==20181227
apt install -y libbz2-dev zlib1g-dev
#### Bling
pip3 install pytz hexdump vstruct vivisect-vstruct-wb tabulate argparse pycryptodome
wget -O /opt/tools/macos/forensic/bling.py https://gist.githubusercontent.com/williballenthin/d6bf9f1553d9fa27e0cc6880a6d992b4/raw/caf403d84ace7d6961d76f9868557c9eab330805/bling.py 
file=/usr/local/bin/bling
cat <<EOF > "${file}" 
#!/bin/bash
cd /opt/tools/macos/forensic/ && python3 ./bling.py "\$@"
EOF
chmod +x "${file}"
pip3 install pytz hexdump vivisect-vstruct-wb tabulate argparse pycryptodome
### sources : https://www.ba-consultants.fr/articles/inforensiques/293-montage-d-une-partition-hfs?showall=1&limitstart=
#########################################
## Pwn
apt-get install -y python2.7 python-pip python-dev git libssl-dev libffi-dev build-essential
pip install --upgrade pip
pip install --upgrade pwntools
#########################################
## Linux Pentesting
apt install -y snmpenum openvas
openvas-setup
git clone https://github.com/rebootuser/LinEnum.git /opt/tools/linux/linenum
wget -O /opt/tools/linux/pspy32 https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32
wget -O /opt/tools/linux/pspy64 https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64
#########################################
## Windows Pentesting
### Install CrackMapExec
git clone --recursive -q -b master https://github.com/byt3bl33d3r/CrackMapExec.git /opt/tools/windows/crackmapexec-git/
pushd /opt/tools/windows/crackmapexec-git/ >/dev/null
git pull -q
python -W ignore setup.py install >/dev/null
popd >/dev/null
### Install Impacket
git clone --recursive -q -b master https://github.com/CoreSecurity/impacket.git /opt/tools/windows/impacket-git
pushd /opt/tools/windows/impacket-git/ >/dev/null
git pull -q
pip3 install -r requirements.txt
python -W ignore setup.py install >/dev/null
popd >/dev/null
### Install Empire
git clone -q -b master https://github.com/PowerShellEmpire/Empire.git /opt/tools/windows/c2/empire-git/ 
pushd /opt/tools/windows/c2/empire-git/  >/dev/null
git pull -q
popd >/dev/null
cd /opt/tools/windows/c2/empire-git/
./setup/install.sh
file=/usr/local/bin/empire-git
cat <<EOF > "${file}" 
#!/bin/bash
cd /opt/tools/windows/c2/empire-git/ && ./empire "\$@"
EOF
chmod +x "${file}"
#########################################
## Web Pentesting
apt install -y gobuster
git clone https://github.com/s0md3v/Arjun /opt/tools/web/arjun
### Install CMSmap
pip3 install parse
git clone -q -b master https://github.com/Dionach/CMSmap.git /opt/tools/web/cmsmap-git/ 
pushd /opt/tools/web/cmsmap-git/ >/dev/null
git pull -q
popd >/dev/null
mkdir -p /usr/local/bin/
cd /opt/tools/web/cmsmap-git/
./setup/install.sh
file=/usr/local/bin/cmsmap-git
cat <<EOF > "${file}" 
#!/bin/bash
cd /opt/tools/web/cmsmap-git/ && python3 cmsmap.py "\$@"
EOF
chmod +x "${file}"
#########################################
## Wordlists
cd /usr/share/wordlists/
gunzip rockyou.txt.gz
wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O SecList.zip \
  && unzip SecList.zip \
  && rm -f SecList.zip



##########################################
# Sources 
#
## https://github.com/Rajpratik71/kali-script/blob/master/kali-rolling-git-repos.sh
## https://github.com/Rajpratik71/kali-script/blob/master/kali-rolling.sh
## https://github.com/macubergeek/gitlist/blob/master/gitlist.sh
## https://guif.re/networkpentest#General%20methodology

