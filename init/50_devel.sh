# Load npm_globals, add the default node into the path.
source ~/.dotfiles/source/50_devel.sh

e_header "Python"
if [[ ! -x "/usr/local/bin/pip" ]]; then
  echo $SUDO_PASSWORD | sudo easy_install pip && e_success "Installed pip" || e_error "Failed to install pip"
else
  e_success "Already installed pip"
fi
if [[ ! -x "/usr/local/bin/virtualenv" ]]; then
  echo $SUDO_PASSWORD | sudo pip install virtualenv virtualenvwrapper 1>/dev/null && e_success "Installed virtualenv" || e_error "Failed to install virtualenv"
else
  e_success "Already installed virtualenv"
fi
mkdir -p $WORKON_HOME

# Install Node.js.
#  if [[ "$(type -P nave)" ]]; then
#   nave_stable="$(nave stable)"
#   if [[ "$(node --version 2>/dev/null)" != "v$nave_stable" ]]; then
#     e_header "Installing Node.js $nave_stable"
#     # Install most recent stable version.
#     nave install stable >/dev/null 2>&1
#   fi
#   if [[ "$(nave ls | awk '/^default/ {print $2}')" != "$nave_stable" ]]; then
#     # Alias the stable version of node as "default".
#     nave use default stable true
#   fi
# fi

# # Load npm_globals, add the default node into the path, initialize rbenv.
# source ~/.dotfiles/source/50_devel.sh

# # Install Npm modules.
# if [[ "$(type -P npm)" ]]; then
#   e_header "Updating Npm"
#   npm update -g npm

#   { pushd "$(npm config get prefix)/lib/node_modules"; installed=(*); popd; } > /dev/null
#   list="$(to_install "${npm_globals[*]}" "${installed[*]}")"
#   if [[ "$list" ]]; then
#     e_header "Installing Npm modules: $list"
#     npm install -g $list
#   fi
# fi

# Install Ruby.
# if [[ "$(type -P rbenv)" ]]; then
#   versions=(1.9.3-p194 1.9.2-p290)

#   list="$(to_install "${versions[*]}" "$(rbenv whence ruby)")"
#   if [[ "$list" ]]; then
#     e_header "Installing Ruby versions: $list"
#     for version in $list; do rbenv install "$version"; done
#     [[ "$(echo "$list" | grep -w "${versions[0]}")" ]] && rbenv global "${versions[0]}"
#     rbenv rehash
#   fi
# fi

# Install Gems.
# if [[ "$(type -P gem)" ]]; then
#   gems=(bundler awesome_print interactive_editor)

#   list="$(to_install "${gems[*]}" "$(gem list | awk '{print $1}')")"
#   if [[ "$list" ]]; then
#     e_header "Installing Ruby gems: $list"
#     gem install $list
#   fi
# fi

