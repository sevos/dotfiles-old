# This script should be called always after configuring $PATH

DEFAULT_PATH=$PATH
CUSTOM_BINS_DIR=$HOME/.dotfiles/custom_bins

# Call this function in the beginning of your prompt_command
function __custom_bins_set_path() {
  local sed_filter relative_path
  sed_filter="s#\\${HOME}/##g"
  relative_path="$(pwd | sed ${sed_filter})"

  PATH=$CUSTOM_BINS_DIR$relative_path:$DEFAULT_PATH
}
