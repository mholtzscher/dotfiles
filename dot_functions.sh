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
		echo "buf generate --template buf.gen.ruby.yaml"
		buf generate --template buf.gen.ruby.yaml
	fi
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
