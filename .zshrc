# Set up the prompt
zmodload zsh/terminfo

export TERM='xterm-256color'

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

PATH="/home/mulder/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/mulder/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/mulder/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/mulder/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/mulder/perl5"; export PERL_MM_OPT;

alias settime='sudo ntpdate time.nist.gov'
alias osupgrade='sudo apt-get update && sudo apt-get dist-upgrade'
alias sdr='screen -Aadr'
alias mkpasswd="head -c25 /dev/urandom | xxd -ps"

alias gcl='git log --all --graph --oneline --decorate --color'
alias gadd='git add'
alias gcm='git commit -m'
alias gs='git status'
alias gd='git diff'

export PAGER='less'
export LESS="-RFX -iMSx4"

EDITOR='mcedit'
VISUAL=$EDITOR
export EDITOR VISUAL

LANG="ru_RU.UTF-8"; export LANG
LC_ALL="ru_RU.UTF-8"; export LC_ALL
LANGUAGE="ru_RU.UTF-8"; export LANGUAGE

alias df='df -h'

if [ -f ~/.agent ]; then
  . ~/.agent
 if ps -p $SSH_AGENT_PID > /dev/null && [ -S $SSH_AUTH_SOCK ]; then
  echo "ssh agent ok"
 else
  unset SSH_AUTH_SOCK
  unset SSH_AGENT_PID
  eval 	`ssh-agent -s`
  echo -e "SSH_AUTH_SOCK=$SSH_AUTH_SOCK\nSSH_AGENT_PID=$SSH_AGENT_PID" > ~/.agent
  ssh-add
  echo "ssh agent ok"
 fi
else
  unset SSH_AUTH_SOCK
  unset SSH_AGENT_PID
  eval `ssh-agent -s`
  echo -e "SSH_AUTH_SOCK=$SSH_AUTH_SOCK\nSSH_AGENT_PID=$SSH_AGENT_PID" > ~/.agent
  ssh-add 
  echo "ssh agent ok"
fi
bindkey '^i' expand-or-complete-prefix
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[2~" overwrite-mode
bindkey "^[[3~" delete-char
if [ -f $HOME/.rbenv/ ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
    eval "$(rbenv init -)"
fi

export PAGER='less' 
export LESS='-RFX -iMSx4'

