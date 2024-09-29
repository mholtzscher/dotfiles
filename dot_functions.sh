function galactus() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is not in PATH"
    echo "Installing Homebrew..."
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if ! command -v gum >/dev/null 2>&1; then
    echo "Gum is not in PATH"
    brew install gum
  fi

  gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" --padding "2 4" \
    'Behold Galactus, the Devourer of Worlds!'
  gum format "Choose your configuration weapon:"
  CATEGORY=$(gum choose "all" "asdf" "brew" "go" "lua" "mas" "neovim" "nodejs" "python" "rust" "tpm" "xcode" "zinit")

  if [[ $CATEGORY == "asdf" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Installing asdf plugin java..."
    asdf plugin add java

    echo "Installing asdf plugin nodejs..."
    asdf plugin add nodejs

    echo "Installing asdf plugin python..."
    asdf plugin add python

    echo "Installing asdf plugin terraform..."
    asdf plugin add terraform

    echo "Installing asdf plugin rust..."
    asdf plugin add rust

    echo "Installing asdf plugin lua..."
    asdf plugin add lua

    echo "Updating asdf plugins..."
    asdf plugin update --all
  fi

  if [[ $CATEGORY == "brew" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Installing Homebrew Bundle..."
    brew bundle --no-lock --file=~/Brewfile
  fi

  if [[ $CATEGORY == "go" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Installing protoc-gen-gotag..."
    go install github.com/srikrsna/protoc-gen-gotag@latest

    echo "Installing godotenv..."
    go install github.com/joho/godotenv/cmd/godotenv@latest

    echo "Installing govulncheck..."
    go install golang.org/x/vuln/cmd/govulncheck@latest

    echo "Install protoc-gen-go..."
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

    echo "Installing protoc-gen-connect-go..."
    go install connectrpc.com/connect/cmd/protoc-gen-connect-go@latest

    echo "Installing mockery..."
    go install github.com/vektra/mockery/v2@latest

    echo "Installing goose..."
    go install github.com/pressly/goose/v3/cmd/goose@latest

    echo "Installing sqlc..."
    go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest

    echo "Installing air..."
    go install github.com/air-verse/air@latest

    echo "Installing cobra-cli..."
    go install github.com/spf13/cobra-cli@latest
  fi

  if [[ $CATEGORY == "lua" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Installina lua..."
    asdf install lua latest

    echo "Setting lua to latest..."
    asdf global lua latest
  fi

  if [[ $CATEGORY == "mas" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Installing Mac App Store apps..."
    brew bundle --no-lock --file=~/Brewfile-mas
  fi

  if [[ $CATEGORY == "neovim" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Installing neovim plugins..."
    nvim --headless "+Lazy! sync" +qa
  fi

  if [[ $CATEGORY == "nodejs" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Installing nodejs..."
    asdf install nodejs latest

    echo "Setting nodejs to latest..."
    asdf global nodejs latest
  fi

  if [[ $CATEGORY == "python" ]] || [[ $CATEGORY == "all" ]]; then
    echo "installing python..."
    asdf install python latest

    echo "Setting python to latest..."
    asdf global python latest
  fi

  if [[ $CATEGORY == "rust" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Installina rust..."
    asdf install rust latest

    echo "Setting rust to latest..."
    asdf global latest
  fi

  if [[ $CATEGORY == "tpm" ]] || [[ $CATEGORY == "all" ]]; then
    echo "Updating tpm plugins..."
    ~/.config/tmux/plugins/tpm/bin/update_plugins all
  fi

  if [[ $CATEGORY == "xcode" ]] || [[ $CATEGORY == "all" ]]; then
    if ! xcode-select -p >/dev/null 2>&1; then
      echo "Installing xcode-select..."
      xcode-select --install
    fi
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
