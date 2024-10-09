function work-add --description "Add a git worktree"
    if test (count $argv) -ne 1
        echo "Usage: work-add <branch-name>"
        return 1
    end

    set branch_name $argv[1]
    git worktree add ../$branch_name
end
