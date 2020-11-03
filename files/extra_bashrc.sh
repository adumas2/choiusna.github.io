# this is meant to be sourced into your .bashrc
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "ERROR: This script is not meant to be run on its own,"
  echo "but sourced into your bashrc with a line like"
  echo "  source $0"
  exit 1
fi

# try to load a script, otherwise fail silently
function sourceif {
  while [ $# -gt 0 ]; do
    if [ -f "$1" ]; then
      . "$1"
    fi
    shift
  done
}

# try to add something to the current PATH
function pathif {
  while [[ $# -gt 0 ]]; do
    [[ -d "$1"  && ! ":$PATH:" == *":$1:"* ]] && export PATH="$1:$PATH"
    shift
  done
}

# make sure bin directory is in path
pathif "$HOME/bin"

umask 066            # default permissions set to -rw------
ulimit -c 0          # prevent large core files

# special setup stuff for wsl
if grep -iq 'microsoft\|wsl' /proc/version; then
  cd
  if ! grep -q '^C:.*\<metadata\>' /etc/mtab; then
    echo "Need to remount the C: drive - you may be asked for your Ubuntu password." >&2
    sudo umount /mnt/c && sleep 2s && sudo mount -t drvfs -o metadata C: /mnt/c && echo "success" || echo "ERROR: you will probably have trouble. Try closing and restarting." >&2
  fi

  # start X server if it isn't already
  if which xprop >/dev/null && ! xprop -root &>/dev/null; then
    (
      # look for vcxsrv
      xlaunch="/mnt/c/Program Files/VcXsrv/xlaunch.exe"
      if [[ -x $xlaunch ]]; then
        winhome=$(cd /mnt/c/Windows/System32 && ./cmd.exe /c 'echo %HOMEPATH%' | tr -d '\r')
        winhome="/mnt/c${winhome//\\//}"
        xlconfig="$winhome/config.xlaunch"
        if [[ ! -e $xlconfig ]]; then
          cat >"$xlconfig" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<XLaunch WindowMode="MultiWindow" ClientMode="NoClient" LocalClient="False" Display="0" LocalProgram="xcalc" RemoteProgram="xterm" RemotePassword="" PrivateKey="" RemoteHost="" RemoteUser="" XDMCPHost="" XDMCPBroadcast="False" XDMCPIndirect="False" Clipboard="True" ClipboardPrimary="True" ExtraParams="" Wgl="True" DisableAC="False" XDMCPTerminate="False"/>
EOF
        fi
        xc1=${xlconfig/\/mnt\/c/C:}
        xc2=${xc1//\//\\}
        nohup "$xlaunch" -run "$xc2" &>/dev/null
      fi
    )
  fi
  export DISPLAY=:0
  # this is to avoid tininess or bluriness
  # XXX you might want to override if you use a big monitor and not your laptop screen
  export GDK_SCALE=2
  export CLUTTER_SCALE=2
  export QT_SCALE_FACTOR=2
fi

# Quit now if not running an interactive shell
[[ $- =~ i ]] || return 0

# Shell options

shopt -s checkhash
shopt -s checkwinsize
shopt -s checkjobs

set -o ignoreeof
# set -o vi
shopt -s cdspell
shopt -s expand_aliases

shopt -s extglob
shopt -s nocaseglob
# shopt -s nullglob
shopt -s globstar

shopt -s cmdhist
shopt -s lithist
shopt -s histappend
shopt -s histreedit
shopt -s histverify
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="&" # removes consecutive duplicate commands

# set the proper editor
[[ -e /usr/bin/vim ]] && EDITOR=/usr/bin/vim
[[ -e /usr/bin/gvim ]] && VISUAL=/usr/bin/gvim

# detect color capability
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt

# displays exit status after each command
sourceif /usr/share/doc/bash/examples/functions/exitstat

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'

  # colored GCC warnings and errors
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
fi



# make less behave in the presence of unusual characters
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Aliases
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias vi="vim"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias cd..='cd ..'  # takes care of that typical typo
alias EXIT='exit'   # in case caps lock gets stuck
alias clean='rm *~' # cleanup all those emacs ~ files
alias h='history | tail'
alias xterm="gnome-terminal"

# avoid annoying empty git commit messages on merge
export GIT_MERGE_AUTOEDIT=no

# If this is an xterm set more declarative titles
# "dir: last_cmd" and "actual_cmd" during execution
# If you want to exclude a cmd from being printed see line 156
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\$(print_title)\a\]$PS1"
    __el_LAST_EXECUTED_COMMAND=""
    print_title ()
    {
        __el_FIRSTPART=""
        __el_SECONDPART=""
        if [ "$PWD" == "$HOME" ]; then
            __el_FIRSTPART=$(gettext --domain="pantheon-files" "Home")
        else
            if [ "$PWD" == "/" ]; then
                __el_FIRSTPART="/"
            else
                __el_FIRSTPART="${PWD##*/}"
            fi
        fi
        if [[ "$__el_LAST_EXECUTED_COMMAND" == "" ]]; then
            echo "$__el_FIRSTPART"
            return
        fi
        #trim the command to the first segment and strip sudo
        if [[ "$__el_LAST_EXECUTED_COMMAND" == sudo* ]]; then
            __el_SECONDPART="${__el_LAST_EXECUTED_COMMAND:5}"
            __el_SECONDPART="${__el_SECONDPART%% *}"
        else
            __el_SECONDPART="${__el_LAST_EXECUTED_COMMAND%% *}"
        fi
        printf "%s: %s" "$__el_FIRSTPART" "$__el_SECONDPART"
    }
    put_title()
    {
        __el_LAST_EXECUTED_COMMAND="${BASH_COMMAND}"
        printf "\033]0;%s\007" "$1"
    }

    # Show the currently running command in the terminal title:
    # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
    update_tab_command()
    {
        # catch blacklisted commands and nested escapes
        case "$BASH_COMMAND" in
            *\033]0*|update_*|echo*|printf*|clear*|cd*)
            __el_LAST_EXECUTED_COMMAND=""
                ;;
            *)
            put_title "${BASH_COMMAND}"
            ;;
        esac
    }
    preexec_functions+=(update_tab_command)
    ;;
*)
    ;;
esac
