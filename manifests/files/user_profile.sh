###########################################################
# PUPPET MANAGED                                          #
# Do not edit this file on a server node unless you       #
# are willing to have your changes overwritten by         #
# Puppet.  If you really want to change the contents      #
# of this file, change it in the puppet subversion        #
# repository and check it out on the ops server.          #
###########################################################

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$HOME/.cabal/bin:$PATH"
fi

if [ -d "$HOME/.cabal/bin" ] ; then
    PATH="$HOME/.cabal/bin:$PATH"
fi