# My awesome bash prompt

# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

function prompt_command() {
  export PS1="$(~/.dotfiles/libs/powerline-bash.py $?)"
}

PROMPT_COMMAND="prompt_command"
