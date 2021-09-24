# zsh-window-title
# https://github.com/olets/zsh-window-title
# A zsh plugin for informative terminal window titles
# Copyright © 2021 Henry Bley-Vroman

__zwt-set-window-title-idle() {
  # set the window title to
  # <parent dir>/<current dir>

  'builtin' 'emulate' -LR zsh

  local title=$(print -P "%2~")

  'builtin' 'echo' -ne "\033]0;$title\007"
}

__zwt-set-window-title-running() {
  # set the window title to
  # <parent dir>/<current dir> - <first word of active command>

  'builtin' 'emulate' -LR zsh

  local title=$(print -P "%2~ - ${1[(w)1]}")

  'builtin' 'echo' -ne "\033]0;$title\007"
}

__zwt-add-hooks() {
  'builtin' 'emulate' -LR zsh

  # update window title before drawing the prompt
  add-zsh-hook precmd __zwt-set-window-title-idle

  # update the window title before executing a command
  add-zsh-hook preexec __zwt-set-window-title-running
}

__zwt-init() {
  'builtin' 'emulate' -LR zsh
  
  __zwt-set-window-title-idle

  # enable hooks
  'builtin' 'autoload' -U add-zsh-hook
  
  __zwt-add-hooks
}

__zwt-init
