#!/bin/bash
cd ~/
git clone https://github.com/allbombson/TARBS-postinstall
cd TARBS-postinstall
bash wizard.sh
cd ~/
rm -rf TARBS-postinstall
