# Created command (preview-file) to quickly prevuew a specific file 
function preview-file --description 'Preview a specific file'
  set file $argv[1]
  if test -z "$file"
    echo "Usage: preview-file <filename.html>"
    return 1
  end
  browser-sync start --server --files "*.html,*.css,*.js" --startPath "/$file"
end
