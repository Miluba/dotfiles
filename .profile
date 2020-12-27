#!/usr/bin/env bash
# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# Add all local binary paths to the system path.
export PATH="${PATH}:${HOME}/.local/bin"

# Default programs to run.
export EDITOR="vim"

# Add colors to the less and man commands.
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '="${a%_}"
export LESS_TERMCAP_md="$(printf '%b' '="${a%_}"
export LESS_TERMCAP_me="$(printf '%b' '="${a%_}"
export LESS_TERMCAP_so="$(printf '%b' '="${a%_}"
export LESS_TERMCAP_se="$(printf '%b' '="${a%_}"
export LESS_TERMCAP_us="$(printf '%b' '="${a%_}"
export LESS_TERMCAP_ue="$(printf '%b' '="${a%_}"

eval "$(dircolors /etc/DIR_COLORS)"

# If bash is the login shell, then source ~/.bashrc if it exists.
echo "${0}" | grep "bash$" >/dev/null \
    && [ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"

