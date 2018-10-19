#!/bin/bash


function pause(){
   read -p "$*"
}




cd ~/TARBS-postinstall/
# Add explanation.
rm -rf test
#touch test
mkdir test
menufile="$HOME/TARBS-postinstall/choices.csv"
progsfile="$HOME/TARBS-postinstall/installable.csv"
specdir="$HOME/TARBS-postinstall/wrappers"

tmpdir=$(test)
#[[ ! $? -eq 0 ]] && echo error 1 && exit


# Construct menu file.  For some reasons, it's easier to constuct it on the fly
# than use eval and such.
sudo echo "#!/bin/bash" > test/menu.sh
sudo echo "dialog --title \"TARBS Post-Install Wizard\" --menu \"What would you like to do?\" 15 45 8 \\" >> test/menu.sh
sudo echo $(cut -d, -f1,2 "$menufile" | sed -e "s/,/ \"/g;s/$/\"/g")" \\" >> test/menu.sh
sudo echo "2>test/choice" >> test/menu.sh
sudo echo "grep '^\$chosen' installable.csv | cut -d ',' -f2" >> test/menu.sh
#grep '^D' installable.csv | cut -d ',' -f2

pause 'Any key'
#[[ ! $? -eq 0 ]] && echo error 2 && exit


# Get user input of what packages to install.

#[[ ! $? -eq 0 ]] && echo error 3-1 && exit
sudo bash test/menu.sh

#[[ ! $? -eq 0 ]] && echo error 3-2 && exit
chosen=$(cat test/choice)

#[[ ! $? -eq 0 ]] && echo error 3-3 && exit
[[ $chosen == "" ]] && echo exit 1 && exit

#[[ ! $? -eq 0 ]] && echo error 3 && exit


# In addition to installing the tagged programs, you can have scripts that run
# either before or after the installation.  To do this, you need only create a
# file in ~/.larbs-wizard/.specific/Z.pre (or Z.post).  `Z` here is the tag of
# the programs.

[[ -f  $specdir/$chosen.pre ]] && bash $specdir/$chosen.pre

# Quit script if preinstall script returned error or if user ended it.
#[[ ! $? -eq 0 ]] && echo exit 2/error 4 && exit


# Run the `packerwrapper` script on all the programs tagged with the chosen tag
# in the progs file.
packer -S $(grep "^$chosen" "$progsfile" | cut -d ',' -f2)
echo exit 3
# Post installation script.
[[ -f  $specdir/$chosen.post ]] && bash $specdir/$chosen.post
echo exit 4
