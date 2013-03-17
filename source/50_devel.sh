export PATH

# RVM
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm  # This loads RVM into a shell session.
PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting

alias r='rebar'
alias rh='rebar -c'
alias erl='erl -name term@127.0.0.1 -pa $PWD/ebin -pa $PWD/apps/*/ebin -pa $PWD/deps/*/ebin'

alias e='emacsclient -c -n'
alias ec='emacsclient -c'
alias ex='open -a /Applications/Emacs.app "$@"'
alias ek='launchctl unload -w ~/Library/LaunchAgents/gnu.emacs.daemon.plist ; killall Emacs ; launchctl load -w ~/Library/LaunchAgents/gnu.emacs.daemon'
export ALTERNATE_EDITOR=""
