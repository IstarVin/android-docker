# Minimal zshrc for Android ROM building environment

# History configuration
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Enable colors
autoload -Uz colors && colors

# Basic completion system
autoload -Uz compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Keybindings
bindkey -v  # Vi mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Useful aliases for Android building
alias l='ls -lh'
alias ll='ls -lh'
alias la='ls -lah'
alias c='clear'
alias ..='cd ..'
alias ~='cd ~'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log'
alias gd='git diff'

# Ccache helpers
alias ccache-stats='ccache -s'
alias ccache-clear='ccache -C'

# Android build helpers
alias breakfast='source build/envsetup.sh && breakfast'
alias brunch='source build/envsetup.sh && brunch'
alias mka='source build/envsetup.sh && mka'

# Simple prompt
PROMPT='%F{cyan}%n@%m%f:%F{blue}%~%f$ '

# Environment variables for Android building
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

# Add color to common commands
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

# PATH configuration
PATH="/usr/local/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
export PATH
