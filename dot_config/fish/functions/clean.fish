function clean --wraps='git clean -Xdf' --description 'alias clean=git clean -Xdf'
  git clean -Xdf $argv
        
end
