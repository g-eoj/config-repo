#!/bin/sh
# Setup config files on a new system

if ! grep -Fx ".config-repo" $HOME/.gitignore > /dev/null 2>&1; then
    echo ".config-repo" >> $HOME/.gitignore
fi

git clone --bare https://github.com/g-eoj/config-repo.git $HOME/.config-repo

config()
{
    /usr/bin/git --git-dir=$HOME/.config-repo/ --work-tree=$HOME $@
}

config checkout
if [ $? = 0 ]; then
    echo "Checked out config."
else
    echo "Backing up pre-existing dot files."
    mkdir -p $HOME/.config-backup
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.config-backup/{}
    config checkout
fi
config config status.showUntrackedFiles no

if ! grep -Fx "*.swp" $HOME/.config-repo/info/exclude > /dev/null 2>&1; then
    echo "*.swp" >> $HOME/.config-repo/info/exclude
fi
