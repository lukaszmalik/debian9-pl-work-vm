# Dotfiles
    ssh-keygen -F github.com || ssh-keyscan github.com >>~/.ssh/known_hosts
    pip3 install --user dotdrop
    git clone https://github.com/lukaszmalik/dotfiles.git .dotfiles
    ./.dotfiles/dotdrop.sh install -f 
