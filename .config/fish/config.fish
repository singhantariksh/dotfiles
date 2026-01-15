source /usr/share/cachyos-fish-config/cachyos-config.fish

# global editor: nvim
set -Ux EDITOR nvim 

# overwrite greeting (can disable fastfetch from here)
# Only show fastfetch when launched from Super+Return shortcut (see niri config)
function fish_greeting
  if set -q _LAUNCHED_FROM_SHORTCUT
    # fastfetch
    fastfetch -l none
    set -e _LAUNCHED_FROM_SHORTCUT
  end
end

# ----------
# ssh setup
# ----------
# Start ssh-agent if not already running
if not pgrep -u (whoami) ssh-agent > /dev/null
  ssh-agent -c | source
end

# Add key if not already loaded
if not ssh-add -l | grep -q "id_ed25519"
  ssh-add ~/.ssh/id_ed25519 > /dev/null
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

alias ff="fastfetch -l none"
alias ffl="fastfetch"

alias gpp="g++"

alias lg="lazygit"

alias ls="lsd"
alias ll="lsd -l"
alias la="lsd -a"
alias lla="lsd -la"
alias lt="lsd --tree"
alias lta="lsd --tree -a"

alias cd="z"

alias dots='/usr/bin/git --git-dir=$HOME/Source/dotfiles/ --work-tree=$HOME'
alias lgdots='lazygit --git-dir=$HOME/Source/dotfiles/ --work-tree=$HOME'
# ----------

# PATH directories
fish_add_path ~/.local/share/nvim/mason/bin
fish_add_path /home/antariksh/.spicetify
fish_add_path ~/.cargo/bin
# ----------

# Starship
starship init fish | source
# Zoxide
zoxide init fish | source
