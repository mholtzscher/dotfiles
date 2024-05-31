function galactus() {
	if ! command -v brew >/dev/null 2>&1; then
		echo "Homebrew is not in PATH"
		return
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
	CATEGORY=$(gum choose "all" "asdf" "brew" "go" "mas" "tpm" "xcode" "zinit")

	if [[ $CATEGORY == "asdf" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --show-output --title "Installing asdf plugin java..." -- asdf plugin add java
		gum spin --spinner moon --show-output --title "Installing asdf plugin nodejs..." -- asdf plugin add nodejs
		gum spin --spinner moon --show-output --title "Installing asdf plugin go..." -- asdf plugin add golang
		gum spin --spinner moon --show-output --title "Installing asdf plugin terraform..." -- asdf plugin add terraform
		gum spin --spinner moon --show-output --title "Installing asdf plugin rust..." -- asdf plugin add rust
		gum spin --spinner moon --show-output --title "Installing asdf plugin gleam..." -- asdf plugin add gleam
		gum spin --spinner moon --show-output --title "Installing asdf plugin erlang..." -- asdf plugin add erlang
		gum spin --spinner moon --show-output --title "Updating asdf plugins..." -- asdf plugin update --all
	fi

	if [[ $CATEGORY == "brew" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --show-output --title "Installing Homebrew Bundle..." -- brew bundle --no-lock --file=~/Brewfile
	fi

	if [[ $CATEGORY == "go" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --show-output --title "Installing protoc-gen-gotag..." -- go install github.com/srikrsna/protoc-gen-gotag@latest
		gum spin --spinner moon --show-output --title "Installing godotenv..." -- go install github.com/joho/go-dotenv/cmd/godotenv@latest
		gum spin --spinner moon --show-output --title "Installing govulncheck" -- go install golang.org/x/vuln/cmd/govulncheck@latest
	fi

	if [[ $CATEGORY == "mas" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --show-output --title "Installing Mac App Store apps..." -- brew bundle --no-lock --file=~/Brewfile-mas
	fi

	if [[ $CATEGORY == "tpm" ]] || [[ $CATEGORY == "all" ]]; then
		~/.config/tmux/plugins/tpm/bin/update_plugins all
	fi

	if [[ $CATEGORY == "xcode" ]] || [[ $CATEGORY == "all" ]]; then
		if ! xcode-select -p >/dev/null 2>&1; then
			gum spin --spinner moon --show-output --title "Installing xcode-select..." -- xcode-select --install
		fi
	fi

	if [[ $CATEGORY == "zinit" ]] || [[ $CATEGORY == "all" ]]; then
		zinit update
	fi
}
