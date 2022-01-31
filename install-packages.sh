#! /bin/bash


install-pipx-packages() {
    if [[ ! -x "$(command -v pipx)" ]]; then
        python3 -m pip install --user pipx
    fi

    local pipx_packages=(black yapf pre-commit tldr flake8)
    for package in pipx_packages; do
        if [[ ! -x "$(command -v "$package")" ]]; then
            pipx install package --include-deps
        fi
    done
}

install-pipx-packages

# install fzf
if [[ ! -x $(command -v fzf) ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
        && ~/.fzf/install
fi

if [[ ! -d ~/.tmp-installation ]]; then
    mkdir "${HOME}/.tmp-installation"
else
    echo "~/.tmp-installation cannot exist" >2
    exit 1
fi
