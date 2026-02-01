# ============================================================================
# ZSH Configuration with Powerlevel10k, Advanced Features & Beautiful UI
# ============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# ZSH Options - Core Configuration
# ============================================================================

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from each command line being added to the history.

# Directory Navigation
setopt AUTO_CD                   # Auto cd when typing just a path
setopt AUTO_PUSHD                # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack.
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME             # Push to home directory when no argument is given.
setopt CDABLE_VARS               # Change directory to a path stored in a variable.
setopt MULTIOS                   # Write to multiple descriptors.
setopt EXTENDED_GLOB             # Use extended globbing syntax.
setopt INTERACTIVE_COMMENTS      # Enable comments in interactive shell.
setopt CORRECT                   # Spelling correction for commands
setopt CORRECT_ALL             # Disabled: too aggressive for command arguments
# To completely disable spelling correction, comment out CORRECT above or add: unsetopt CORRECT

# Completion
setopt COMPLETE_IN_WORD          # Complete from both ends of a word.
setopt ALWAYS_TO_END             # Move cursor to the end of a completed word.
setopt PATH_DIRS                 # Perform path search even on command names with slashes.
setopt AUTO_MENU                 # Show completion menu on a successive tab press.
setopt AUTO_LIST                 # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH          # If completed parameter is a directory, add a trailing slash.
setopt MENU_COMPLETE             # Auto-select first completion entry
unsetopt FLOW_CONTROL            # Disable start/stop characters in shell editor.

# ============================================================================
# Plugin Manager - Zinit
# ============================================================================

# Download Zinit if it doesn't exist
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ============================================================================
# Theme - Powerlevel10k (Custom Beautiful Configuration)
# ============================================================================

zinit ice depth=1
zinit light romkatv/powerlevel10k

# ============================================================================
# Essential Plugins
# ============================================================================

# Fast syntax highlighting (must be loaded before autosuggestions)
zinit light zdharma-continuum/fast-syntax-highlighting

# Fish-like autosuggestions
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_COMPLETION_IGNORE='git *'

# Advanced tab completion
zinit light zsh-users/zsh-completions

# History substring search with arrow keys
zinit light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# FZF integration for fuzzy search
zinit light Aloxaf/fzf-tab

# Enhanced directory navigation
zinit light agkozak/zsh-z

# Colored man pages
zinit light ael-code/zsh-colored-man-pages

# You Should Use - reminds you of aliases
zinit light MichaelAquilina/zsh-you-should-use

# Auto-notify for long running commands
zinit light MichaelAquilina/zsh-auto-notify
AUTO_NOTIFY_THRESHOLD=30
AUTO_NOTIFY_TITLE="Command Finished"

# ============================================================================
# FZF Configuration - Fuzzy Finder
# ============================================================================

# Download and setup fzf if not present
if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
fi

# FZF Configuration
export FZF_DEFAULT_OPTS="
--height 60%
--layout=reverse
--border rounded
--inline-info
--color=fg:#c0caf5,bg:#1a1b26,hl:#ff9e64
--color=fg+:#c0caf5,bg+:#283457,hl+:#ff9e64
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind 'ctrl-e:execute(echo {+} | xargs -o vim)'
--bind 'ctrl-v:execute(code {+})'
"

# Use fd if available for faster search
if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# CTRL-T - Paste the selected file path(s) into the command line
export FZF_CTRL_T_OPTS="
--preview 'bat --color=always --line-range :500 {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# CTRL-R - Paste the selected command from history into the command line
export FZF_CTRL_R_OPTS="
--preview 'echo {}' --preview-window up:3:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'
"

# ALT-C - cd into the selected directory
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Source FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================================================================
# FZF-Tab Configuration (Better completion with FZF)
# ============================================================================

# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# Set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath 2>/dev/null || ls -1 $realpath'
# Switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# Apply to all completions
zstyle ':fzf-tab:*' fzf-flags --height=60% --border=rounded
zstyle ':fzf-tab:*' fzf-preview 'less ${(Q)realpath} 2>/dev/null || exa -1 --color=always ${(Q)realpath} 2>/dev/null'

# ============================================================================
# Advanced Key Bindings
# ============================================================================

# Better history search with Up/Down arrows
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Emacs-style key bindings
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
bindkey '^Y' yank

# Accept autosuggestion
bindkey '^ ' autosuggest-accept
bindkey '^f' forward-word

# Edit command in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# ============================================================================
# Completion System
# ============================================================================

autoload -Uz compinit
# Only check cache once a day
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit;
else
    compinit -C;
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%F{green}-- %d --%f%b'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*:corrections' format '%B%F{yellow}-- %d (errors: %e) --%f%b'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Process completion
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always

# SSH/SCP/RSYNC completion
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr

# ============================================================================
# Aliases
# ============================================================================

# Disable correction for specific commands
alias git='nocorrect git'
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias man='nocorrect man'
alias npm='nocorrect npm'
alias yarn='nocorrect yarn'
alias docker='nocorrect docker'
alias kubectl='nocorrect kubectl'

# Modern CLI tools (if available)
if command -v exa &> /dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias la='exa --icons --group-directories-first -a'
    alias ll='exa --icons --group-directories-first -l'
    alias lla='exa --icons --group-directories-first -la'
    alias lt='exa --icons --tree'
else
    alias ls='ls --color=auto'
    alias la='ls -A'
    alias ll='ls -lh'
    alias lla='ls -lAh'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=auto'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --graph --oneline --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Quick edits
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias zshreload='source ~/.zshrc'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ports='netstat -tulanp'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Misc
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias week='date +%V'
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'
alias myip='curl -s ifconfig.me'

# ============================================================================
# Custom Functions
# ============================================================================

# Fast directory switching with fzf
function fcd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}

# Search history with fzf
function fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Kill process with fzf
function fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Create directory and cd into it
function mkcd() {
    mkdir -p "$@" && cd "$_"
}

# Extract any archive
function extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Git clone and cd into it
function gcl() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# ============================================================================
# Environment Variables
# ============================================================================

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LESS='-R -F -X'

# Better colors for ls
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# Path
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

# ============================================================================
# Powerlevel10k Custom Configuration
# ============================================================================
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
