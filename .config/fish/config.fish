source /usr/share/cachyos-fish-config/cachyos-config.fish

# global editor: nvim
set -Ux EDITOR nvim 

# overwrite greeting (can disable fetch from here)
# Only fetch when launched from Super+Return shortcut (see niri config)
function fish_greeting
  if set -q _LAUNCHED_FROM_SHORTCUT
    zfetch
    set -e _LAUNCHED_FROM_SHORTCUT
  end
end

# ----------
# ssh setup
# ----------
# Start ssh-agent if not already running
if not pgrep -u (whoami) ssh-agent &> /dev/null
  ssh-agent -c | source
end

# Add key if not already loaded
if not ssh-add -l | grep -q "id_ed25519"
  ssh-add ~/.ssh/id_ed25519 &> /dev/null
end
# ----------

# ----------
# Web Dev
# ----------
# Created command (preview) to quickly start browser-sync on the current working directory
function preview --description 'Start browser-sync on cwd'
  browser-sync start --server --directory --files "*.html, *.css, *.js" $argv
end

# Created command (preview-file) to quickly prevuew a specific file 
function preview-file --description 'Preview a specific file'
  set file $argv[1]
  if test -z "$file"
    echo "Usage: preview-file <filename.html>"
    return 1
  end
  browser-sync start --server --files "*.html, *.css, *.js" --startPath "/$file"
end
# ----------

# Yazi shell wrapper setup
function y
  set tmp (mktemp -t "yazi-cwd.XXXXXX")
  yazi $argv --cwd-file="$tmp"
  if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    builtin cd -- "$cwd"
  end
  rm -f -- "$tmp"
end
# ----------

# LS_COLORS using vivid
set -gx LS_COLORS "$(vivid generate tokyonight-night)"

# aliases
alias cat="bat"

alias gpp="g++"

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
alias ll="lsd -l"
alias la="lsd -a"
alias lla="lsd -la"
alias lt="lsd --tree"
alias lta="lsd --tree -a"

alias z="zellij"

alias dots='/usr/bin/git --git-dir=$HOME/Source/dotfiles/ --work-tree=$HOME'
alias lgdots='lazygit --git-dir=$HOME/Source/dotfiles/ --work-tree=$HOME'

alias wcp="wl-copy"

alias c="clear"
alias n="nvim"

alias rmpc="systemctl --user start mpd ; command rmpc"
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
