
# Test function to detect project type and run appropriate tests
def tst [] {
  if ("go.mod" | path exists) {
    print "go.mod found. Running Go tests..."
    go test ./...
  } else if ("build.gradle" | path exists) or ("build.gradle.kts" | path exists) {
    print "build.gradle found. Running ./gradlew test..."
    ./gradlew test
  } else {
    print "Neither go.mod nor build.gradle found in the current directory."
  }
}

# Format function to detect project type and run appropriate formatter
def fmt [] {
  if ("go.mod" | path exists) {
    print "go.mod found. Running Go formatter..."
    go fmt ./...
  } else if ("build.gradle" | path exists) {
    print "build.gradle found. Running ./gradlew spotlessApply..."
    run-external "./gradlew" "spotlessApply" "--parallel"
  } else {
    print "Neither go.mod nor build.gradle found in the current directory."
  }
}

# AWS profile management with SSO login
def aws_change_profile --env [ profile?: string ] {
    let profile = if ($profile | is-empty) {
        aws configure list-profiles | lines | input list
    } else {
        $profile
    }

    if ($profile | is-empty) {
        print "No profile selected"
        return
    }

    $env.AWS_PROFILE = $profile
    print $"Using AWS profile: ($env.AWS_PROFILE)"

    if (aws configure get sso_start_url --profile $env.AWS_PROFILE | complete | get exit_code ) == 0 {
      let result = aws sts get-caller-identity | complete 
      if (result | get exit_code) == 0 {
          print "Logging into AWS"
          aws sso login
      } else {
          print "Found valid AWS session"
      }
    } else {
      print $"No SSO configuration found for profile: ($env.AWS_PROFILE)"
    }
}

# AWS logout function
def aws_logout --env [] {
  if (aws configure get sso_start_url --profile $env.AWS_PROFILE | complete | get exit_code) == 0 {
    aws sso logout
  }
  hide-env AWS_PROFILE
}

# Watch command - runs a command at specified intervals
def watch [interval: duration, ...command: string] {
  if ($command | is-empty) {
    print "Usage: watch <interval> <command>"
    return 1
  }
  
  loop {
    clear
    run-external ...$command
    sleep $interval
  }
}

# Yazi with directory change support
def --env y [...args: string] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp | str trim)
  if ($cwd != "" and $cwd != $env.PWD) {
    cd $cwd
  }
  rm -f $tmp
}

# Gradle wrapper function
def gradle [...args: string] {
  if ("./gradlew" | path exists) {
    ./gradlew ...$args
  } else {
    print "No gradlew found"
  }
}

# SSH tunnel function
def __ssh_tunnel [key_file: string, local_port: string, endpoint: string, user_hostname: string] {
  ssh -i $key_file -v -N -L $"($local_port):($endpoint)" $user_hostname
}

# List active network interfaces and their IP addresses
def ifactive [] {
  networksetup -listallhardwareports 
  | lines 
  | where $it =~ "^Device:" 
  | each { |line| 
      let interface = ($line | split row " " | get 1)
      let ip = (ipconfig getifaddr $interface | complete | get stdout | str trim)
      if ($ip != "") {
        $"($interface): ($ip)"
      }
    }
  | where $it != null
}

# Add current directory and children to zoxide
def zoxide_register_children [] {
  let target_dir = $env.PWD
  print $"Adding current directory to zoxide: ($target_dir)"
  zoxide add $target_dir
  
  print $"Scanning for child directories in: ($target_dir)"
  let children = (fd --type d --maxdepth 1 . | lines | where $it != "")
  
  if ($children | is-empty) {
    print "No child directories found to add."
  } else {
    $children | each { |child_dir|
      print $"  Adding: ($child_dir)"
      zoxide add $child_dir
    }
    print $"Done. Added ($children | length) child directories to zoxide."
  }
}

