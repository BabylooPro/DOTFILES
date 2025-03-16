# ENABLE POWERLEVEL10K INSTANT PROMPT. SHOULD STAY CLOSE TO THE TOP OF ~/.ZSHRC
# INITIALIZATION CODE THAT MAY REQUIRE CONSOLE INPUT (PASSWORD PROMPTS, [Y/N]
# CONFIRMATIONS, ETC.) MUST GO ABOVE THIS BLOCK; EVERYTHING ELSE MAY GO BELOW
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# INITIALIZE HOMEBREW ENVIRONMENT VARIABLES
eval "$(/opt/homebrew/bin/brew shellenv)"

# SET DIRECTORY TO STORE ZINIT AND PLUGINS
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# DOWNLOAD ZINIT, IF IT'S NO THERE YET
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# SOURCE/LOAD ZINIT
source "${ZINIT_HOME}/zinit.zsh"

# ADDING POWERLEVEL10K
zinit ice depth=1; zinit light romkatv/powerlevel10k

# ADDING ZSH PLUGINS
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# LOAD COMPLETIONS
autoload -U compinit && compinit

# SILENTLY RELOAD ZINIT PLUGINS WITHOUT
zinit cdreplay -q

# CLEAR TERMINAL
clear

# TO CUSTOMIZE PROMPT, RUN  OR EDIT ~/.P10K.ZSH
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# KEYBINDINGS CONFIGURATION
bindkey -e                                          # SET EMACS KEYBINDINGS MODE
bindkey '^p' history-search-backward                # SEARCH COMMAND HISTORY BACKWARD (CTRL+P)
bindkey '^n' history-search-forward                 # SEARCH COMMAND HISTORY FORWARD (CTRL+N)
bindkey '^[w' kill-region                           # DELETE TEXT FROM CURSOR POSITION TO PREVIOUS WORD (ALT+W)
bindkey "^[[A" history-beginning-search-backward    # UP ARROW SEARCHES HISTORY BACKWARD BASED ON PREFIX
bindkey "^[[B" history-beginning-search-forward     # DOWN ARROW SEARCHES HISTORY FORWARD BASED ON PREFIX

# HISTORY CONFIGURATION
HISTSIZE=5000                 # MAXIMUM NUMBER OF ENTRIES IN THE HISTORY FILE
HISTFILE=~/.zsh_history       # LOCATION OF THE HISTORY FILE
SAVEHIST=$HISTSIZE            # SAVE HISTORY FILE WITH THE SAME NUMBER OF ENTRIES AS HISTSIZE
HISTDUP=erase                 # REMOVE DUPLICATE COMMANDS FROM HISTORY
setopt appendhistory          # APPEND COMMANDS TO HISTORY FILE INSTEAD OF OVERWRITING IT
setopt sharehistory           # SHARE HISTORY ACROSS MULTIPLE ZSH SESSIONS
setopt hist_ignore_space      # IGNORE COMMANDS STARTING WITH A SPACE IN HISTORY
setopt hist_ignore_all_dups   # REMOVE ALL DUPLICATE COMMANDS FROM HISTORY
setopt hist_save_no_dups      # PREVENT SAVING DUPLICATE COMMANDS CONSECUTIVELY
setopt hist_ignore_dups       # AVOID STORING DUPLICATE COMMANDS IN HISTORY
setopt hist_find_no_dups      # AVOID SHOWING DUPLICATES WHEN SEARCHING HISTORY

# COMPLETION STYLING
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*" list-color "${(s.:.)LS_COLORS}"
zstyle ":completion:*" menu no
zstyle ":fzf-tab:complete:cd:*" fzf-preview 'ls -la --color=always ${(Q)realpath}'

# AMAZON Q POST BLOCK #! DISABLED FOR TESTING WITHOUT
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# ALIASES CONFIGURATION
alias ls="ls --color"
alias dot='git --git-dir=/Users/maxremy/.dotfiles --work-tree=/Users/maxremy' # DOTFILES MANAGEMENT
alias code="open -a 'Visual Studio Code'"
alias cursor='/Applications/Cursor.app/Contents/MacOS/Cursor'

# PATHS CONFIGURATION
export PATH=$HOME/DEV/flutter_sdk/bin:$PATH
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH=~/.console-ninja/.bin:$PATH
export DOTNET_CLI_UI_LANGUAGE=en-US

# SHELL INTEGRATIONS
eval "$(fzf --zsh)"
