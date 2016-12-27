# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=200
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/teddy/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

## User settings
# Set the prompt
autoload -Uz promptinit
promptinit
# prompt zefram
prompt adam2

# colors!
autoload -U colors
colors

# Load aliases
source ~/.zsh_aliases

# SSH: ssh-agent is automatically started on login
# Ask for passphrase when key is first used
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

# Environment variables
export EDITOR="vim"

# Go requirements
export GOPATH=$HOME/Go
export PATH=$PATH:$GOPATH/bin

# Ruby (gems) requirements
export PATH=$PATH:$HOME/.gem/ruby/2.2.0/bin

# Haskell: Use Cabal packages
export PATH=$PATH:$HOME/.cabal/bin

# Show which mode we're currently (normal or insert)
vim_ins_mode="[INS]"
vim_cmd_mode="[CMD]"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
  echo # Without the echo, the reset prompt eats the previous lines on the adam2 prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish
RPROMPT='${vim_mode}'
setopt transient_rprompt

# Try to load Xresources for ~*~colors~*~
# This should be automatically loaded by LXDE
#xrdb ~/.Xresources

# Automatically push current directory when cd'ing (auto pushd)
setopt autopushd
setopt pushd_ignore_dups

# Avoid duplicate lines in history
setopt hist_ignore_dups

### DON'T ADD ANYTHING BELOW
## (because this is the complex stuff. Just leave it at the bottom.
# Getting special keys to work in ZSH, from the arch wiki
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
#[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
#[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
# Correctly bind backspace
bindkey "^?" backward-delete-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Search history using PGUP and PGDN
# from the arch wiki
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

# OPAM configuration
. /home/teddy/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
