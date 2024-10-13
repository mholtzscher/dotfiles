function treed --wraps='lsd --tree -a -d --ignore-glob .git --ignore-glob gen' --description 'alias treed=lsd --tree -a -d --ignore-glob .git --ignore-glob gen'
  lsd --tree -a -d --ignore-glob .git --ignore-glob gen $argv
        
end
