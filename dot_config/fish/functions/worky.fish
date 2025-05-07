function worky -d "Manages git worktrees"
    set -l subcommand $argv[1]
    set -l args $argv[2..-1]

    if not command -sq git
        echo "Error: git is not installed. Please install git to use this command."
        return 1
    end

    if not command -sq fzf
        echo "Error: fzf is not installed. Please install fzf to use this command."
        return 1
    end

    switch $subcommand
        case i or init
            echo "Initializing worktree..."
            _worky_init $args
        case ls or list
            _worky_list $args
        case add
            _worky_add $args
        case delete
            _worky_delete $args
        case '*'
            echo "Usage: worktree <setup|add|list|delete>..."
    end
end

function _worky_init -d "Clones a Git repository as a bare repo."
    argparse 'u/url=' -- $argv

    if not set -q _flag_url
        echo "Usage: worktree setup -u <repository_url>"
        return 1
    end

    set -l url $_flag_url
    set -l repo_name (string replace -r '.git$' '' (basename $url))

    echo "Cloning bare repository from '$url' to '$repo_name.git'..."
    git clone --bare "$url" "$repo_name.git"

    if test $status -eq 0
        echo "Bare repository cloned successfully to '$repo_name.git'."
    else
        echo "Error cloning repository. Please check the URL and your network connection."
    end
end

function _worky_add -d "Creates a new Git worktree."
    argparse 'n/name=' 'b/branch=' f/force -- $argv

    if not set -q _flag_name
        echo "Usage: worktree add -n <worktree_name> [-b <branch_name>][-f]"
        return 1
    end

    set -l path $_flag_name
    set -l branch $_flag_branch
    set -l force_flag ""

    if set -q _flag_force
        set force_flag --force
    end

    if string length --quiet $branch
        echo "Creating worktree at '$path' for branch '$branch'..."
        git worktree add $force_flag "$path" -b "$branch"
    else
        echo "Creating worktree at '../$path'..."
        git worktree add "../$path"
    end

    if test $status -eq 0
        echo "Worktree created successfully at '$path'."
    else
        echo "Error creating worktree. Please check the path and branch name."
    end
end

function _worky_list -d "Lists Git worktrees and navigates to the selected one using fzf."
    # check if in git repo
    set -l worktrees (git worktree list --porcelain 2>&1)
    if test $status -ne 0
        echo "No worktrees found in current directory."
        # check if project.git folder exists 
        if test -d "project.git"
            echo "Found project.git. Changing to project.git..."
            cd "project.git"
        else
            echo "This is not a git repository."
            return 1
        end
    end

    set -l selected (git worktree list | sed -r 's/^(.*\/([^[:space:]]* ))/\1 \2/g' | fzf --with-nth=2,4 --height 10 --border --prompt "tree: ")

    if test -z "$selected"
        echo "No worktree selected."
        return 0
    end

    set -l selected_branch (echo $selected | cut -d" " -f3)
    set -l selected_dir (echo $selected | cut -d" " -f1)

    echo "Selected branch: [$selected_branch]. Selected directory: [$selected_dir]"

    cd $selected_dir
    ####################################################### works above here

    #
    # set -l paths
    # for line in $worktrees
    #     echo "Evaluating line: $line"
    #     if string match -q "^worktree " $line
    #         set paths $paths (string trim (string replace "worktree " "" $line))
    #     end
    # end
    # echo "Worktrees found: $paths"

    ########################################################## sorta works above here
    #
    # if not $paths
    #     echo "No worktrees found."
    #     return 0
    # end

    # set -l selected (echo "$paths" | fzf --height $(( (count $paths) + 2 )) --prompt 'Select worktree: ')
    #
    # if test -n "$selected"
    #     if test -d "$selected"
    #         echo "Navigating to '$selected'..."
    #         cd "$selected"
    #     else
    #         echo "Error: Selected path '$selected' is not a valid directory."
    #     end
    # else
    #     echo "No worktree selected."
    # end
end

function _worky_delete -d "Deletes a Git worktree."
    argparse 'p/path=' f/force -- $argv

    if not set -q _flag_path
        echo "Usage: worktree delete -p <worktree_path> [-f]"
        return 1
    end

    set -l worktree_path $_flag_path
    set -l force_flag ""

    if set -q _flag_force
        set force_flag --force
    end

    read -l -P "Are you sure you want to delete the worktree at '$worktree_path'? [y/N]: " confirm

    if test "$confirm" = y -o "$confirm" = Y
        echo "Deleting worktree at '$worktree_path'..."
        git worktree remove $force_flag "$worktree_path"

        if test $status -eq 0
            echo "Worktree at '$worktree_path' deleted successfully."
        else
            echo "Error deleting worktree. Please check the path or try with --force."
        end
    else
        echo "Deletion cancelled."
    end
end
