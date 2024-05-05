#!/bin/sh
# Description: Setup MacOS and applications

# Set the dock size
defaults write com.apple.dock "tilesize" -int "48" && killall Dock

# Set the dock position
defaults write com.apple.Dock orientation -string bottom && killall Dock

# Diable dock autohide
defaults write com.apple.Dock autohide -bool false && killall Dock

# Disable recent applications in dock
defaults write com.apple.dock "show-recents" -bool "false" && killall Dock

# Set the dock to minimize to the application
defaults write com.apple.dock "minimize-to-application" -bool "true" && killall Dock

# Set the screenshot location
defaults write com.apple.screencapture "location" -string "~/Library/Mobile Documents/com~apple~CloudDocs/ScreenShots" && killall SystemUIServer

# Set Nifthfall to launch on startup
defaults write net.ryanthomson.Nightfall "StartAtLogin" -bool "true"
