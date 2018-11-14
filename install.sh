#!/bin/bash
dialog --title "TARBS Post Installation" --infobox "Loading Menu" 5 70
cd ~/
git clone https://github.com/allbombson/TARBS-postinstall &>/dev/null
cd TARBS-postinstall
sudo bash wizard.sh
cd ~/

#When I had one it didnt allways del
rm -rf TARBS-postinstall
rm -rf TARBS-postinstall
rm -rf TARBS-postinstall
rm -rf TARBS-postinstall
rm -rf TARBS-postinstall
rm -rf TARBS-postinstall
rm -rf TARBS-postinstall



