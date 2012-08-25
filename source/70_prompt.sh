# My awesome bash prompt
#
# Copyright (c) 2012 "Cowboy" Ben Alman
# Licensed under the MIT license.
# http://benalman.com/about/license/
#
# Example:
# [master:!?][cowboy@CowBook:~/.dotfiles]
# [11:14:45] $
#
# Read more (and see a screenshot) in the "Prompt" section of
# https://github.com/cowboy/dotfiles

# ANSI CODES - SEPARATE MULTIPLE VALUES WITH ;
#
#  0  reset          4  underline
#  1  bold           7  inverse
#
# FG  BG  COLOR     FG  BG  COLOR
# 30  40  black     34  44  blue
# 31  41  red       35  45  magenta
# 32  42  green     36  46  cyan
# 33  43  yellow    37  47  white

if [[ ! "${prompt_colors[@]}" ]]; then
  prompt_colors=(
    "1;34" # information color
    "37" # bracket color
    "31" # error color
    "1;32" # scm clean
    "1;33" # scm dirty
  )

  if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    prompt_colors[0]="32"
  elif [[ "$USER" == "root" ]]; then
    # logged in as root
    prompt_colors[0]="35"
  fi
fi

# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
alias prompt_getcolors='prompt_colors[9]=; local i; for i in ${!prompt_colors[@]}; do local c$i="\[\e[0;${prompt_colors[$i]}m\]"; done'

# Exit code of previous command.
function prompt_exitcode() {
  prompt_getcolors
  [[ $1 != 0 ]] && echo " $c2$1$c9"
}

# Git status.
function prompt_git() {
  prompt_getcolors
  local status local_branch_name local_branch local_flags remote_branch remote_branch_name
  status="$(git status 2>/dev/null)"
  [[ $? != 0 ]] && return;
  local_branch="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$local_branch" ]] || local_branch="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$local_branch" ]] || local_branch="$(git branch | perl -ne '/^\* (.*)/ && print $1')"
  local_branch_name=$local_branch
  local_flags="$(
    echo "$status" | awk 'BEGIN {r=""} \
      /^# Changes to be committed:$/        {r=r "+"}\
      /^# Changes not staged for commit:$/  {r=r "!"}\
      /^# Untracked files:$/                {r=r "?"}\
      END {print r}'
  )"
  if [[ "$local_flags" ]]; then
    local_branch="$local_branch$c1:$c4  $local_flags"
    local_branch="$c4$local_branch"
  else
    local_branch="$c3$local_branch"
  fi

  remote_branch_name="$(git for-each-ref --format='%(upstream:short)' refs/heads/${local_branch_name})"
  if [[ "$remote_branch_name" && ! "$local_branch_name" == "$remote_branch_name" ]]; then
    local local_sha remote_sha
    local_sha="$(git for-each-ref --format='%(objectname)' refs/heads/${local_branch_name})"
    remote_sha="$(git for-each-ref --format='%(objectname)' refs/remotes/${remote_branch_name})"
    if [[ "$local_sha" == "$remote_sha" ]]; then
      remote_branch="$c3$remote_branch_name"
    else
      remote_branch="$c4$remote_branch_name"
    fi
    echo "$c1[$local_branch$c1 <-> $remote_branch$c1]$c9"
  else
    echo "$c1[$local_branch$c1]$c9"
  fi
}

# SVN info.
function prompt_svn() {
  prompt_getcolors
  local info="$(svn info . 2> /dev/null)"
  local last current
  if [[ "$info" ]]; then
    last="$(echo "$info" | awk '/Last Changed Rev:/ {print $4}')"
    current="$(echo "$info" | awk '/Revision:/ {print $2}')"
    echo "$c1[$c0$last$c1:$c0$current$c1]$c9"
  fi
}

# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

function prompt_command() {
  __custom_bins_set_path
  local exit_code=$?
  # If the first command in the stack is prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${prompt_stack[0]}" == "prompt_command" ]] && exit_code=0
  prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  [[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  [[ "$simple_prompt" ]] && PS1='\n$ ' && return

  prompt_getcolors
  # http://twitter.com/cowboy/status/150254030654939137
  PS1="\n"
  # git: [branch:flags]
  PS1="$PS1$(prompt_git)"
  # misc: [cmd#:hist#]
  # PS1="$PS1$c1[$c0#\#$c1:$c0!\!$c1]$c9"
  # path: [user@host:path]
  PS1="$PS1$c1[$c0\u$c1@$c0\h$c1:$c0\w$c1]$c9"
  PS1="$PS1\n"
  # date: [HH:MM:SS]
  PS1="$PS1$c1[$c0$(date +"%H$c1:$c0%M$c1:$c0%S")$c1]$c9"
  # exit code: 127
  PS1="$PS1$(prompt_exitcode "$exit_code")"
  PS1="$PS1 \$ "
}

PROMPT_COMMAND="prompt_command"
