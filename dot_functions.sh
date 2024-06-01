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
		echo "Installing asdf plugin java..."
		asdf plugin add java

		echo "Installing asdf plugin nodejs..."
		asdf plugin add nodejs

		echo "Installing asdf plugin go..."
		asdf plugin add golang

		echo "Installing asdf plugin terraform..."
		asdf plugin add terraform

		echo "Installing asdf plugin rust..."
		asdf plugin add rust

		echo "Installing asdf plugin gleam..."
		asdf plugin add gleam

		echo "Installing asdf plugin erlang..."
		asdf plugin add erlang

		echo "Updating asdf plugins..."
		asdf plugin update --all
	fi

	if [[ $CATEGORY == "brew" ]] || [[ $CATEGORY == "all" ]]; then
		echo "Installing Homebrew Bundle..."
		brew bundle --no-lock --file=~/Brewfile
	fi

	if [[ $CATEGORY == "go" ]] || [[ $CATEGORY == "all" ]]; then
		echo "Setting golang to latest..."
		asdf global golang latest

		echo "Installing protoc-gen-gotag..."
		go install github.com/srikrsna/protoc-gen-gotag@latest

		echo "Installing godotenv..."
		go install github.com/joho/go-dotenv/cmd/godotenv@latest

		echo "Installing govulncheck"
		go install golang.org/x/vuln/cmd/govulncheck@latest
	fi

	if [[ $CATEGORY == "mas" ]] || [[ $CATEGORY == "all" ]]; then
		echo "Installing Mac App Store apps..."
		brew bundle --no-lock --file=~/Brewfile-mas
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
}
