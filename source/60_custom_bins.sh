# This script should be called always after configuring $PATH

DEFAULT_PATH=$PATH
RELATIVE_BIN_DIR=$HOME/.dotfiles/relative_bin


function __relative_bin_path() {
  echo $RELATIVE_BIN_DIR$(pwd)
}

# Call this function in the beginning of your prompt_command
function __relative_bin_set_path() {
  local sed_filter relative_path

  export PATH=$(__relative_bin_path):$DEFAULT_PATH
}

function cd_relative_bin() {
  md $(__relative_bin_path)
}
