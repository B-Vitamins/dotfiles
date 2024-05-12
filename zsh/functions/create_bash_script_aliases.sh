# Dynamically creates aliases for all Bash scripts in ~/bash-scripts
function create_bash_script_aliases {
    local script_dir="$HOME/bash-scripts"
    for script in "$script_dir"/*.sh; do
        local script_name="$(basename "${script%.sh}")"
        alias "$script_name=bash $script"
    done
}
