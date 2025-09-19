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
        aws configure list-profiles | lines | input list --fuzzy "Select AWS Profile:"
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
      if ($result | get exit_code) != 0 {
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
  # let selected_config = ($configs | input list --fuzzy "Select Neovim config: ")
  
  if ($selected_config | is-not-empty) {
    with-env {NVIM_APPNAME: $selected_config} { nvim ...$args }
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

# def update [] {
#   _neovim_plugins
#   _asdf_plugins
#   _go_tools
#   gum log --time kitchen --level info "Finished"
# }
#
# def _neovim_plugins [] {
#   gum log --time kitchen --level info "Updating neovim plugins"
#   nvim --headless "+Lazy! sync" +qa
# }
#
# def _asdf_plugins [] {
#   gum log --time kitchen --level info "Installing asdf plugins"
#
#   let plugins = [
#     "java", "nodejs", "python", "terraform", "rust", "lua"
#   ]
#
#   $plugins | each { |plugin|
#     gum log --time kitchen --level info $"Installing asdf plugin: ($plugin)"
#     asdf plugin add $plugin
#     gum log --time kitchen --level info $"Installing latest ($plugin)"
#     asdf install $plugin latest
#     gum log --time kitchen --level info $"Setting global ($plugin) to latest"
#     asdf global $plugin latest
#   }
#
#   gum log --time kitchen --level info "Updating asdf plugins"
#   asdf plugin update --all
# }
#
# def _go_tools [] {
#   gum log --time kitchen --level info "Installing go tools"
#
#   let tools = [
#     "github.com/srikrsna/protoc-gen-gotag@latest",
#     "github.com/joho/godotenv/cmd/godotenv@latest", 
#     "golang.org/x/vuln/cmd/govulncheck@latest",
#     "google.golang.org/protobuf/cmd/protoc-gen-go@latest",
#     "connectrpc.com/connect/cmd/protoc-gen-connect-go@latest",
#     "github.com/vektra/mockery/v2@latest",
#     "github.com/pressly/goose/v3/cmd/goose@latest",
#     "github.com/sqlc-dev/sqlc/cmd/sqlc@latest",
#     "github.com/air-verse/air@latest",
#     "github.com/spf13/cobra-cli@latest"
#   ]
#
#   $tools | each { |tool|
#     let tool_name = ($tool | split row "/" | last | split row "@" | first)
#     gum log --time kitchen --level info $"Installing ($tool_name)"
#     go install $tool
#   }
# }
#
# S3 upload function with fzf bucket and file selection
def s3u --env [] {
  # Print current AWS_PROFILE
  let current_profile = if ($env.AWS_PROFILE? | is-empty) { "Not set" } else { $env.AWS_PROFILE }
  print $"Current AWS Profile: ($current_profile)"
  
  # Check if AWS CLI is available
  if (which aws | is-empty) {
    print "Error: AWS CLI is not installed"
    return 1
  }
  
  # Check if fzf is available
  if (which fzf | is-empty) {
    print "Error: fzf is not installed"
    return 1
  }
  
  # Ensure we have an AWS profile set
  if ($env.AWS_PROFILE? | is-empty) {
    print "No AWS profile set. Please set AWS_PROFILE environment variable or use 'sso' alias to select a profile."
    return 1
  }
  
  # Check for valid AWS SSO session
  let session_check = (aws sts get-caller-identity | complete)
  if $session_check.exit_code != 0 {
    print "No valid AWS session found. Attempting SSO login..."
    let login_result = (aws sso login | complete)
    if $login_result.exit_code != 0 {
      print "Failed to login to AWS SSO"
      return 1
    }
    print "Successfully logged in to AWS SSO"
  } else {
    print "Valid AWS session found"
  }
  
  # List S3 buckets and let user select with fzf
  print "Fetching S3 buckets..."
  let buckets_result = (aws s3api list-buckets --query 'Buckets[].Name' --output text | complete)
  if $buckets_result.exit_code != 0 {
    print "Failed to list S3 buckets"
    return 1
  }
  
  let buckets = ($buckets_result.stdout | str trim | split row "\t" | where $it != "")
  if ($buckets | is-empty) {
    print "No S3 buckets found"
    return 1
  }
  
  let selected_bucket = ($buckets | str join "\n" | fzf --prompt="Select S3 bucket: " --height=40% --border)
  if ($selected_bucket | is-empty) {
    print "No bucket selected"
    return
  }
  
  print $"Selected bucket: ($selected_bucket)"
  
  # Use fzf to select a file to upload
  print "Select file to upload..."
  let selected_file = (fd --type f . | fzf --prompt="Select file to upload: " --height=60% --border --preview "bat --color=always --plain --line-range :50 {}" --preview-window "right:50%:wrap")
  if ($selected_file | is-empty) {
    print "No file selected"
    return
  }
  
  if not ($selected_file | path exists) {
    print $"Error: File ($selected_file) does not exist"
    return 1
  }
  
  print $"Selected file: ($selected_file)"
  
  # Get the filename for S3 key
  let file_name = ($selected_file | path basename)
  
  # Confirm upload
  let confirmation = (input $"Upload ($file_name) to s3://($selected_bucket)/($file_name)? (Y/n) ")
  if ($confirmation | str downcase) == "n" {
    print "Upload cancelled"
    return
  }
  
  # Upload the file
  print $"Uploading ($selected_file) to s3://($selected_bucket)/($file_name)..."
  let upload_result = (aws s3 cp $selected_file $"s3://($selected_bucket)/($file_name)" | complete)
  if $upload_result.exit_code == 0 {
    print $"Successfully uploaded ($file_name) to s3://($selected_bucket)/($file_name)"
    print $"S3 URL: https://($selected_bucket).s3.amazonaws.com/($file_name)"
  } else {
    print "Failed to upload file to S3"
    print $upload_result.stderr
    return 1
  }
}

# Retrieve the theme settings
$env.config.color_config =  {
    binary: '#bb9af7'
    block: '#7aa2f7'
    cell-path: '#a9b1d6'
    closure: '#7dcfff'
    custom: '#c0caf5'
    duration: '#e0af68'
    float: '#f7768e'
    glob: '#c0caf5'
    int: '#bb9af7'
    list: '#7dcfff'
    nothing: '#f7768e'
    range: '#e0af68'
    record: '#7dcfff'
    string: '#9ece6a'

    bool: {|| if $in { '#7dcfff' } else { '#e0af68' } }

    datetime: {|| (date now) - $in |
        if $in < 1hr {
            { fg: '#f7768e' attr: 'b' }
        } else if $in < 6hr {
            '#f7768e'
        } else if $in < 1day {
            '#e0af68'
        } else if $in < 3day {
            '#9ece6a'
        } else if $in < 1wk {
            { fg: '#9ece6a' attr: 'b' }
        } else if $in < 6wk {
            '#7dcfff'
        } else if $in < 52wk {
            '#7aa2f7'
        } else { 'dark_gray' }
    }

    filesize: {|e|
        if $e == 0b {
            '#a9b1d6'
        } else if $e < 1mb {
            '#7dcfff'
        } else {{ fg: '#7aa2f7' }}
    }

    shape_and: { fg: '#bb9af7' attr: 'b' }
    shape_binary: { fg: '#bb9af7' attr: 'b' }
    shape_block: { fg: '#7aa2f7' attr: 'b' }
    shape_bool: '#7dcfff'
    shape_closure: { fg: '#7dcfff' attr: 'b' }
    shape_custom: '#9ece6a'
    shape_datetime: { fg: '#7dcfff' attr: 'b' }
    shape_directory: '#7dcfff'
    shape_external: '#7dcfff'
    shape_external_resolved: '#7dcfff'
    shape_externalarg: { fg: '#9ece6a' attr: 'b' }
    shape_filepath: '#7dcfff'
    shape_flag: { fg: '#7aa2f7' attr: 'b' }
    shape_float: { fg: '#f7768e' attr: 'b' }
    shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
    shape_glob_interpolation: { fg: '#7dcfff' attr: 'b' }
    shape_globpattern: { fg: '#7dcfff' attr: 'b' }
    shape_int: { fg: '#bb9af7' attr: 'b' }
    shape_internalcall: { fg: '#7dcfff' attr: 'b' }
    shape_keyword: { fg: '#bb9af7' attr: 'b' }
    shape_list: { fg: '#7dcfff' attr: 'b' }
    shape_literal: '#7aa2f7'
    shape_match_pattern: '#9ece6a'
    shape_matching_brackets: { attr: 'u' }
    shape_nothing: '#f7768e'
    shape_operator: '#e0af68'
    shape_or: { fg: '#bb9af7' attr: 'b' }
    shape_pipe: { fg: '#bb9af7' attr: 'b' }
    shape_range: { fg: '#e0af68' attr: 'b' }
    shape_raw_string: { fg: '#c0caf5' attr: 'b' }
    shape_record: { fg: '#7dcfff' attr: 'b' }
    shape_redirection: { fg: '#bb9af7' attr: 'b' }
    shape_signature: { fg: '#9ece6a' attr: 'b' }
    shape_string: '#9ece6a'
    shape_string_interpolation: { fg: '#7dcfff' attr: 'b' }
    shape_table: { fg: '#7aa2f7' attr: 'b' }
    shape_vardecl: { fg: '#7aa2f7' attr: 'u' }
    shape_variable: '#bb9af7'

    foreground: '#c0caf5'
    background: '#1a1b26'
    cursor: '#c0caf5'

    empty: '#7aa2f7'
    header: { fg: '#9ece6a' attr: 'b' }
    hints: '#414868'
    leading_trailing_space_bg: { attr: 'n' }
    row_index: { fg: '#9ece6a' attr: 'b' }
    search_result: { fg: '#f7768e' bg: '#a9b1d6' }
    separator: '#a9b1d6'
}

