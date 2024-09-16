function clean --wraps='git clean -Xdf' --description 'Remove files that are in gitignore'
    git clean -Xdf $argv
end
