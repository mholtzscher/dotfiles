function work --description "Switch to a git worktree"
    # Get the list of worktrees, each on a new line
    set worktrees (git worktree list --porcelain | awk '/worktree / {print $2}')
    #set worktrees (git worktree list --porcelain | rg '^worktree ' | cut -d' ' -f2)

    # Check if there are any worktrees
    if test (count $worktrees) -eq 0
        echo "No worktrees found."
        return 1
    end

    # Use fzf to select a worktree
    set selected_worktree (printf '%s\n' $worktrees | fzf --height=10 --prompt="Select worktree> ")

    # Check if a worktree was selected
    if test -n "$selected_worktree"
        # Switch to the selected worktree directory
        cd $selected_worktree
    else
        echo "No worktree selected."
        return 1
    end
end
