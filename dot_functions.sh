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
	CATEGORY=$(gum choose "all" "brew" "mas" "npm" "starship" "xcode" "asdf")

	if [[ $CATEGORY == "brew" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --title "Installing Homebrew Bundle..." -- brew bundle --no-lock --file=~/Brewfile
	fi

	if [[ $CATEGORY == "mas" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --title "Installing Mac App Store apps..." -- brew bundle --no-lock --file=~/Brewfile-mas
	fi

	if [[ $CATEGORY == "npm" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --title "Installing opencommit..." -- npm install -g opencommit
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

	if [[ $CATEGORY == "asdf" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --title "Updating asdf plugins..." -- asdf plugin update --all
		gum spin --spinner moon --title "Installing asdf plugins...java" -- asdf plugin add java
		gum spin --spinner moon --title "Installing asdf plugins...maven" -- asdf plugin add maven
		gum spin --spinner moon --title "Installing asdf plugins...gradle" -- asdf plugin add gradle
	fi
}
