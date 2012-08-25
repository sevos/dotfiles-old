# This script should be called always after configuring $PATH

RELATIVE_BIN_DIR=$HOME/.dotfiles/relative_bin


function __relative_bin_path() {
  echo $RELATIVE_BIN_DIR$(pwd)
}

# Call this function in the beginning of your prompt_command
function __relative_bin_set_path() {
  local sed_filter cleaned_path
  sed_filter="s#\\${RELATIVE_BIN_DIR}/[^:]*:##g"
  cleaned_path=$(echo $PATH | sed $sed_filter)
  chmod +x $(__relative_bin_path)/*
  export PATH=$(__relative_bin_path):$cleaned_path
}

function cd_relative_bin() {
  md $(__relative_bin_path)
}

function edit_relative_bin() {
  mkdir -p $(__relative_bin_path)
  if [[ "$1" ]]; then
    q -w $(__relative_bin_path)/$1
  else
    q $(__relative_bin_path)
  fi
}
