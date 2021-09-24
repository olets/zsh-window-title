# zsh-window-title
# https://github.com/olets/zsh-window-title
# A zsh plugin for informative terminal window titles
# Copyright © 2021 Henry Bley-Vroman

typeset -gir ZSH_WINDOW_TITLE_DIRECTORY_DEPTH_DEFAULT=2
typeset -gi ZSH_WINDOW_TITLE_DIRECTORY_DEPTH=${ZSH_WINDOW_TITLE_DIRECTORY_DEPTH:-$ZSH_WINDOW_TITLE_DIRECTORY_DEPTH_DEFAULT}

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

__zsh-window-title:restore-defaults() {
  ZSH_WINDOW_TITLE_DIRECTORY_DEPTH=$ZSH_WINDOW_TITLE_DIRECTORY_DEPTH_DEFAULT
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
  while (($# )); do
    case $1 in
      "restore-defaults")
        __zsh-window-title:restore-defaults
        return
        ;;
      *)
        shift
        ;;
    esac
  done
}

__zsh-window-title:init
