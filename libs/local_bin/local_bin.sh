################################################################################
# Initialization                                                               #
################################################################################

# Setup local bin dir
[[ "$LOCAL_BIN_DIR" ]] || export LOCAL_BIN_DIR=$HOME/.local_bin

# Try to set local bin as prompt command

if [[ ! "$PROMPT_COMMAND" ]]; then
  export PROMPT_COMMAND='__local_bin_set_path'
else
  # if prompt command is set, invoke it and check whether
  # local bin is working properly

$PROMPT_COMMAND

  [[ "${__LOCAL_BIN_WORKS}" ]] || cat <<ERROR
local_bin is not configured properly. It tried to set PROMPT_COMMAND,
but it seems that you already have one. In order to make local_bin work,
you need to call __local_bin_set_path in your PROMPT_COMMAND.
ERROR
fi

################################################################################
# Commands                                                                     #
################################################################################

local_bin() {
  local cmd=$1

  if [[ "$cmd" == "cd" ]]; then
    __local_bin_cd
  elif [[ "$cmd" == "edit" ]]; then
    __local_bin_edit $2
  fi
}

localbin() {
  local_bin $@
}

################################################################################
# Internals                                                                    #
################################################################################


__local_bin_current_path() {
  echo $LOCAL_BIN_DIR$(pwd)
}

# Call this function in the beginning of your prompt_command
__local_bin_set_path() {
  local sed_filter cleaned_path
  sed_filter="s#\\${LOCAL_BIN_DIR}/[^:]*:##g"
  cleaned_path=$(echo $PATH | sed $sed_filter)
  chmod -R +x $LOCAL_BIN_DIR/*
  export PATH=$(__local_bin_current_path):$cleaned_path
  export __LOCAL_BIN_WORKS=1
}

__local_bin_cd() {
  cd $(__local_bin_current_path)
}

__local_bin_edit() {
  mkdir -p $(__local_bin_current_path)
  if [[ "$1" ]]; then
    edit -w $(__local_bin_current_path)/$1
  else
    edit $(__local_bin_current_path)
  fi
}

__local_bin_help() {
  echo "help todo"
}
