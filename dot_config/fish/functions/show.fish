function show --wraps='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder' --description 'alias show=defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
  defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder $argv
        
end