# Chezmoi add with fzf selection
def chad [] {
  if (which fzf | is-empty) or (which bat | is-empty) or (which fd | is-empty) {
    print "fzf, bat, or fd is not installed."
    return 1
  }
  
  let selected_files = (fd -t f | fzf -m --height 60% --border --preview "bat --color=always --plain --line-range :50 {}" --preview-window "right:60%:wrap" | lines)
  
  if ($selected_files | is-empty) {
    print "No files selected."
    return
  }
  
  print "The following files will be added to chezmoi:"
  $selected_files | each { |file| print $"  ($file)" }
  
  let confirmation = (input "Proceed with 'chezmoi add'? (Y/n) ")
  
  if ($confirmation | str downcase) != "n" {
    print "Adding files to chezmoi..."
    chezmoi add ...$selected_files
    print "Files successfully added to chezmoi."
  } else {
    print "Operation cancelled by user."
  }
}

# Chezmoi forget with fzf selection
def chf [] {
  if (which fzf | is-empty) or (which bat | is-empty) or (which fd | is-empty) {
    print "fzf, bat, or fd is not installed."
    return 1
  }
  
  let selected_files = (fd -t f | fzf -m --height 60% --border --preview "bat --color=always --plain --line-range :50 {}" --preview-window "right:60%:wrap" | lines)
  
  if ($selected_files | is-empty) {
    print "No files selected."
    return
  }
  
  print "The following files will be forgotten in chezmoi:"
  $selected_files | each { |file| print $"  ($file)" }
  
  let confirmation = (input "Proceed with 'chezmoi forget'? (Y/n) ")
  
  if ($confirmation | str downcase) != "n" {
    print "Forgetting files in chezmoi..."
    chezmoi forget --force ...$selected_files
    print "Files successfully forgotten in chezmoi."
  } else {
    print "Operation cancelled by user."
  }
}

# Restart Raycast
def raycast [] {
  print "Attempting to restart Raycast..."

  let kill_result = (pkill -f Raycast | complete)
  if $kill_result.exit_code == 0 {
    print "Raycast process found and terminated."
  } else {
    print "Raycast process not found or already terminated."
  }

  sleep 1sec

  let open_result = (^open -a Raycast | complete)
  if $open_result.exit_code == 0 {
    print "Raycast launched successfully."
  } else {
    print "Failed to launch Raycast. Make sure it's installed correctly."
  }
}

# Clear Cloudflare cache
def cloudcache [] {
  let api_token = (op item get cloudflare.com --fields cli-api-token --reveal | str trim)
  let zone_id = (op item get cloudflare.com --fields zone-holtzscher-com | str trim)
  let email = (op item get cloudflare.com --fields username | str trim)
  let url = $"https://api.cloudflare.com/client/v4/zones/($zone_id)/purge_cache"
  
  print $"Purging Cloudflare cache for ZONE_ID: ($zone_id)"
  http post --content-type application/json -H {"X-Auth-Email": $email, "Authorization": $"Bearer ($api_token)"} $url {"purge_everything": true}
}

# Select and launch Neovim with specific configuration
def nv [...args: string] {
  let config_dir = $"($env.HOME)/.config"
  let configs = (fd --type d --maxdepth 1 "nvim*" $config_dir | lines | each { |path| $path | path basename } | sort)
  
  if ($configs | is-empty) {
    print $"No Neovim configurations found in ($config_dir)"
    return 1
  }
  
  let selected_config = ($configs | str join "\n" | fzf --prompt="Select Neovim config: " --height=40% --border)
  
  if ($selected_config | is-not-empty) {
    with-env [NVIM_APPNAME $selected_config] { nvim ...$args }
  }
}

# Diff payment schedules from clipboard JSON
def schediff [] {
  # Check dependencies
  if (which jq | is-empty) {
    print "Error: 'jq' is not installed. Please install it to proceed."
    print "On macOS: brew install jq"
    return 1
  }
  
  if (which delta | is-empty) {
    print "Error: 'delta' is not installed. Please install it to proceed."
    print "See installation instructions at: https://github.com/dandavison/delta"
    return 1
  }
  
  # Read from clipboard (macOS)
  if (which pbpaste | is-empty) {
    print "Error: 'pbpaste' command not found. This function is intended for macOS."
    return 1
  }
  
  let json_string = (pbpaste | str trim)
  
  if ($json_string | is-empty) {
    print "Error: Clipboard is empty."
    return 1
  }
  
  # Validate JSON
  let validation = (echo $json_string | jq -e . | complete)
  if $validation.exit_code != 0 {
    print "Error: Clipboard content is not valid JSON."
    return 1
  }
  
  # Check if array has exactly 2 elements
  let array_length = (echo $json_string | jq 'if type == "array" then length else -1 end' | into int)
  
  if $array_length != 2 {
    print $"Error: Expected a JSON array with exactly two objects in the clipboard."
    print $"Found an item with length ($array_length)."
    return 1
  }
  
  # Create temporary files for diff
  let temp1 = (mktemp)
  let temp2 = (mktemp)
  
  echo $json_string | jq '.[0]' | save $temp1
  echo $json_string | jq '.[1]' | save $temp2
  
  delta --side-by-side --diff-args=-U999 --paging=never $temp1 $temp2
  
  rm -f $temp1 $temp2
}

