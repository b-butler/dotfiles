#! /usr/bin/env bash

function install-module {
    cwd=$(pwd)
    cd "$1"
    installation_script="./setup.sh"
    if [[ -e "./install.sh" ]]; then
        installation_script="./install.sh"
    fi

    if [[ ! -e "$installation_script" ]]; then
        echo "Module ${1} is likely not installed. Skipping..."
    else
        eval "$installation_script"
    fi
    cd "$cwd"
}


# Arguments:
#     $1 original file, expects file to be relative to current directory.
#         Do not include ./ in name. This will work but then the symlink will
#         include the ./.
#     $2 new file to link
# Does nothing when $2 exists and is $1. Always symlinks since git will break
# hardlinks.
function symlink-with-warning {
if [[ ! -e "$1" ]]; then
    echo "${1} does not exist to link to."
    return 1
elif [[ -e "$2"  &&  ! "$2" -ef "$1" ]]; then
    echo "${2} exists and is not ${1}. Cannot safely symlink."
    return 1
elif [[ ! -e "$2" ]]; then
    ln -s "$(pwd)/${1}" "$2" && echo "Linked '${1}' to '${2}'"
fi
}

for module in modules/*; do
    if [[ "$module" == "modules/*" ]]; then
        echo "No modules found in ./modules. Install submodules to install."
        break
    fi
    install-module "$module"
done

for file in dotfiles/{,.[^.]}*; do
    if [[ "$file" == "dotfiles/*" ]]; then
        continue
    fi
    symlink-with-warning "$file" "${HOME}/$(basename ${file})"
done
