# Display a message to the user indicating the start of the process.
echo "Attempting to restart Raycast..."

# Find and kill the Raycast process.
# `pkill` sends a signal to processes based on their name.
# The `-f` option matches against the full argument list, which is more reliable for finding Raycast.
# The `-q` option suppresses error messages if no process is found.
pkill -f Raycast

# Check the exit status of the pkill command.
if test $status -eq 0
    echo "Raycast process found and terminated."
else
    echo "Raycast process not found or already terminated."
end

# Wait for a short period to ensure the process has fully terminated.
# This can sometimes prevent issues with relaunching too quickly.
sleep 1

# Relaunch the Raycast application.
# `open -a` opens an application by its name.
# The path to the application might be needed if it's not in a standard location,
# but for most Mac apps, just the name is sufficient.
open -a Raycast

# Check the exit status of the open command.
if test $status -eq 0
    echo "Raycast launched successfully."
else
    echo "Failed to launch Raycast. Make sure it's installed correctly."
end
