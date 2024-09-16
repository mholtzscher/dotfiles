function aws_logs
    # Check if required tools are installed
    for tool in fzf aws jq
        if not command -v $tool >/dev/null 2>&1
            echo "$tool is not installed. Please install $tool to use this feature."
            return 1
        end
    end

    # Get log groups and select with fzf
    set -l log_group (aws logs describe-log-groups --output json | jq -r '.logGroups[].logGroupName' | fzf --height 40% --reverse --prompt="Select Log Group: ")

    if test -z "$log_group"
        echo "No log group selected."
        return 1
    end

    # Get log streams for the selected log group
    set -l log_stream (aws logs describe-log-streams --log-group-name "$log_group" --output json | jq -r '.logStreams[].logStreamName' | fzf --height 40% --reverse --prompt="Select Log Stream: ")

    if test -z "$log_stream"
        echo "No log stream selected."
        return 1
    end

    echo "Fetching logs... This may take a moment."

    # Get logs and store them in a temporary file
    set -l temp_file (mktemp)
    aws logs get-log-events --log-group-name "$log_group" --log-stream-name "$log_stream" --output json | jq -r '.events[] | "\(.timestamp) \(.message)"' >$temp_file

    # Use fzf to search through the logs
    cat $temp_file | fzf --height 100% --reverse --ansi \
        --preview 'echo {}' \
        --preview-window 'up:50%:wrap' \
        --bind 'ctrl-d:preview-page-down,ctrl-u:preview-page-up' \
        --header 'Press CTRL-D/CTRL-U to scroll preview. Press ENTER to exit.'

    # Clean up
    rm $temp_file
end
