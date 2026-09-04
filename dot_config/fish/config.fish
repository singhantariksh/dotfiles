source /usr/share/cachyos-fish-config/cachyos-config.fish

# global editor: nvim
set -Ux EDITOR nvim 

# overwrite greeting (can disable fetch from here)
# Only fetch when launched from Super+Return shortcut (see niri config)
# function fish_greeting
#   if set -q _LAUNCHED_FROM_SHORTCUT
#     zfetch
#     set -e _LAUNCHED_FROM_SHORTCUT
#   end
# end

function fish_greeting
end

# ----------
# ssh setup
# ----------
# Define a predictable socket path for all shell instances
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# Start the agent and bind it to the specific socket if it is not running
if not pgrep -u (whoami) ssh-agent > /dev/null
  ssh-agent -a $SSH_AUTH_SOCK > /dev/null
end

# Add key if not already loaded
if not ssh-add -l | grep -q "id_ed25519" 2>/dev/null
  ssh-add ~/.ssh/id_ed25519 2>/dev/null
end
# ----------

# Vi mode in Fish
# fish_vi_key_bindings

# LS_COLORS using vivid
set -gx LS_COLORS "$(vivid generate tokyonight-night)"

# aliases
alias cat="bat"

# alias gpp="g++"

# learning
alias gcc23="gcc -std=c23 -Wall -Wextra -Wconversion -Wpedantic -Wshadow -g"
alias gpp23="g++ -std=c++23 -Wall -Wextra -Wconversion -Wpedantic -Wshadow -g"

# fast but safe for critical calculations
alias gccf="gcc -std=c23 -O2 -march=native -flto -fno-plt -DNDEBUG"
alias gppf="g++ -std=c++23 -O2 -march=native -flto -fno-plt -DNDEBUG"

# fast as fuck (unsafe mathematics and ignores some safety checks)
alias gccfaf="gcc -std=c23 -Ofast -march=native -flto -fno-plt -DNDEBUG"
alias gppfaf="g++ -std=c++23 -Ofast -march=native -flto -fno-plt -DNDEBUG"

alias lg="lazygit"

alias ls="lsd"
alias lsl="lsd -l"
alias lsa="lsd -a"
alias lsla="lsd -la"
alias lst="lsd --tree"
alias lsta="lsd --tree -a"

alias z="zellij"

# alias dots='/usr/bin/git --git-dir=$HOME/Source/dotfiles/ --work-tree=$HOME'
# alias lgdots='lazygit -git-dir=$HOME/Source/dotfiles/ --work-tree=$HOME'

alias wcp="wl-copy"

alias c="clear"
alias n="nvim"

# alias rmpc="systemctl --user is-active --quiet mpd || { systemctl --user start mpd ; sleep 0.5 ; } ; command rmpc"
alias mpd-stop="systemctl --user stop mpd"
# ----------

# PATH directories
fish_add_path ~/.local/share/nvim/mason/bin
fish_add_path /home/antariksh/.spicetify
fish_add_path ~/.cargo/bin
# ----------

# Starship
starship init fish | source
# Zoxide
zoxide init fish --cmd cd | source
