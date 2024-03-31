function create_ecr_repo() {
	repo=$1
	if [[ -z repo ]]; then
		echo "Usage: create_ecr_repo <repo-name> "
		return
	fi
	aws ecr create-repository --no-cli-pager --repository-name $repo
	echo "ecr repository $repo created"
}

function allow_ecr_repo() {
	repo=$1
	if [[ -z repo ]]; then
		echo "Usage: allow_ecr_repo <repo-name> "
		return
	fi
	aws ecr set-repository-policy --no-cli-pager --repository-name $repo --policy-text "{\"Version\" : \"2012-10-17\",\"Statement\" : [ {\"Sid\" : \"EcrAllowedAccounts\",\"Effect\" : \"Allow\",\"Principal\" : {\"AWS\" : [ \"arn:aws:iam::329295018884:root\", \"arn:aws:iam::471570387468:root\", \"arn:aws:iam::588685079369:root\", \"arn:aws:iam::803458383710:root\", \"arn:aws:iam::053519916355:root\" ]},\"Action\" : [ \"ecr:BatchCheckLayerAvailability\", \"ecr:BatchGetImage\", \"ecr:GetDownloadUrlForLayer\", \"ecr:GetAuthorizationToken\" ]}]}"
	echo "ecr repository $repo is now accessible to all Pepper AWS accounts"
}

function create_allow_ecr_repo() {
	repo=$1
	if [[ -z repo ]]; then
		echo "Usage: create_allow_ecr_repo <repo-name> "
		return
	fi
	create_ecr_repo $repo
	allow_ecr_repo $repo
}

function kctx() {
	local currentCtx=$(kubectl config current-context)
	ctx=$(kubectl config get-contexts -o name | sort -k1 -r | fzf)
	if [[ -z $ctx ]]; then
		echo "nothing selected..."
		return
	fi
	kubectl config use-context $ctx
	echo "switched from $currentCtx to $ctx"
}

function bfg() {
	echo "rm -rf gen"
	rm -rf gen

	echo "buf format --diff -w"
	buf format --diff -w

	echo "buf generate"
	buf generate

	if [[ -f buf.gen.tag.yaml ]]; then
		echo "buf generate --template buf.gen.tag.yaml"
		buf generate --template buf.gen.tag.yaml
	fi

	if [[ -f buf.gen.ruby.yaml ]]; then
		echo "buf generate --template buf.gen.ruby.yaml --include-imports"
		buf generate --template buf.gen.ruby.yaml --include-imports
	fi

	echo "yq e -i '.info.version line_comment="x-release-please-version"' swagger/apidocs.swagger.yaml"
	yq e -i '.info.version line_comment="x-release-please-version"' swagger/apidocs.swagger.yaml
}

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

function download_app_log() {
	app=$1
	if [[ -z $app ]]; then
		echo "Usage: download_app_log <app> <searchTerm (optional)>"
		return
	fi
	query="-q $2"
	if [[ -z $2 ]]; then
		query=""
	fi
	bucket="s3://pepper-app-diagnostic-logs-dev/$app/development/ios/"
	selected=$(aws s3 ls "s3://pepper-app-diagnostic-logs-dev/${app}/development/ios/" | sort -k1 -k2 -r | fzf $query)
	if [[ -z $selected ]]; then
		echo "nothing selected..."
		return
	fi
	selectedFile=$(echo $selected | awk '{print $4}')
	res=$(aws s3 cp "$bucket$selectedFile" $HOME/Downloads)
	downloadedFile="$HOME/Downloads/$selectedFile"
	echo "log file saved to $downloadedFile. Opening..."
	open $downloadedFile
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
	CATEGORY=$(gum choose "all" "brew" "mas" "go" "npm" "starship" "xcode" "asdf")

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

	if [[ $CATEGORY == "npm" ]] || [[ $CATEGORY == "all" ]]; then
		gum spin --spinner moon --title "Installing opencommit..." -- npm install -g opencommit
		gum spin --spinner moon --title "Installing serverless..." -- npm install -g serverless
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
	fi
}
