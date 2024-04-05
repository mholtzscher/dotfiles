function standup() {
	# store the current directory
	local current_dir=$(pwd)

	# cd to root of code directory
	cd ~/code

	# run git standup
	git standup -s -m 10

	# return to original directory
	cd "$current_dir"
}

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
	CATEGORY=$(gum choose "all" "brew" "go" "mas" "starship" "xcode" "sdkman")

	if [[ $CATEGORY == "brew" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --title "Installing Homebrew Bundle..." -- brew bundle --no-lock --file=~/Brewfile
	fi

	if [[ $CATEGORY == "go" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --title "Installing protoc-gen-gotag..." -- go install github.com/srikrsna/protoc-gen-gotag@latest
		gum spin --spinner moon --title "Installing godotenv..." -- go install github.com/joho/go-dotenv/cmd/godotenv@latest
		gum spin --spinner moon --title "Installing govulncheck" -- go install golang.org/x/vuln/cmd/govulncheck@latest
	fi

	if [[ $CATEGORY == "mas" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --title "Installing Mac App Store apps..." -- brew bundle --no-lock --file=~/Brewfile-mas
	fi

	if [[ $CATEGORY == "starship" ]] || [[ $CATEGORY == "all" ]]; then
		gum format "Installing starship..."
		curl -sS https://starship.rs/install.sh | sh
	fi

	if [[ $CATEGORY == "xcode" ]] || [[ $CATEGORY == "all" ]]; then
		if ! xcode-select -p >/dev/null 2>&1; then
			gum spin --spinner moon --title "Installing xcode-select..." -- xcode-select --install
		fi
	fi

	if [[ $CATEGORY == "sdkman" ]] || [[ $CATEGORY == "all" ]]; then
		if ! command -v sdk >/dev/null 2>&1; then
			gum format "Installing sdkman..."
			curl -s "https://get.sdkman.io" | sh
		else
			gum format "Updating sdkman..."
			sdk selfupdate
		fi

	fi
}
