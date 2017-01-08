#Manage Config Files

The technique consists in storing a Git bare repository in a "side" folder (like $HOME/.config-repo) using a specially crafted alias so that commands are run against that repository and not the usual .git local folder, which would interfere with any other Git repositories around.

##Initial setup

If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:

    git init --bare $HOME/.config-repo
    alias config='/usr/bin/git --git-dir=$HOME/.config-repo/ --work-tree=$HOME'
    config config --local status.showUntrackedFiles no
    echo "alias config='/usr/bin/git --git-dir=$HOME/.config-repo/ --work-tree=$HOME'" >> $HOME/.bashrc

After you've executed the setup any file within the $HOME folder can be versioned with normal commands, replacing git with your newly created config alias, like:

    config status
    config add .vimrc
    config commit -m "Add vimrc"
    config add .bashrc
    config commit -m "Add bashrc"
    config push

##Install config files onto a new system (or migrate to this setup)

If you already store your configuration/dotfiles in a Git repository, on a new system you can migrate to this setup with the following steps:

Prior to the installation make sure you have committed the alias to your .bashrc or .zsh:

    alias config='/usr/bin/git --git-dir=$HOME/.config-repo/ --work-tree=$HOME'

And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:

    echo ".config-repo" >> .gitignore

Now clone your dotfiles into a bare repository in a "dot" folder of your $HOME:

    git clone --bare <git-repo-url> $HOME/.config-repo

Define the alias in the current shell scope:

    alias config='/usr/bin/git --git-dir=$HOME/.config-repo/ --work-tree=$HOME'

Checkout the actual content from the bare repository to your $HOME:

    config checkout

The step above might fail with a message like:

    error: The following untracked working tree files would be overwritten by checkout:
        .bashrc
        .gitignore
    Please move or remove them before you can switch branches.
    Aborting

This is because your $HOME folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:

    mkdir -p .config-backup && \
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv {} .config-backup/{}

Re-run the check out if you had problems:

    config checkout

Set the flag showUntrackedFiles to no on this specific (local) repository:

    config config --local status.showUntrackedFiles no

You're done, from now on you can now type config commands to add and update your dotfiles:

    config status
    config add .vimrc
    config commit -m "Add vimrc"
    config add .bashrc
    config commit -m "Add bashrc"
    config push

### Install script

    #git clone --bare https://bitbucket.org/durdn/cfg.git $HOME/.config-repo
    function config {
       /usr/bin/git --git-dir=$HOME/.config-repo/ --work-tree=$HOME $@
    }
    mkdir -p .config-backup
    config checkout
    if [ $? = 0 ]; then
      echo "Checked out config.";
      else
        echo "Backing up pre-existing dot files.";
        config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
    fi;
    config checkout
    config config status.showUntrackedFiles no