# Update system, neovim plugins, asdf, and go tools
def update [] {
  _neovim_plugins
  _asdf_plugins
  _go_tools
  gum log --time kitchen --level info "Finished"
}

def _neovim_plugins [] {
  gum log --time kitchen --level info "Updating neovim plugins"
  nvim --headless "+Lazy! sync" +qa
}

def _asdf_plugins [] {
  gum log --time kitchen --level info "Installing asdf plugins"
  
  let plugins = [
    "java", "nodejs", "python", "terraform", "rust", "lua"
  ]
  
  $plugins | each { |plugin|
    gum log --time kitchen --level info $"Installing asdf plugin: ($plugin)"
    asdf plugin add $plugin
    gum log --time kitchen --level info $"Installing latest ($plugin)"
    asdf install $plugin latest
    gum log --time kitchen --level info $"Setting global ($plugin) to latest"
    asdf global $plugin latest
  }
  
  gum log --time kitchen --level info "Updating asdf plugins"
  asdf plugin update --all
}

def _go_tools [] {
  gum log --time kitchen --level info "Installing go tools"
  
  let tools = [
    "github.com/srikrsna/protoc-gen-gotag@latest",
    "github.com/joho/godotenv/cmd/godotenv@latest", 
    "golang.org/x/vuln/cmd/govulncheck@latest",
    "google.golang.org/protobuf/cmd/protoc-gen-go@latest",
    "connectrpc.com/connect/cmd/protoc-gen-connect-go@latest",
    "github.com/vektra/mockery/v2@latest",
    "github.com/pressly/goose/v3/cmd/goose@latest",
    "github.com/sqlc-dev/sqlc/cmd/sqlc@latest",
    "github.com/air-verse/air@latest",
    "github.com/spf13/cobra-cli@latest"
  ]
  
  $tools | each { |tool|
    let tool_name = ($tool | split row "/" | last | split row "@" | first)
    gum log --time kitchen --level info $"Installing ($tool_name)"
    go install $tool
  }
}

# SOPS functions for different environments
def sops_staging --env [...args: string] {
  aws_change_profile m3p_staging
  $env.SOPS_KMS_ARN = "arn:aws:kms:us-west-2:211125772151:key/mrk-d167c0b6c99945fabfc4b629d52450ad"
  sops ...$args
}

def sops_uat --env [...args: string] {
  aws_change_profile m3p_uat
  $env.SOPS_KMS_ARN = "arn:aws:kms:us-west-2:590183679435:key/mrk-3c092342ff9a488399c0ffee8e89eb53"
  sops ...$args
}

def sops_production --env [...args: string] {
  aws_change_profile m3p_production
  $env.SOPS_KMS_ARN = "arn:aws:kms:us-west-2:533267267027:key/mrk-17f6bf15417942fd9237ed50d33363ca"
  sops ...$args
}

# Set GitHub PAT from 1Password
def pat --env [] {
  $env.GITHUB_PAT = (op read "op://Personal/Github/paytient-pat")
}

# AWS export environment variables
def aws_export_envs --env [] {
  let credentials = (aws configure export-credentials --profile $env.AWS_PROFILE --format env-no-export | complete | get stdout | lines)
  $credentials | each { |line|
    if ($line | str contains "=") {
      let parts = ($line | split row "=" | str trim)
      if ($parts | length) >= 2 {
        let key = ($parts | first)
        let value = ($parts | skip 1 | str join "=")
        load-env {$key: $value}
      }
    }
  }
}

