function work-del --description "Remove a git worktree"
    # Get the list of worktrees
    set worktrees (git worktree list --porcelain | awk '/worktree / {print $2}')

    # Check if there are any worktrees
    if test (count $worktrees) -eq 0
        echo "No worktrees found."
        return 1
    end

    # Use fzf to select a worktree
    set selected_worktree (printf '%s\n' $worktrees | fzf --height=10 --prompt="Select worktree> ")

    # Check if a worktree was selected
    if test -n "$selected_worktree"
        # Remove the selected worktree directory
        git worktree remove $selected_worktree
    else
        echo "No worktree selected."
        return 1
    end
end
