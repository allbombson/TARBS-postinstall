#!/bin/bash

# Add explanation.

menufile="$HOME/TARBS-postinstall/choices.csv"
progsfile="$HOME/TARBS-postinstall/installable.csv"
specdir="$HOME/TARBS-postinstall/wrappers"

tmpdir=$(mktemp -d)
rm -rf $tmpdir/*.*
rm -rf $tmpdir/*

# Construct menu file.  For some reasons, it's easier to constuct it on the fly
# than use eval and such.
echo "dialog --title \"TARBS Post-Install Wizard\" --menu \"What would you like to do?\" 15 45 8 \\" > $tmpdir/menu.sh
echo $(cut -d, -f1,2 "$menufile" | sed -e "s/,/ \"/g;s/$/\"/g")" \\" >> $tmpdir/menu.sh
echo "2>$tmpdir/choice" >> $tmpdir/menu.sh

# Get user input of what packages to install.
bash $tmpdir/menu.sh
chosen=$(cat $tmpdir/choice)
[[ $chosen == "" ]] && tput clear && echo "Run \"pi\" or \"post-install\" to open this again!" && exit

# In addition to installing the tagged programs, you can have scripts that run
# either before or after the installation.  To do this, you need only create a
# file in ~/.larbs-wizard/.specific/Z.pre (or Z.post).  `Z` here is the tag of
# the programs.


dialog --title "TARBS Post Installation" --infobox "Getting program of your choice setup" 5 70
[[ -f  $specdir/$chosen.pre ]] && bash $specdir/$chosen.pre &>/dev/null




# Run the `packerwrapper` script on all the programs tagged with the chosen tag
# in the progs file.
dialog --title "TARBS Post Installation" --infobox "Installing program of your choice" 5 70
yay -S --noconfirm $(grep ^$chosen $progsfile | cut -d ',' -f2) &>/dev/null

# Post installation script.
dialog --title "TARBS Post Installation" --infobox "Installing program of your choice" 5 70
[[ -f  $specdir/$chosen.post ]] && bash $specdir/$chosen.post &>/dev/null

dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the program you chose has been installed successfully and has been setup for you!\\n\\nTo install a program again, select it from the list. You will see the same installing menus and then this, to quit and enjoy your system just choose cancel on the next page.\\n\\n-Thomas" 12 80
bash wizard.sh
