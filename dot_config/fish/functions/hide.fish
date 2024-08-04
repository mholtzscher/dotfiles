function hide --wraps='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder' --description 'alias hide=defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
  defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder $argv
        
end
