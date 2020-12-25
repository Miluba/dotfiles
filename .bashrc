#!/usr/bin/env bash

# Limit number of lines and entries in the history. HISTFILESIZE
# controls the
# history file on disk and HISTSIZE controls lines stored in memory.
export HISTFILESIZE=50000
export HISTSIZE=50000

# Add a timestamp to each command.
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "

# Duplicate lines and lines starting with a space are not put into the
# history.
export HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# Ensure $LINES and $COLUMNS always get updated.
shopt -s checkwinsize

# Enable bash completion.
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion 

# Load aliases if they exist.
[ -f "${HOME}/.aliases" ] && source "${HOME}/.aliases"
[ -f "${HOME}/.aliases.local" ] && source "${HOME}/.aliases.local"

# Determine git branch.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Set a non-distracting prompt.
PS1='\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\] \[\e[01;33m\]$(parse_git_branch)\[\e[00m\]\$ '

# If it's an xterm compatible terminal, set the title to user@host: dir.
case "${TERM}" in
xterm*|rxvt*)
  PS1="\[\e]0;\u@\h: \w\a\]${PS1}"
  ;;
*)
  ;;
esac

# Enable a better reverse search experience.
#   Requires: https://github.com/junegunn/fzf (to use fzf in general)
#   Requires: https://github.com/BurntSushi/ripgrep (for using rg below)
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS="--color=dark"
[ -f "${HOME}/.fzf.bash" ] && source "${HOME}/.fzf.bash"

# WSL 2 specific settings
if grep -q "microsoft" /proc/version &>/dev/null; then
      # Requires: https://sourceforge.net/projects/vcxsrv/ (or
      # alternative)
          export DISPLAY="$(/sbin/ip route | awk '/default/ { print $3
        }'):0"

          # Allows your gpg passphrase prompt to spawn (useful for
          # signing commits).
              export GPG_TTY=$(tty)
fi
