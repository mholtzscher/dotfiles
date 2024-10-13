function tree --wraps='lsd --tree -a --ignore-glob .git' --description 'alias tree=lsd --tree -a --ignore-glob .git'
  lsd --tree -a --ignore-glob .git $argv
        
end
