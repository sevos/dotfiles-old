# My awesome bash prompt

# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

. $HOME/.dotfiles/libs/powerline/powerline/bindings/bash/powerline.sh

function prompt_command() {
  PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#I_#P") "$PWD")'
}

PROMPT_COMMAND="prompt_command"
