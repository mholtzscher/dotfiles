# Ensure fzf is installed
if not command -q fzf
    echo "fzf is not installed. Please install fzf to use this function."
    echo "Installation instructions: https://github.com/junegunn/fzf#installation"
    return 1 # Exit with an error code
end

# Use fzf to select multiple files.
# -m: Enable multi-select (Shift-Tab or Ctrl-Space to mark multiple items)
# --preview: Show a preview of the file content (requires `bat` or `cat` or similar)
#   We'll use a simple `head` for a basic preview if `bat` isn't available.
#   You can customize the preview command as needed.
# `find . -type f` lists all files in the current directory and subdirectories.
# You might want to adjust the `find` command to suit your needs,
# e.g., to start from your home directory or exclude certain directories.
#
# The selected files will be stored in the `selected_files` variable,
# with each file path on a new line.

# Determine a preview command
set -l preview_command "head -n 50 {}" # Default to head
if command -q bat
    set preview_command "bat --color=always --plain --line-range :50 {}"
else if command -q highlight
    set preview_command "highlight -O ansi {} || head -n 50 {}"
end

# Let the user know what to do
echo "Use Shift-Tab or Ctrl-Space to select multiple files. Press Enter to confirm."
echo "Searching for files in the current directory and subdirectories..."

# Run fzf to select files
# The `find` command starts from the current directory '.'
# -type f specifies that we only want to find files (not directories)
# You can change '.' to '$HOME' or any other path to change the starting search directory.
set -l selected_files (find . -type f | fzf -m --height 40% --border --preview "$preview_command" --preview-window "right:60%:wrap")

# Check if any files were selected
if test -z "$selected_files"
    echo "No files selected."
    return 0 # Exit successfully, as no action was taken
end

# Confirm before adding to chezmoi
echo "The following files will be added to chezmoi:"
for file in $selected_files
    echo "  $file"
end

# Ask for confirmation
read -P "Proceed with 'chezmoi add'? (y/N) " -l confirmation
if test "$confirmation" = y -o "$confirmation" = Y
    # Add the selected files to chezmoi
    # The $selected_files variable is a list, and fish will automatically
    # pass each element as a separate argument to `chezmoi add`.
    echo "Adding files to chezmoi..."
    chezmoi add $selected_files

    # Check the exit status of the chezmoi add command
    if test $status -eq 0
        echo "Files successfully added to chezmoi."
    else
        echo "An error occurred while adding files to chezmoi. Exit status: $status"
        return $status # Propagate the error status
    end
else
    echo "Operation cancelled by user."
end

return 0
