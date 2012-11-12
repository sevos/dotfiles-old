# My awesome bash prompt

# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

function prompt_command() {
  export PS1="$(~/.dotfiles/libs/powerline-bash.py $?)"
  PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#I_#P") "$PWD")'
}

PROMPT_COMMAND="prompt_command"
