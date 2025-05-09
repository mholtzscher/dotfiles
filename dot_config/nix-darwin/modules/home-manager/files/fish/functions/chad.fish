# Ensure fzf is installed
if not command -q fzf
    echo "fzf is not installed. Please install fzf to use this function."
    echo "Installation instructions: https://github.com/junegunn/fzf#installation"
    return 1 # Exit with an error code
end

# Use fzf to select multiple files.
# -m: Enable multi-select (Shift-Tab or Ctrl-Space to mark multiple items)
# --preview: Show a preview of the file content.
# `find . -type f` lists all files in the current directory and subdirectories.

# Determine a preview command
set -l preview_command "head -n 50 {}" # Default to head
if command -q bat
    set preview_command "bat --color=always --plain --line-range :50 {}"
else if command -q highlight
    set preview_command "highlight -O ansi {} || head -n 50 {}"
end

# Let the user know what to do
echo "Use Shift-Tab or Ctrl-Space to select multiple files. Press Enter to confirm selection."
echo "Searching for files in the current directory and subdirectories..."

# Run fzf to select files
set -l selected_files (find . -type f | fzf -m --height 60% --border --preview "$preview_command" --preview-window "right:60%:wrap")

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

# Ask for confirmation, default to Yes (Y/n)
# If the user presses Enter, $confirmation will be empty.
read -P "Proceed with 'chezmoi add'? (Y/n) " -l confirmation

# Corrected condition:
# Proceed unless the user explicitly types 'n' or 'N'.
# `string match -q "n" (string lower -- "$confirmation")` checks if the lowercase confirmation is "n".
# `string match` returns status 0 if it matches (i.e., user entered 'n' or 'N'), and 1 otherwise.
# `if not ...` inverts this, so the block executes if the input is NOT 'n'.
if not string match -q -- n (string lower -- "$confirmation")
    # Add the selected files to chezmoi
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
