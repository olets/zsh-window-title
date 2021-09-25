# zsh-window-title
# https://github.com/olets/zsh-window-title
# A zsh plugin for informative terminal window titles
# Copyright © 2021 Henry Bley-Vroman

'builtin' 'typeset' -g __zwt_dir && \
	__zwt_dir=${0:A:h}

'builtin' 'typeset' -g +r ZWT_VERSION >/dev/null && \
	ZWT_VERSION=1.0.0 && \
	'builtin' 'typeset' -gr ZWT_VERSION

'builtin' 'typeset' -gi +r ZSH_WINDOW_TITLE_DIRECTORY_DEPTH_DEFAULT >/dev/null && \
  ZSH_WINDOW_TITLE_DIRECTORY_DEPTH_DEFAULT=2 && \
  'builtin' 'typeset' -gir ZSH_WINDOW_TITLE_DIRECTORY_DEPTH_DEFAULT

'builtin' 'typeset' -gi ZSH_WINDOW_TITLE_DIRECTORY_DEPTH=${ZSH_WINDOW_TITLE_DIRECTORY_DEPTH:-$ZSH_WINDOW_TITLE_DIRECTORY_DEPTH_DEFAULT}


# zwt CLI subcommands

__zwt:help() {
	'builtin' 'emulate' -LR zsh

	'command' 'man' zwt 2>/dev/null || 'command' 'man' $__zwt_dir/man/man1/zwt.1
}

__zwt:restore-defaults() {
  ZSH_WINDOW_TITLE_DIRECTORY_DEPTH=$ZSH_WINDOW_TITLE_DIRECTORY_DEPTH_DEFAULT
}

__zwt:version() {
	'builtin' 'emulate' -LR zsh

	'builtin' 'print' zwt $ZWT_VERSION
}


# zsh-window-title subcommands 

__zsh-window-title:add-hooks() {
  'builtin' 'emulate' -LR zsh

  # update window title before drawing the prompt
  add-zsh-hook precmd __zsh-window-title:set-window-title-idle

  # update the window title before executing a command
  add-zsh-hook preexec __zsh-window-title:set-window-title-running
}

__zsh-window-title:init() {
  'builtin' 'emulate' -LR zsh

  __zsh-window-title:set-window-title-idle

  # enable hooks
  'builtin' 'autoload' -U add-zsh-hook
  
  __zsh-window-title:add-hooks
}

__zsh-window-title:set-window-title-idle() {
  # set the window title to
  # <parent dir>/<current dir>

  'builtin' 'emulate' -LR zsh

  local title=$(print -P "%$ZSH_WINDOW_TITLE_DIRECTORY_DEPTH~")

  'builtin' 'echo' -ne "\033]0;$title\007"
}

__zsh-window-title:set-window-title-running() {
  # set the window title to
  # <parent dir>/<current dir> - <first word of active command>

  'builtin' 'emulate' -LR zsh

  local title=$(print -P "%$ZSH_WINDOW_TITLE_DIRECTORY_DEPTH~ - ${1[(w)1]}")

  'builtin' 'echo' -ne "\033]0;$title\007"
}

zwt() {
  'builtin' 'emulate' -LR zsh
  
  while (($# )); do
    case $1 in
			"--help"|\
			"-h"|\
			"help")
				__zwt:help
				return
				;;
      "restore-defaults")
        __zwt:restore-defaults
        return
        ;;
			"--version"|\
			"-v"|\
			"version")
				__zwt:version
				return
				;;
      *)
        shift
        ;;
    esac
  done
}

__zsh-window-title:init
