function galactus() {
  echo "Installing Homebrew Bundle..."
  brew bundle --no-lock --file=~/Brewfile

  echo "Installing Mac App Store apps..."
  brew bundle --no-lock --file=~/Brewfile-mas

  if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing xcode-select..."
    xcode-select --install
  fi

  if [[ $CATEGORY == "tpm" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Updating tpm plugins..."
    ~/.config/tmux/plugins/tpm/bin/update_plugins all
  fi

  if [[ $CATEGORY == "zinit" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Updating zinit plugins..."
    zinit update
  fi

  echo "Sourcing zshrc..."
  source ~/.zshrc
}

awslogs() {
  set -e
  export AWS_PROFILE=$(cat ~/.aws/config | awk '/^\[profile /{print $2}' | tr -d ']' | fzf)
  local log_group=$(aws logs describe-log-groups | jq -r '.logGroups[].logGroupName' | fzf)
  aws logs tail "$log_group" --since 3h --follow --format=short
}
