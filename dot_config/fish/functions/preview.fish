# Created command (preview) to quickly start browser-sync on the current working directory
function preview --description 'Start browser-sync on cwd'
  browser-sync start --server --directory --files "*.html,*.css,*.js" $argv
end
