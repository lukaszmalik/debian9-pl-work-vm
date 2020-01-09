#!/bin/bash
wget https://github.com/tmux/tmux/releases/download/3.0a/tmux-3.0a.tar.gz
aunpack tmux-3.0a.tar.gz
cd tmux-3.0a
sudo apt install -y libevent-dev libncurses5-dev
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
# KET+I
