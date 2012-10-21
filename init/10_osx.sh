# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  echo $SUDO_PASSWORD | sudo xcode-select -switch /usr/bin
fi

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | /usr/bin/ruby -e "$(/usr/bin/curl -fsSkL raw.github.com/mxcl/homebrew/go)"
fi

if [[ "$(type -P brew)" ]]; then
  e_header "Updating Homebrew"
  brew update

  # Install Homebrew recipes.
  recipes=(git tree sl lesspipe id3tool git-extras htop-osx man2html tmux bash-completion nmap reattach-to-user-namespace)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi

  if [[ ! "$(type -P gcc-4.2)" ]]; then
    e_header "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi
fi

# iTerm

if [[ ! -e /Applications/iTerm.app ]]; then
  e_header "Installing iTerm"
  e_arrow "Downloading..."
  curl -L http://iterm2.googlecode.com/files/iTerm2-1_0_0_20120726.zip -o iterm.zip -s
  [[ -e iterm.zip ]] || exit 1
  e_arrow "Installing..."
  unzip iterm.zip iTerm.app/* 1>/dev/null
  echo $SUDO_PASSWORD | sudo mv iTerm.app /Applications/
  rm iterm.zip
fi
