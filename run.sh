#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

pwd=$(pwd)

echo -e 'if [ -e /etc/.bash_aliases ]; then\n  source /etc/.bash_aliases\nfi' >> /etc/bash.bashrc
echo -e 'if [ -e /etc/.bash_aliases ]; then\n  source /etc/.bash_aliases\nfi' >> ~/.bashrc

apt install -y git python3 python3-pip gobuster ncrack binwalk cewl aircrack-ng
snap install --classic code

cd /opt
git clone https://github.com/trustedsec/ptf.git
cd /opt/ptf
pip3 install -r requirements.txt
./ptf <<EOF
use modules/intelligence-gathering/amass
run
use modules/intelligence-gathering/awsbucket
run
use modules/intelligence-gathering/bfac
run
use modules/intelligence-gathering/asm
run
use modules/intelligence-gathering/discover
run
use modules/intelligence-gathering/dnsenum
run
use modules/intelligence-gathering/eyewitness
run
use modules/intelligence-gathering/gather_contacts
run
use modules/intelligence-gathering/goofile
run
use modules/intelligence-gathering/linux-exploit-suggester
run
use modules/intelligence-gathering/linuxprivchecker
run
use modules/intelligence-gathering/onedrive_user_enum
run
use modules/intelligence-gathering/osrframework
run
use modules/intelligence-gathering/postman
run
use modules/intelligence-gathering/smbmap
run
use modules/intelligence-gathering/ssh-audit
run
use modules/intelligence-gathering/sublist3r
run
use modules/intelligence-gathering/theHarvester
run
use modules/intelligence-gathering/windows-exploit-suggester
run
use modules/vulnerability-analysis/cloudflair
run
use modules/vulnerability-analysis/hydra
run
use modules/vulnerability-analysis/nikto
run
use modules/vulnerability-analysis/nmap
run
use modules/vulnerability-analysis/office365userenum
run
use modules/exploitation/badkeys
run
use modules/exploitation/burp
run
use modules/exploitation/exploit-db
run
use modules/exploitation/impacket
run
use modules/exploitation/kerbrute
run
use modules/exploitation/kerberoast
run
use modules/exploitation/metasploit
run
use modules/exploitation/mitmproxy
run
use modules/exploitation/owasp-zsc
run
use modules/exploitation/pwntools
run
use modules/exploitation/responder
run
use modules/exploitation/setoolkit
run
use modules/exploitation/shellgen
run
use modules/post-exploitation/evilwinrm
run
use modules/post-exploitation/powersploit
run
use modules/post-exploitation/pykek
run
use modules/post-exploitation/pypykatz
run
use modules/password-recovery/johntheripper
run
use modules/password-recovery/hashcat
run
use modules/password-recovery/seclist
run
use modules/password-recovery/statistically-likely-usernames
run
use modules/av-bypass/shellter
run
use modules/powershell/obfuscation
run
EOF
cd $pwd
cp ./theHarvester.py /pentest/intelligence-gathering/theharvester/theHarvester/lib/core.py
cp ./AWSBucketDump.py /pentest/intelligence-gathering/awsbucketdump/AWSBucketDump.py
cp ./sublist3r.py /pentest/intelligence-gathering/sublist3r/sublist3r.py

gem install wpscan
bundle update --bundler

cd /pentest
find . -name "requirements.txt"|while read fname; do
  pip3 install -r $fname --ignore-installed
done
cp -r /pentest/intelligence-gathering/osrframework/config/* ~/.config/OSRFramework
cp -r /pentest/intelligence-gathering/osrframework/config/* ~/.config/OSRFramework/default
echo "alias asm='python3 /pentest/intelligence-gathering/ASM/asm.py'" >> /etc/.bash_aliases
echo "alias goofile='python3 /pentest/intelligence-gathering/goofile/goofile.py'" >> /etc/.bash_aliases
echo "alias onedrive_enum='python3 /pentest/intelligence-gathering/nedrive_user_enum/onedrive_enum.py'" >> /etc/.bash_aliases
echo "alias kerberoast='python3 /pentest/exploitation/kerberoast/kerberoast.py'" >> /etc/.bash_aliases
echo "alias responder='python3 /pentest/exploitation/responder/Responder.py'" >> /etc/.bash_aliases
echo "alias shellgen='/pentest/exploitation/shellgen/shellgen'" >> /etc/.bash_aliases
echo "alias shellter='wine /pentest/av-bypass/shellter/shellter.exe'" >> /etc/.bash_aliases
echo "alias sudo='sudo '" >> /etc/.bash_aliases

