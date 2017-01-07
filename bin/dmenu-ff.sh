#!/bin/sh
# A fuzzy file-finder and opener based on dmenu
# Requires: dmenu, exo-open

# Dmenu Colors
nb='#312e39'
nf='#c0a79a'
sb='#783e57'
sf='#c0a79a'

# Directory Whitelist
whitelist="Documents Downloads Music Pictures Templates Videos"


for dir in $whitelist
do
    path=${HOME}/"${dir}"
    paths="$paths $path"
done
#echo $(locate -e $paths)
#locate -e $paths | dmenu -i -l 16 -nb $nb -nf $nf -sb $sb -sf $sf | sed 's/ /\\ /g' | xargs exo-open
#find -L $paths | sort -n | dmenu -i -l 16 -nb $nb -nf $nf -sb $sb -sf $sf | sed 's/ /\\ /g' | xargs exo-open
find -L $paths -type f \( ! -iname ".*" \) -printf "%T@:%p\n" | sort -nr | cut -d: -f2- | \
    dmenu -i -l 16 -nb $nb -nf $nf -sb $sb -sf $sf | sed 's/ /\\ /g' | xargs exo-open

